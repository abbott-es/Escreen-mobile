import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/app_button.dart';
import 'package:flutter_application_1/components/forms/app_password_field.dart';
import 'package:flutter_application_1/components/forms/app_text_field.dart';
import 'package:flutter_application_1/components/forms/validators.dart';
import 'package:flutter_application_1/core/api/types.dart';
import 'package:flutter_application_1/core/services/auth/auth_provider.dart';

Future<String> fetchSomething() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return 'Lols';
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _unameCtrl.dispose();
    _passCtrl.dispose();
    _usernameFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = AuthProvider.of(context);
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userName = _unameCtrl.text.trim();
    final password = _passCtrl.text;

    try {
      await auth.login(
        options: LoginOptions(userName: userName, password: password),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primaryContainer.withOpacity(0.6),
              scheme.surface.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: scheme.primary,
                      child: Icon(Icons.lock_outline, color: scheme.onPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text('Escreen', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Username',
                      hint: '(e.g., John Doe)',
                      controller: _unameCtrl,
                      focusNode: _usernameFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      prefixIcon: const Icon(Icons.verified_user_outlined),
                      validator: vAll<String>([
                        vRequired(message: 'Username is required'),
                      ]),
                      autofillHints: const [AutofillHints.username],
                      onSubmitted: (_) => _passFocus.requestFocus(),
                    ),
                    const SizedBox(height: 12),
                    AppPasswordField(
                      label: 'Password',
                      controller: _passCtrl,
                      focusNode: _passFocus,
                      textInputAction: TextInputAction.done,
                      validator: vAll<String>([
                        vRequired(message: 'Password is required'),
                      ]),
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Sign in',
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.lg,
                      fullWidth: true,
                      icon: const Icon(Icons.login),
                      onPressedAsync: _submit,
                      loading: auth.loading,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: auth.loading
                              ? null
                              : () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Forgot password tapped'),
                                      ),
                                    ),
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                    MediaQuery.of(context).viewInsets.bottom > 0
                        ? const SizedBox(height: 8)
                        : const SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
