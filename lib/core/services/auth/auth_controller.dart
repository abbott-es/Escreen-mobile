import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/api/types.dart';
import 'package:flutter_application_1/core/business/auth/jwt_utils.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/core/api/api.dart';
import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';
import 'package:flutter_application_1/core/network/types.dart';
import 'package:flutter_application_1/core/network/error_normalizer.dart';
import 'auth_service.dart';

class AuthController extends ChangeNotifier implements AuthService {
  final Api api;
  final AuthTokenStore? tokenStore;

  AuthController({required this.api, required this.tokenStore}) {
    _bootstrap();
  }

  String? _access;
  String? _refresh;
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  int _ops = 0;

  AppRole? _role;
  final ValueNotifier<AppRole?> _roleVN = ValueNotifier<AppRole?>(null);

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isAuthenticating => _isAuthenticating;

  @override
  bool get loading => _ops > 0;

  final ValueNotifier<bool> _isAuthVN = ValueNotifier(false);
  @override
  ValueListenable<bool> get isAuthenticatedListenable => _isAuthVN;
  ValueListenable<AppRole?> get roleListenable => _roleVN;
  AppRole? get role => _role;

  void _inc() {
    _ops++;
    notifyListeners();
  }

  void _dec() {
    _ops = (_ops - 1).clamp(0, 1 << 20);
    notifyListeners();
  }

  Future<void> _bootstrap() async {
    _access = await tokenStore?.readAccessToken();
    _refresh = await tokenStore?.readRefreshToken();

    if (_access != null && _access!.isNotEmpty) {
      _parseAndSetRoleFromAccess(_access!);

      try {
        final claims = decodeJwtPayload(_access!);
        final exp = extractExpiry(claims);
        if (exp != null && DateTime.now().toUtc().isAfter(exp)) {
          await _clearLocal();
          _setAuthFlag(false);
          return;
        }
      } catch (_) {}
      _setAuthFlag(true);
    } else {
      _setAuthFlag(false);
    }
  }

  void _setAuthFlag(bool v) {
    _isAuthenticated = v;
    _isAuthVN.value = v;
    notifyListeners();
  }

  void _setRole(AppRole? r) {
    _role = r;
    _roleVN.value = r;
    notifyListeners();
  }

  void _parseAndSetRoleFromAccess(String access) {
    try {
      final claims = decodeJwtPayload(access);
      final roleStr = extractRoleClaim(claims);
      if (roleStr != null) {
        final mapped = roleFromString(roleStr);
        _setRole(mapped);
      } else {
        _setRole(null);
      }
    } catch (e, st) {
      debugPrint('failed to decode token for role: $e\n$st');
      _setRole(null);
    }
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

      await tokenStore?.writeTokens(
        accessToken: _access,
        refreshToken: _refresh,
      );

      _parseAndSetRoleFromAccess(_access!);
      _setAuthFlag(true);
      HapticFeedback.selectionClick();
    } on DioException catch (e) {
      await _clearLocal();
      throw normalizeDioError(e);
    } catch (e, st) {
      await _clearLocal();
      log('login error: $e\n$st');
      rethrow;
    } finally {
      _isAuthenticating = false;
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
    await tokenStore?.clearTokens();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
