import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/form_status.dart';
import '../../../../core/networking/api_error.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginState {
  const LoginState({this.status = FormStatus.idle, this.error});

  final FormStatus status;
  final ApiError? error;

  bool get isSubmitting => status == FormStatus.submitting;

  String? fieldError(String field) => error?.messageFor(field);

  /// General message above the button, when the error isn't about one field.
  String? get bannerMessage {
    final current = error;
    if (status != FormStatus.failure || current == null) return null;
    return current.fieldErrors.isEmpty ? current.message : null;
  }
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(const LoginState());

  final AuthRepository _repository;

  /// On success the repository marks the session as logged in and the router
  /// opens Home by itself.
  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) return;
    emit(const LoginState(status: FormStatus.submitting));
    final result = await _repository.login(email: email, password: password);
    if (isClosed) return;
    switch (result) {
      case ApiSuccess():
        emit(const LoginState(status: FormStatus.success));
      case ApiFailure(:final error):
        emit(LoginState(status: FormStatus.failure, error: error));
    }
  }

  /// Hides the server error once the user edits the form again.
  void clearError() {
    if (state.error != null) emit(const LoginState());
  }
}
