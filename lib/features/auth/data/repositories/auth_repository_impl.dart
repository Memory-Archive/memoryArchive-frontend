import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/networking/api_error.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/json_helpers.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../core/session/app_user.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStorage tokenStorage,
    required SessionManager session,
  })  : _remote = remote,
        _tokens = tokenStorage,
        _session = session;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokens;
  final SessionManager _session;

  /// Saved in `auth_sessions.device_name`, so the user can tell their
  /// devices apart later.
  static String get _deviceName =>
      'Memories Archive app (${kIsWeb ? 'web' : defaultTargetPlatform.name})';

  @override
  Future<ApiResult<AppUser>> login({required String email, required String password}) async {
    final result = await safeApiCall(
      () => _remote.login(
        email: _normaliseEmail(email),
        password: password,
        deviceName: _deviceName,
      ),
    );
    switch (result) {
      case ApiSuccess(:final data):
        final user = data.user.toEntity();
        await _tokens.saveTokens(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        );
        await _tokens.saveUserJson(jsonEncode(data.user.toJson()));
        _session.setAuthenticated(user);
        return ApiSuccess(user);
      case ApiFailure(:final error):
        return ApiFailure(_loginError(error));
    }
  }

  @override
  Future<ApiResult<AppUser>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final normalisedEmail = _normaliseEmail(email);
    final signup = await safeApiCall(
      () => _remote.signup(username: username.trim(), email: normalisedEmail, password: password),
    );
    if (signup case ApiFailure(:final error)) {
      return ApiFailure(_signupError(error));
    }

    // The account exists now; log in to get tokens.
    final loginResult = await login(email: normalisedEmail, password: password);
    if (loginResult case ApiFailure(:final error)) {
      return ApiFailure(error.copyWith(
        message: 'Your account was created, but logging in failed. Please log in.',
      ));
    }
    return loginResult;
  }

  @override
  Future<ApiResult<bool>> forgotPassword(String email) => safeApiCall(() async {
        await _remote.forgotPassword(_normaliseEmail(email));
        return true;
      });

  @override
  Future<void> restoreSession() async {
    try {
      await _restoreSession();
    } catch (error) {
      // Never leave the app stuck on the splash: on any unexpected error,
      // start logged out.
      if (kDebugMode) debugPrint('restoreSession failed: $error');
      try {
        await _tokens.clear();
      } catch (_) {}
      _session.setUnauthenticated();
    }
  }

  Future<void> _restoreSession() async {
    final refreshToken = await _tokens.readRefreshToken();
    final cachedUser = await _readCachedUser();
    if (refreshToken == null || cachedUser == null) {
      await _tokens.clear();
      _session.setUnauthenticated();
      return;
    }

    final result = await safeApiCall(() => _remote.refresh(refreshToken));
    switch (result) {
      case ApiSuccess(:final data):
        await _tokens.saveTokens(accessToken: data.accessToken, refreshToken: data.refreshToken);
        _session.setAuthenticated(cachedUser);
      case ApiFailure(:final error) when error.isConnectionProblem:
        // Server unreachable: open the app with the saved user. The tokens
        // are refreshed on the first request once the server is back.
        _session.setAuthenticated(cachedUser);
      case ApiFailure():
        // Refresh token expired, revoked or reused: log in again.
        await _tokens.clear();
        _session.setUnauthenticated();
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _tokens.readRefreshToken();
    if (refreshToken != null) {
      // Revokes this device's session on the server. The result doesn't
      // matter: the device forgets the tokens either way.
      await safeApiCall(() => _remote.logout(refreshToken));
    }
    await _tokens.clear();
    _session.setUnauthenticated();
  }

  // The backend lowercases emails before saving; do the same before sending.
  String _normaliseEmail(String email) => email.trim().toLowerCase();

  Future<AppUser?> _readCachedUser() async {
    final raw = await _tokens.readUserJson();
    if (raw == null) return null;
    try {
      return UserDto.fromJson(asJsonMap(jsonDecode(raw), 'cachedUser')).toEntity();
    } catch (_) {
      return null;
    }
  }

  ApiError _loginError(ApiError error) => switch (error.type) {
        // The backend uses one message for a wrong email and a wrong password.
        ApiErrorType.unauthorized => error.copyWith(message: 'Email or password is incorrect.'),
        ApiErrorType.forbidden => error.copyWith(message: 'This account has been disabled.'),
        _ => error,
      };

  /// 409 "email or username taken" may come without `details`; put the
  /// message under the right field anyway.
  ApiError _signupError(ApiError error) {
    if (error.type != ApiErrorType.conflict || error.fieldErrors.isNotEmpty) return error;
    final text = error.message.toLowerCase();
    if (text.contains('username')) {
      return error.copyWith(fieldErrors: {'username': 'This username is already taken'});
    }
    if (text.contains('email')) {
      return error.copyWith(fieldErrors: {'email': 'This email is already registered'});
    }
    return error;
  }
}