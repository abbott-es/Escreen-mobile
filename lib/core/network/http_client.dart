import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/network/types.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart' show PrettyDioLogger;

class AppHttpClient {
  AppHttpClient({
    required HttpOptions options,
    this.tokenStore,
    bool enableLogging = true,
  }) : _options = options {
    final baseOptions = BaseOptions(
      baseUrl: options.baseUrl ?? '',
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      headers: Map<String, Object?>.from(options.defaultHeaders),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      listFormat: options.listFormat,
    );

    dio = Dio(baseOptions);

    if (enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: false,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (opts, handler) {},
        onResponse: (res, handler) {
          _options.onResponse?.call(res);
          handler.next(res);
        },
        onError: (err, handler) async {
          _options.onError?.call(err, this);

          if (_options.onErrorHandler != null) {
            try {
              final recovered = await _options.onErrorHandler!(err, this);
              if (recovered != null) {
                return handler.resolve(recovered);
              }
            } catch (e, st) {
              log('onErrorHandler threw: $e\n$st');
            }
          }
          handler.next(err);
        },
      ),
    );
  }

  final HttpOptions _options;
  final AuthTokenStore? tokenStore;
  late final Dio dio;
  Completer<void>? _refreshCompleter;
  CancelToken cancelToken() => CancelToken();

  void updateHeaders(Map<String, Object?> headers) {
    dio.options.headers = {...dio.options.headers, ...headers};
  }

  Future<void> setAuthToken(String? token) async {
    if (token == null) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<R> get<R>(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    R Function(dynamic data)? decoder,
    Options? options,
  }) async {
    final res = await dio.get(
      path,
      queryParameters: query,
      cancelToken: cancelToken,
      options: options,
    );
    return _decode<R>(res, decoder);
  }

  Future<R> post<R>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    R Function(dynamic data)? decoder,
    Options? options,
  }) async {
    final res = await dio.post(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      options: options,
    );
    return _decode<R>(res, decoder);
  }

  Future<R> put<R>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    R Function(dynamic data)? decoder,
    Options? options,
  }) async {
    final res = await dio.put(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      options: options,
    );
    return _decode<R>(res, decoder);
  }

  Future<R> delete<R>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    R Function(dynamic data)? decoder,
    Options? options,
  }) async {
    final res = await dio.delete(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      options: options,
    );
    return _decode<R>(res, decoder);
  }

  R _decode<R>(Response res, R Function(dynamic data)? decoder) {
    final data = res.data;
    if (decoder != null) return decoder(data);
    return data as R;
  }

  Future<void> _injectAuthHeader(RequestOptions options) async {
    if (tokenStore == null) return;
    final token = await tokenStore!.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<bool> refreshTokenAndSetHeader({
    required Future<Map<String, String>?> Function() doRefresh,
  }) async {
    if (_refreshCompleter != null) {
      await _refreshCompleter!.future;
      return (await tokenStore?.readAccessToken())?.isNotEmpty == true;
    }

    _refreshCompleter = Completer<void>();
    try {
      final tokens = await doRefresh();
      if (tokens == null) {
        await tokenStore?.clearTokens();
        await setAuthToken(null);
        return false;
      }

      await tokenStore?.writeTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
      );
      await setAuthToken(tokens['accessToken']);
      return true;
    } finally {
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }
}
