import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_error.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/repositories/auth_repository.dart';

enum ForgotPasswordStatus {
  idle,
  submitting,

  /// The backend accepted the request ("check your inbox").
  sent,

  /// The backend answered 501: password reset is planned for next semester.
  unavailable,
  failure,
}

class ForgotPasswordState {
  const ForgotPasswordState({this.status = ForgotPasswordStatus.idle, this.error});

  final ForgotPasswordStatus status;
  final ApiError? error;

  bool get isSubmitting => status == ForgotPasswordStatus.submitting;
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  Future<void> submit(String email) async {
    if (state.isSubmitting) return;
    emit(const ForgotPasswordState(status: ForgotPasswordStatus.submitting));
    final result = await _repository.forgotPassword(email);
    if (isClosed) return;
    switch (result) {
      case ApiSuccess():
        emit(const ForgotPasswordState(status: ForgotPasswordStatus.sent));
      case ApiFailure(:final error) when error.isNotImplemented:
        emit(const ForgotPasswordState(status: ForgotPasswordStatus.unavailable));
      case ApiFailure(:final error):
        emit(ForgotPasswordState(status: ForgotPasswordStatus.failure, error: error));
    }
  }

  void reset() => emit(const ForgotPasswordState());
}
