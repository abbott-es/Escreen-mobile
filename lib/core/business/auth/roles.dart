enum AppRole { driver, passenger }

AppRole? roleFromString(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized == 'driver' || normalized.contains('driver')) {
    return AppRole.driver;
  }
  if (normalized == 'passenger' || normalized.contains('passenger')) {
    return AppRole.passenger;
  }
  return null;
}
