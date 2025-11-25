import 'package:flutter_application_1/core/api/types.dart';
import '../../network/http_client.dart';

class AuthenticationApi {
  AuthenticationApi(this.http);
  final AppHttpClient http;

  Future<void> session() async {
    await http.get('/authentication-api/api/sso/session');
  }

  Future<void> keepAlive() async {
    await http.post('/authentication-api/api/sso/session/keep-alive');
  }

  Future<RefreshTokenResponse> refreshToken({required String refreshToken}) {
    return http.post<AuthTokens>(
      '/authentication-api/api/authentication/refresh-token',
      data: {refreshToken: refreshToken},
    );
  }

  Future<LoginResponse> login({required LoginOptions params}) {
    return http.post<AuthTokens>(
      '/authentication-api/api/authentication/login',
      data: {'Username': params.userName, 'Password': params.password},
    );
  }

  Future<void> logout({required LogoutParams params}) {
    return http.post(
      '/authentication-api/api/authentication/logout',
      data: params,
    );
  }

  Future<CreateSessionResponse> createSession({
    required SsoSessionParams params,
  }) {
    return http.post<AuthTokens>(
      '/authentication-api/api/sso/session/create-session',
      data: params,
    );
  }
}
