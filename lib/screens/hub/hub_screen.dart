import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/layout/app_shell.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class HubScreen extends StatelessWidget {
  static const route = '/hub';
  const HubScreen({super.key, required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: auth.isAuthenticatedListenable,
      builder: (context, isAuthed, _) {
        if (!isAuthed) {
          return const LoginScreen();
        }
        return ValueListenableBuilder(
          valueListenable: auth.roleListenable,
          builder: (context, role, _) {
            if (role == null) {
              return const Center(child: CircularProgressIndicator());
            } //show splashscreen if it is still parsing.
            return AppShell(role: role);
          },
        );
      },
    );
  }
}
