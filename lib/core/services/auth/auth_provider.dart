import 'package:flutter/widgets.dart';
import 'auth_controller.dart';
import 'auth_service.dart';

class AuthProvider extends InheritedNotifier<AuthController> {
  AuthProvider({
    super.key,
    required AuthController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AuthService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    if (scope == null) {
      throw FlutterError(
        'AuthProvider.of() called with a context that does not contain AuthProvider.',
      );
    }
    return scope.notifier!;
  }
}
