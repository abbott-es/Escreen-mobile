import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/api/types.dart';
import 'package:flutter_application_1/core/bootstrap/storage.dart';
import 'package:flutter_application_1/core/utils/model_factory_registry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/http_client.dart';
import '../network/types.dart';
import '../network/error_normalizer.dart';
import '../api/api.dart';

class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5244',
  );
  static const nodeEnv = String.fromEnvironment(
    'NODE_ENV',
    defaultValue: 'development',
  );
  static int get startSessionCheckAfterMinutes =>
      nodeEnv == 'development' ? 2 : 1;
  static const roleClaimsUrl = String.fromEnvironment(
    'ROLE_URL',
    defaultValue: 'http://schemas.microsoft.com/ws/2008/06/identity/claims',
  );
}

late final AppHttpClient http;
late final Api api;

Future<void> initApiLayer() async {
  const storage = FlutterSecureStorage();
  final tokenStore = SecureStorageTokenStore(storage);

  ModelFactoryRegistry.register<AuthTokens>((m) => AuthTokens.fromJson(m));

  http = AppHttpClient(
    tokenStore: tokenStore,
    options: HttpOptions(
      baseUrl: Env.apiBaseUrl,
      defaultHeaders: {'ENV': Env.nodeEnv},
      onRequest: (opts) {
        log(
          '${opts.method} ${opts.baseUrl}${opts.path}query=${opts.queryParameters}',
        );
      },
      onResponse: (res) {
        log('${res.statusCode} ${res.requestOptions.path}');
      },
      onError: (err, _) {
        log(
          '${err.requestOptions.method} ${err.requestOptions.path} -> ${err.response?.statusCode} ${err.message}',
        );
      },
      onErrorHandler: (err, http) async {
        final isUnauthorized = err.response?.statusCode == 401;
        final triedRefresh =
            (err.requestOptions.extra['__triedRefresh'] == true);
        if (isUnauthorized && !triedRefresh) {
          final ok = await http.refreshTokenAndSetHeader(
            doRefresh: () async {
              final tmpApi = Api(http);
              final refreshToken = await http.tokenStore?.readRefreshToken();

              if (refreshToken == null || refreshToken.isEmpty) {
                return null;
              }

              final refreshCb = await tmpApi.auth.refreshToken(
                refreshToken: refreshToken,
              );
              await http.tokenStore?.writeTokens(
                accessToken: refreshCb.response.accessToken,
                refreshToken: refreshCb.response.refreshToken,
              );

              return {
                'Authorization': 'Bearer ${refreshCb.response.accessToken}',
              };
            },
          );

          if (ok) {
            final req = err.requestOptions;
            final clone = Options(
              method: req.method,
              headers: {
                ...req.headers,
                if (req.extra case final e) ...e,
                '__triedRefresh': true,
              },
              responseType: req.responseType,
              contentType: req.contentType,
              followRedirects: req.followRedirects,
              validateStatus: req.validateStatus,
              receiveDataWhenStatusError: req.receiveDataWhenStatusError,
              listFormat: req.listFormat,
              sendTimeout: req.sendTimeout,
              receiveTimeout: req.receiveTimeout,
            );

            return http.dio.request(
              req.path,
              data: req.data,
              queryParameters: req.queryParameters,
              options: clone,
              cancelToken: req.cancelToken,
              onReceiveProgress: req.onReceiveProgress,
              onSendProgress: req.onSendProgress,
            );
          }
        }
        return null;
      },
    ),
    enableLogging: true,
  );

  api = Api(http);
}

Future<R> useApi<R>(Future<R> Function(Api api) fn) async {
  try {
    return await fn(api);
  } on DioException catch (e) {
    throw normalizeDioError(e);
  }
}

class ApiCallback<R, A> {
  ApiCallback(this._fn);
  final Future<R> Function(Api api, A args) _fn;
  CancelToken? _token;

  Future<R> call(A args) async {
    _token?.cancel('superseded');
    _token = CancelToken();
    try {
      return await _fn(api, args);
    } on DioException catch (e) {
      throw normalizeDioError(e);
    }
  }
}

ApiCallback<R, A> useApiCallback<R, A>(Future<R> Function(Api api, A args) fn) {
  return ApiCallback<R, A>(fn);
}
