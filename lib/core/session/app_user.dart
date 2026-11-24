/// The logged-in user, as the whole app sees it.
///
/// It lives in `core` (pure Dart, no JSON) so every feature can read the
/// current user from [SessionManager] without importing the auth feature.
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.bio,
  });

  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? bio;

  /// Display name if set, otherwise the username.
  String get nameToShow {
    final name = displayName?.trim();
    return (name == null || name.isEmpty) ? username : name;
  }

  /// First name only, for greetings ("Good evening, Sara").
  String get firstName => nameToShow.split(RegExp(r'\s+')).first;

  String get initial => nameToShow.isEmpty ? '?' : nameToShow.substring(0, 1).toUpperCase();
}
