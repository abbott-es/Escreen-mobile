import 'package:flutter/widgets.dart';
import 'auth_controller.dart';
import 'auth_service.dart';

class AuthProvider extends InheritedNotifier<AuthController> {
  const AuthProvider({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    if (scope == null) {
      throw FlutterError(
        'AuthProvider.of() called with a context that does not contain AuthProvider.',
      );
    }
    return scope.notifier!;
  }

  static AuthService? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>()?.notifier;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) =>
      notifier != oldWidget.notifier;
}
