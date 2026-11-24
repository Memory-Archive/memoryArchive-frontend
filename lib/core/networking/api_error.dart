import 'package:dio/dio.dart';

import '../constants/app_strings.dart';

enum ApiErrorType {
  network,
  timeout,
  cancelled,
  validation,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  tooManyRequests,
  notImplemented,
  server,
  parsing,
  unknown,
}

/// A short, user-friendly error. Repositories never throw; they return
/// `ApiFailure(ApiError)` instead.
///
/// The backend's error body is:
/// ```json
/// { "message": "Validation failed",
///   "details": [{ "location": "body", "path": "email", "message": "Invalid email address" }] }
/// ```
/// `details[].path` becomes a key in [fieldErrors], so a screen can show the
/// message under the matching field with `error.messageFor('email')`.
class ApiError {
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  factory ApiError.fromDio(DioException exception) {
    final type = exception.type;
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return const ApiError(type: ApiErrorType.timeout, message: AppStrings.timeoutError);
    }
    if (type == DioExceptionType.cancel) {
      return const ApiError(type: ApiErrorType.cancelled, message: 'Request cancelled.');
    }
    final response = exception.response;
    if (type == DioExceptionType.badResponse && response != null) {
      return ApiError.fromResponse(response.statusCode ?? 0, response.data);
    }
    // connectionError, badCertificate, unknown: the server couldn't be reached.
    return const ApiError(type: ApiErrorType.network, message: AppStrings.networkError);
  }

  factory ApiError.fromResponse(int statusCode, Object? body) {
    String? serverMessage;
    final fields = <String, String>{};

    if (body is Map) {
      final message = body['message'];
      if (message is String && message.trim().isNotEmpty) {
        serverMessage = message.trim();
      }
      final details = body['details'];
      if (details is List) {
        for (final detail in details) {
          if (detail is! Map) continue;
          final path = detail['path'];
          final detailMessage = detail['message'];
          if (path == null || detailMessage is! String) continue;
          final field = path is List
              ? (path.isEmpty ? '' : path.last.toString())
              : path.toString().split('.').last;
          if (field.isNotEmpty) fields.putIfAbsent(field, () => detailMessage);
        }
      }
    }

    final type = switch (statusCode) {
      400 || 422 => ApiErrorType.validation,
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      409 => ApiErrorType.conflict,
      429 => ApiErrorType.tooManyRequests,
      501 => ApiErrorType.notImplemented,
      >= 500 => ApiErrorType.server,
      _ => ApiErrorType.unknown,
    };

    final message = switch (type) {
      // Never show raw server errors to users.
      ApiErrorType.server => AppStrings.genericError,
      ApiErrorType.notImplemented => AppStrings.notAvailableYet,
      ApiErrorType.tooManyRequests =>
        serverMessage ?? 'Too many attempts. Wait a minute and try again.',
      _ => serverMessage ?? AppStrings.genericError,
    };

    return ApiError(type: type, message: message, statusCode: statusCode, fieldErrors: fields);
  }

  factory ApiError.parsing() => const ApiError(
        type: ApiErrorType.parsing,
        message: "The server's answer wasn't in the expected format.",
      );

  factory ApiError.unknown() =>
      const ApiError(type: ApiErrorType.unknown, message: AppStrings.genericError);

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  /// Message for one form field, or null.
  String? messageFor(String field) => fieldErrors[field];

  bool get isNotImplemented => type == ApiErrorType.notImplemented;
  bool get isConnectionProblem =>
      type == ApiErrorType.network || type == ApiErrorType.timeout;

  ApiError copyWith({String? message, Map<String, String>? fieldErrors}) => ApiError(
        type: type,
        message: message ?? this.message,
        statusCode: statusCode,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );

  @override
  String toString() => 'ApiError($type, $statusCode, $message, $fieldErrors)';
}
