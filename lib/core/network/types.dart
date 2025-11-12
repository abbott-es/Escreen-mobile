import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/network/http_client.dart';

typedef OnRequest = void Function(RequestOptions options);
typedef OnResponse = void Function(Response response);
typedef OnError = void Function(DioException err, AppHttpClient http);

typedef OnErrorHandler =
    Future<Response?> Function(DioException err, AppHttpClient http);

abstract class AuthTokenStore {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeTokens({String? accessToken, String? refreshToken});
  Future<void> clearTokens();
}

class NormalizedError implements Exception {
  NormalizedError(this.codes, {this.status, this.message});
  final List<String> codes;
  final int? status;
  final String? message;

  @override
  String toString() =>
      'Normalized(status: $status, codes: $codes, message: $message)';
}

class HttpOptions {
  HttpOptions({
    this.baseUrl,
    this.defaultHeaders = const {},
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
    this.onRequest,
    this.onResponse,
    this.onError,
    this.onErrorHandler,
    this.listFormat = ListFormat.multiCompatible,
  });

  final String? baseUrl;
  final Map<String, Object?> defaultHeaders;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  final OnRequest? onRequest;
  final OnResponse? onResponse;
  final OnError? onError;
  final OnErrorHandler? onErrorHandler;

  final ListFormat listFormat;
}
