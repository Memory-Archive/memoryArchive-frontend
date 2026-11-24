import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';

/// Shows the splash for a moment, then restores the saved session.
///
/// When the check finishes, [SessionManager] changes and the router moves on
/// by itself: to Home if the user was logged in, otherwise to onboarding
/// (first launch) or log in.
class SplashCubit extends Cubit<bool> {
  SplashCubit(this._authRepository) : super(false);

  final AuthRepository _authRepository;

  /// The splash stays at least this long, so it doesn't just flash.
  static const Duration minimumDisplay = Duration(milliseconds: 900);

  Future<void> start() async {
    // Wait first: restoreSession() updates the session as soon as it's done,
    // and the router leaves the splash at that moment.
    await Future<void>.delayed(minimumDisplay);
    await _authRepository.restoreSession();
    if (!isClosed) emit(true);
  }
}
