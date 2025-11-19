import 'package:flutter/material.dart';
import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';

class RoleGuardMiddleware extends FlutterMiddleware {
  final AuthController auth;
  RoleGuardMiddleware(this.auth);

  @override
  Future<bool> check(RequestData data) async {
    final payload = data.data;
    final requiredRole = (payload is RouteIntent) ? payload.requiredRole : null;
    if (requiredRole == null) return true;
    return auth.role == requiredRole;
  }

  @override
  Future<void> denied(RequestData data) async {
    final nav = Middleware.state.navigatorKey?.currentState;
    final ctx = nav?.context;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Access denied: wrong role')),
      );
    }
    return super.denied(data);
  }
}

class RouteIntent {
  final String? routeName;
  final AppRole? requiredRole;
  final Object? arguments;

  const RouteIntent({this.routeName, this.requiredRole, this.arguments});
}
