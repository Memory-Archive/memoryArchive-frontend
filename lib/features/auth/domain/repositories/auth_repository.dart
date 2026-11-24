import '../../../../core/networking/api_result.dart';
import '../../../../core/session/app_user.dart';

/// Account actions. Every method updates [SessionManager] itself, so the
/// router reacts and screens never navigate after log in or log out.
abstract interface class AuthRepository {
  /// `POST /auth/login`. Saves the tokens and the user, then marks the
  /// session as logged in.
  Future<ApiResult<AppUser>> login({required String email, required String password});

  /// `POST /auth/signup`, then logs in with the same email and password.
  /// The backend's signup returns the new user without tokens, so this second
  /// call is what actually signs the user in.
  Future<ApiResult<AppUser>> register({
    required String username,
    required String email,
    required String password,
  });

  /// `POST /auth/forgot-password`. The backend returns 501 until password
  /// reset is built (next semester); the failure's `isNotImplemented` is true.
  Future<ApiResult<bool>> forgotPassword(String email);

  /// Called once by the splash screen. If a refresh token is saved,
  /// `POST /auth/refresh` gets new tokens and the user goes straight to Home.
  Future<void> restoreSession();

  /// `POST /auth/logout`, then clears everything on the device. Always
  /// succeeds locally, even if the server can't be reached.
  Future<void> logout();
}
