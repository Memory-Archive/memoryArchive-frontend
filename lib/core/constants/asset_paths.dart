/// Photo placeholders. Add the real files to `assets/images/` with these exact
/// names (see `assets/images/README.md`). Until then [AppImage] shows a grey
/// box with the file name, so the app never crashes on a missing photo.
abstract final class AssetPaths {
  static const String _images = 'assets/images';

  static const String splashPhoto = '$_images/splash_photo.jpeg';

  static const String onboardingPlaces = '$_images/onboarding_places.jpeg';
  static const String onboardingMemories = '$_images/onboarding_memories.jpeg';
  static const String onboardingTimeline = '$_images/onboarding_timeline.jpeg';

  static const String loginPolaroidLeft = '$_images/login_polaroid_left.jpeg';
  static const String loginPolaroidCenter = '$_images/login_polaroid_center.jpeg';
  static const String loginPolaroidRight = '$_images/login_polaroid_right.jpeg';

  // Used only by the mock data source (USE_MOCK=true).
  static const String sampleMemory1 = '$_images/sample_memory_1.jpeg';
  static const String sampleMemory2 = '$_images/sample_memory_2.jpeg';
  static const String sampleMemory3 = '$_images/sample_memory_3.jpeg';
}
