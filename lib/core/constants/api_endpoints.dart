/// Paths of the Express backend, relative to [Env.apiBaseUrl].
///
/// They match the backend documentation (Semester 1, PR #4): routes start at
/// `/` with no `/api` prefix.
abstract final class ApiEndpoints {
  static const String health = '/health';

  // Auth: working on the backend.
  static const String signup = '/auth/signup';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Auth: routes exist but return 501 until next semester.
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  /// Requests under this prefix never carry the access token and never
  /// trigger an automatic token refresh.
  static const String authPrefix = '/auth/';

  // Users: routes exist, logic returns 501 for now.
  static const String me = '/users/me';
  static const String mySessions = '/users/me/sessions';

  // Memories: routes exist, logic returns 501 for now.
  // GET /memories takes `page` and `limit` (1–100, default 20), plus optional
  // `from`, `to` (YYYY-MM-DD), `placeId`, `tagId` and `q`.
  static const String memories = '/memories';

  /// Not in the backend yet (to-do). Not called until it exists.
  static const String memoriesOnThisDay = '/memories/on-this-day';
  static String memory(String id) => '/memories/$id';

  // Places: routes exist, logic returns 501 for now.
  static const String places = '/places';
  static const String savedPlaces = '/saved-places';
}
