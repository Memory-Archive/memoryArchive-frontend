import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

/// Keeps the tokens and the last logged-in user in the platform's secure
/// storage (Keychain on iOS, Keystore-backed storage on Android).
///
/// Tokens are never logged. The access token is also kept in memory, so
/// adding it to every request doesn't hit the secure storage each time.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  String? _accessToken;
  bool _accessTokenLoaded = false;

  Future<String?> readAccessToken() async {
    if (!_accessTokenLoaded) {
      _accessToken = await _safeRead(StorageKeys.accessToken);
      _accessTokenLoaded = true;
    }
    return _accessToken;
  }

  Future<String?> readRefreshToken() => _safeRead(StorageKeys.refreshToken);

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _accessTokenLoaded = true;
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
  }

  /// The user is cached so the app can open straight into the logged-in
  /// screens on the next launch (`GET /users/me` isn't built yet).
  Future<void> saveUserJson(String json) =>
      _storage.write(key: StorageKeys.cachedUser, value: json);

  Future<String?> readUserJson() => _safeRead(StorageKeys.cachedUser);

  Future<void> clear() async {
    _accessToken = null;
    _accessTokenLoaded = true;
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.cachedUser);
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      // A corrupted keystore entry shouldn't crash the app: treat it as
      // logged out.
      if (kDebugMode) debugPrint('Secure storage read failed for $key');
      return null;
    }
  }
}
