import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/core/api/types.dart';
import '../../api/api.dart';
import '../../bootstrap/api_bootstrap.dart';
import '../../network/types.dart';
import '../../network/error_normalizer.dart';
import 'auth_service.dart';

class AuthController extends ChangeNotifier implements AuthService {
  final Api api;
  final AuthTokenStore tokenStore;

  AuthController({required this.api, required this.tokenStore}) {
    _bootstrap();
  }

  String? _access;
  String? _refresh;
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  int _ops = 0;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isAuthenticating => _isAuthenticating;

  @override
  bool get loading => _ops > 0;

  final ValueNotifier<bool> _isAuthVN = ValueNotifier(false);
  @override
  ValueListenable<bool> get isAuthenticatedListenable => _isAuthVN;

  void _inc() {
    _ops++;
    notifyListeners();
  }

  void _dec() {
    _ops = (_ops - 1).clamp(0, 1 << 20);
    notifyListeners();
  }

  Future<void> _bootstrap() async {
    _access = await tokenStore.readAccessToken();
    _refresh = await tokenStore.readRefreshToken();
    _setAuthFlag(_access != null && _access!.isNotEmpty);
  }

  void _setAuthFlag(bool v) {
    _isAuthenticated = v;
    _isAuthVN.value = v;
    notifyListeners();
  }

  final _loginCb = useApiCallback<LoginResponse, LoginOptions>(
    (api, p) async => await api.auth.login(params: p),
  );

  @override
  Future<void> login({required LoginOptions options}) async {
    if (_isAuthenticating) return;
    _isAuthenticating = true;
    _inc();
    try {
      final data = await _loginCb(options);
      _access = data.response.accessToken;
      _refresh = data.response.refreshToken;

      await tokenStore.writeTokens(
        accessToken: _access,
        refreshToken: _refresh,
      );
      _setAuthFlag(true);
    } on DioException catch (e) {
      await _clearLocal();
      throw normalizeDioError(e);
    } finally {
      await _clearLocal();
      _setAuthFlag(false);
      _dec();
    }
  }

  @override
  Future<void> softLogout() async {
    await _clearLocal();
    _setAuthFlag(false);
  }

  Future<void> _clearLocal() async {
    _access = null;
    _refresh = null;
    await tokenStore.clearTokens();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
