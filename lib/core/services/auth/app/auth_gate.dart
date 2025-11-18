import 'package:flutter/material.dart';
import '../auth_controller.dart';
import 'package:flutter_application_1/screens/hub/hub_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return HubScreen(auth: auth);
  }
}
