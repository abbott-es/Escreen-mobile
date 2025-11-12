class RegexPatterns {
  static final specialChars = RegExp(
    r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;\/`~]',
  );
  static final symbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;\/`~]');
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final uppercase = RegExp(r'[A-Z]');
  static final lowercase = RegExp(r'[a-z]');
  static final digit = RegExp(r'\d');
}
