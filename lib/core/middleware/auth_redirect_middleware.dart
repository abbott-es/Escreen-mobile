import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';

class AuthRedirectMiddleware extends FlutterMiddleware {
  final AuthController auth;
  AuthRedirectMiddleware(this.auth);

  @override
  Future<bool> check(RequestData data) async {
    return auth.isAuthenticated;
  }

  @override
  Future<void> denied(RequestData data) async {
    final nav = Middleware.state.navigatorKey?.currentState;
    nav?.pushNamedAndRemoveUntil('/login', (route) => false);
    return super.denied(data);
  }
}
