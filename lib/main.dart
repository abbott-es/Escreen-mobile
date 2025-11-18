import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';
import 'package:flutter_application_1/core/services/auth/app/auth_gate.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';
import 'package:flutter_application_1/core/services/auth/auth_provider.dart';
import 'package:flutter_application_1/screens/hub/hub_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApiLayer();

  final auth = AuthController(api: api, tokenStore: http.tokenStore);

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
        debugShowCheckedModeBanner: false,
        home: AuthGate(auth: auth),
      ),
    );
  }
}
