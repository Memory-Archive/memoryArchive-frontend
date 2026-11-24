import 'package:flutter/foundation.dart';

/// Build-time settings, passed with `--dart-define`.
///
/// ```bash
/// flutter run                                              # real backend
/// flutter run --dart-define=USE_MOCK=true                  # no backend needed
/// flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000
/// ```
abstract final class Env {
  /// When true, the app uses in-memory fake data sources instead of the API.
  static const bool useMock = bool.fromEnvironment('USE_MOCK');

  static const String _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

  /// Root address of the Express backend.
  ///
  /// The backend's routes start at `/` (for example `/auth/login`), with no
  /// `/api` prefix, so this is only the scheme, host and port.
  ///
  /// Defaults:
  /// * Android emulator: `http://10.0.2.2:3000` (10.0.2.2 is the computer
  ///   running the emulator).
  /// * Web, iOS simulator and desktop: `http://localhost:3000`.
  /// * A real phone needs `--dart-define=API_BASE_URL=http://<computer-ip>:3000`.
  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _withoutTrailingSlash(_apiBaseUrlOverride);
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static String _withoutTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
