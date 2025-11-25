import 'package:jwt_decoder/jwt_decoder.dart';

bool isValid(String token) {
  return !JwtDecoder.isExpired(token);
}

String? parseTokenId(String token) {
  try {
    final decoded = JwtDecoder.decode(token);
    final jti = decoded['jti'];
    return (jti is String && jti.isNotEmpty) ? jti : null;
  } catch (_) {
    return null;
  }
}
