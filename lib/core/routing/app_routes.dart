/// Every route path in the app. Navigate with these, never with string
/// literals.
abstract final class AppRoutes {
  // Logged out.
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Logged in: main tabs.
  static const String home = '/home';
  static const String timeline = '/timeline';
  static const String places = '/places';
  static const String profile = '/profile';

  // Memories.
  static const String createMemory = '/memories/new';
  static const String memoryDetails = '/memories/:memoryId';
  static const String editMemory = '/memories/:memoryId/edit';

  // Places.
  static const String addPlace = '/places/new';
  static const String placeDetails = '/places/:placeId';
  static const String editPlace = '/places/:placeId/edit';
  static const String thenNow = '/places/:placeId/then-now';

  // Profile and settings.
  static const String editProfile = '/profile/edit';
  static const String favourites = '/profile/favourites';
  static const String drafts = '/profile/drafts';
  static const String settings = '/settings';
  static const String appLock = '/settings/app-lock';

  /// Routes a logged-out user may see.
  static const Set<String> loggedOutRoutes = {onboarding, login, register, forgotPassword};

  static String memoryDetailsPath(String id) => '/memories/$id';
  static String editMemoryPath(String id) => '/memories/$id/edit';
  static String placeDetailsPath(String id) => '/places/$id';
  static String editPlacePath(String id) => '/places/$id/edit';
  static String thenNowPath(String placeId) => '/places/$placeId/then-now';
}
