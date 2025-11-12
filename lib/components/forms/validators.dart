import 'dart:async';
import '../../core/business/regex_patterns.dart';

typedef SyncValidator<T> = String? Function(T value);
typedef AsyncValidator<T> = Future<String?> Function(T value);

SyncValidator<T> vAll<T>(List<SyncValidator<T>> validators) {
  return (T value) {
    for (final v in validators) {
      final res = v(value);
      if (res != null && res.isNotEmpty) return res;
    }
    return null;
  };
}

AsyncValidator<T> vAllAsync<T>(List<AsyncValidator<T>> validators) {
  return (T value) async {
    for (final v in validators) {
      final res = await v(value);
      if (res != null && res.isNotEmpty) return res;
    }
    return null;
  };
}

SyncValidator<String> vRequired({String message = 'The field is required'}) {
  return (value) => value.trim().isEmpty ? message : null;
}

SyncValidator<String> vMinLength(int min, {String? message}) {
  return (value) => value.length < min
      ? (message ?? 'Must be atleast $min characters')
      : null;
}

SyncValidator<String> vMaxLength(int max, {String? message}) {
  return (value) => value.length > max
      ? (message ?? 'Must be at most $max characters')
      : null;
}

SyncValidator<String> vEmail({
  String message = 'Enter a valid email address ',
}) {
  return (value) => value.trim().isEmpty || RegexPatterns.email.hasMatch(value)
      ? null
      : message;
}

SyncValidator<String> vStrongPassword({
  int minLength = 8,
  bool requireUpper = true,
  bool requireLower = true,
  bool requireDigit = true,
  bool requireSymbol = true,
  String message = 'Use a strong password',
}) {
  return (value) {
    if (value.length < minLength) {
      return 'Must be atleast $minLength characters';
    }
    if (requireUpper && !value.contains(RegexPatterns.uppercase)) {
      return 'Add atleast one uppercase letter';
    }
    if (requireLower && !value.contains(RegexPatterns.lowercase)) {
      return 'Add atleast one lowercase letter';
    }
    if (requireDigit && !value.contains(RegexPatterns.digit)) {
      return 'Add atleast one number';
    }
    if (requireSymbol && !value.contains(RegexPatterns.symbol)) {
      return 'Add atleast one symbol';
    }
    return null;
  };
}

SyncValidator<String> vMatches(
  String Function() other, {
  String message = 'Values do not match',
}) {
  return (value) => value == other() ? null : message;
}
