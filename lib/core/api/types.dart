class ApiResponse<TResponse, TError> {
  final int statusCode;
  final bool success;
  final TResponse response;
  final String? message;
  final TError? errors;
  final String? traceId;

  ApiResponse({
    required this.statusCode,
    required this.success,
    required this.response,
    this.message,
    this.errors,
    this.traceId,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    TResponse Function(dynamic) parseResponse,
    TError Function(dynamic)? parseError,
  ) {
    return ApiResponse<TResponse, TError>(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      response: parseResponse(json['response']),
      message: json['message'] as String?,
      errors: parseError != null ? parseError(json['errors']) : null,
      traceId: json['traceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'success': success,
    'response': response,
    'message': message,
    'errors': errors,
    'traceId': traceId,
  };
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

class LoginOptions {
  final String userName;
  final String password;
  const LoginOptions({required this.userName, required this.password});
}

typedef RefreshTokenResponse = ApiResponse<AuthTokens, dynamic>;
typedef LoginResponse = ApiResponse<AuthTokens, dynamic>;
