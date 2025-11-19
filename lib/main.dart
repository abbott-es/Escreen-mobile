import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/layout/app_shell.dart';
import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/core/controllers/navigation_controller.dart';
import 'package:flutter_application_1/core/middleware/auth_redirect_middleware.dart';
import 'package:flutter_application_1/core/services/auth/app/auth_gate.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';
import 'package:flutter_application_1/core/services/auth/auth_provider.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_middleware/middleware.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApiLayer();

  final auth = AuthController(api: api, tokenStore: http.tokenStore);

  Middleware.state.set(
    $middlewares: [AuthRedirectMiddleware(auth)],
    $navigatorKey: navigatorKey,
  );

  NavigationController.init(auth);

  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      controller: auth,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: AuthGate(auth: auth),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/driver/hub': (_) => const AppShell(role: AppRole.driver),
          '/passenger/hub': (_) => const AppShell(role: AppRole.passenger),
        },
      ),
    );
  }
}
