import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/core/api/types.dart';

abstract class AuthService {
  bool get isAuthenticated;
  bool get isAuthenticating;
  bool get loading;
  ValueListenable<bool> get isAuthenticatedListenable;

  Future<void> login({required LoginOptions options});
  Future<void> logout();
  Future<void> softLogout();
}
