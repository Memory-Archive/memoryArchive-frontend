/// Keys for secure storage (tokens, cached user) and shared preferences.
abstract final class StorageKeys {
  // Secure storage.
  static const String accessToken = 'auth.access_token';
  static const String refreshToken = 'auth.refresh_token';
  static const String cachedUser = 'auth.cached_user';

  // Shared preferences.
  static const String onboardingSeen = 'app.onboarding_seen';
}
