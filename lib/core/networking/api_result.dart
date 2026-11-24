import 'api_error.dart';

/// What every repository method returns: success with data, or a failure
/// with an [ApiError]. Repositories never throw.
sealed class ApiResult<T> {
  const ApiResult();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(ApiError error) onFailure,
  }) =>
      switch (this) {
        ApiSuccess<T>(:final data) => onSuccess(data),
        ApiFailure<T>(:final error) => onFailure(error),
      };
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);

  final ApiError error;
}
