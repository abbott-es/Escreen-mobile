import 'package:flutter/material.dart';
import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';
import 'package:flutter_application_1/core/middleware/role_guard_middleware.dart';

class NavigationController extends Controllers {
  static late final NavigationController state;
  final AuthController auth;

  NavigationController._(this.auth) {
    addMiddleware([RoleGuardMiddleware(auth)]);
  }

  static void init(AuthController auth) {
    state = NavigationController._(auth);
  }

  Future<void> goToDriverHub() async {
    final nav = Middleware.state.navigatorKey?.currentState;
    await nav?.pushReplacementNamed('/driver/hub');
  }

  Future<void> goToPassengerHub() async {
    final nav = Middleware.state.navigatorKey?.currentState;
    await nav?.pushReplacementNamed('/passenger/hub');
  }

  Future<void> openDetails(BuildContext context, String title) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _DetailsPage(title: title)));
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
