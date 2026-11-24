import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/form_status.dart';
import '../../../../core/networking/api_error.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterState {
  const RegisterState({this.status = FormStatus.idle, this.error});

  final FormStatus status;
  final ApiError? error;

  bool get isSubmitting => status == FormStatus.submitting;

  String? fieldError(String field) => error?.messageFor(field);

  String? get bannerMessage {
    final current = error;
    if (status != FormStatus.failure || current == null) return null;
    return current.fieldErrors.isEmpty ? current.message : null;
  }
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterState());

  final AuthRepository _repository;

  /// Signs up, then logs in. On success the router opens Home by itself.
  Future<void> submit({
    required String username,
    required String email,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const RegisterState(status: FormStatus.submitting));
    final result = await _repository.register(
      username: username,
      email: email,
      password: password,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccess():
        emit(const RegisterState(status: FormStatus.success));
      case ApiFailure(:final error):
        emit(RegisterState(status: FormStatus.failure, error: error));
    }
  }

  void clearError() {
    if (state.error != null) emit(const RegisterState());
  }
}
