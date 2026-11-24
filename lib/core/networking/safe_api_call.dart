import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_error.dart';
import 'api_result.dart';
import 'json_helpers.dart';

/// Runs a data-source call and turns every exception into an [ApiFailure].
Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return ApiSuccess<T>(await call());
  } on DioException catch (exception) {
    return ApiFailure<T>(ApiError.fromDio(exception));
  } on DtoParsingException catch (exception) {
    if (kDebugMode) debugPrint('$exception');
    return ApiFailure<T>(ApiError.parsing());
  } catch (exception) {
    if (kDebugMode) debugPrint('Unexpected error: $exception');
    return ApiFailure<T>(ApiError.unknown());
  }
}
