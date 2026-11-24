import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import 'app_user.dart';

enum SessionStatus {
  /// App just started; the saved session hasn't been checked yet (splash).
  unknown,
  authenticated,
  unauthenticated,
}

/// Single source of truth for "who is logged in".
///
/// Only the auth repository and the auth interceptor change it. The router
/// listens to it (`refreshListenable`) and moves between the logged-out and
/// logged-in screens by itself, so screens never navigate after log in or
/// log out.
class SessionManager extends ChangeNotifier {
  SessionManager(this._prefs)
      : _onboardingSeen = _prefs.getBool(StorageKeys.onboardingSeen) ?? false;

  final SharedPreferences _prefs;

  SessionStatus _status = SessionStatus.unknown;
  AppUser? _user;
  bool _onboardingSeen;

  SessionStatus get status => _status;
  AppUser? get user => _user;
  bool get isAuthenticated => _status == SessionStatus.authenticated;
  bool get onboardingSeen => _onboardingSeen;

  void setAuthenticated(AppUser user) {
    _user = user;
    _status = SessionStatus.authenticated;
    notifyListeners();
  }

  void setUnauthenticated() {
    if (_status == SessionStatus.unauthenticated && _user == null) return;
    _user = null;
    _status = SessionStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> markOnboardingSeen() async {
    if (_onboardingSeen) return;
    _onboardingSeen = true;
    await _prefs.setBool(StorageKeys.onboardingSeen, true);
  }
}
