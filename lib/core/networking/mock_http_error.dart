import 'package:dio/dio.dart';

/// Builds the same [DioException] a real backend error would produce, so
/// mock data sources go through exactly the same error handling.
DioException mockHttpError(String path, int statusCode, Map<String, dynamic> body) {
  final request = RequestOptions(path: path);
  return DioException(
    requestOptions: request,
    response: Response<dynamic>(requestOptions: request, statusCode: statusCode, data: body),
    type: DioExceptionType.badResponse,
  );
}

/// Pretend network delay for mock data sources.
Future<void> mockDelay([int milliseconds = 600]) =>
    Future<void>.delayed(Duration(milliseconds: milliseconds));
