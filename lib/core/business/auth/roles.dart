enum AppRole { driver, passenger }

AppRole? roleFromString(String value) {
  final v = value.toLowerCase().trim();
  if (v.contains('driver')) return AppRole.driver;
  if (v.contains('passenger')) return AppRole.passenger;
  return null;
}
