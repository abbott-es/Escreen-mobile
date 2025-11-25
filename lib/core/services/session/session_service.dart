import 'dart:async';
import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';

class SessionService {
  final AuthController authController;
  Timer? _idleTimer;
  Timer? _keepAliveTimer;
  DateTime _lastActivity = DateTime.now();

  static final Duration idleTimeout = Duration(
    minutes: Env.startSessionCheckAfterMinutes,
  );
  static final Duration keepAliveInterval = Duration(
    minutes: Env.startSessionCheckAfterMinutes,
  );

  SessionService({required this.authController});

  void start() {
    _resetIdleTimer();
    _startKeepAliveTimer();
  }

  void stop() {
    _idleTimer?.cancel();
    _keepAliveTimer?.cancel();
  }

  void onUserAction() {
    _lastActivity = DateTime.now();
    _resetIdleTimer();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(idleTimeout, _checkSession);
  }

  void _startKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(keepAliveInterval, (_) async {
      if (DateTime.now().difference(_lastActivity) < idleTimeout) {
        try {
          await useApi((api) => api.auth.keepAlive());
        } catch (_) {
          await _handleSessionExpired();
        }
      }
    });
  }

  Future<void> _checkSession() async {
    try {
      await useApi((api) => api.auth.session());
      _resetIdleTimer();
    } catch (_) {
      await _handleSessionExpired();
    }
  }

  Future<void> _handleSessionExpired() async {
    stop();
    await authController.logout();
  }
}
