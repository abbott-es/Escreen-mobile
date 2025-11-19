import 'dart:convert';

import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';

Map<String, dynamic> decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw const FormatException('Invalid JWT token');
  }
  final payload = base64Url.normalize(parts[1]);
  final jsonStr = utf8.decode(base64Url.decode(payload));
  final map = json.decode(jsonStr);
  if (map is! Map<String, dynamic>) {
    throw const FormatException('Invalid JWT payload');
  }
  return map;
}

String? extractRoleClaim(Map<String, dynamic> claims) {
  final candidates = <dynamic>[
    claims['${Env.roleClaimsUrl}/role'],
    claims['role'],
    claims['roles'],
  ];

  for (final c in candidates) {
    if (c == null) continue;
    if (c is String && c.trim().isNotEmpty) return c;
    if (c is List) {
      final first = c
          .cast<dynamic>()
          .map((e) => (e ?? '').toString())
          .firstWhere((s) => s.trim().isNotEmpty, orElse: () => '');
      if (first.isNotEmpty) return first;
    }
  }
  return null;
}

DateTime? extractExpiry(Map<String, dynamic> claims) {
  final exp = claims['exp'];
  if (exp is int) {
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  }
  return null;
}
