import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';

/// `true` while logging out.
class SettingsCubit extends Cubit<bool> {
  SettingsCubit(this._authRepository) : super(false);

  final AuthRepository _authRepository;

  /// Calls `POST /auth/logout` and clears the device. The router then opens
  /// the log-in screen by itself.
  Future<void> logout() async {
    if (state) return;
    emit(true);
    await _authRepository.logout();
    if (!isClosed) emit(false);
  }
}
