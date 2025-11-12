import 'package:dio/dio.dart';
import 'types.dart';

NormalizedError normalizeDioError(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;

  final rawErrors = (data is Map && data['errors'] is List)
      ? data['errors'] as List
      : null;
  final codes = rawErrors
      ?.map((e) => (e is Map ? e['code'] : null)?.toString())
      .whereType<String>()
      .toList();

  return NormalizedError(
    (codes != null && codes.isNotEmpty)
        ? codes
        : <String>['something_went_wrong'],
    status: status,
    message: e.message,
  );
}
