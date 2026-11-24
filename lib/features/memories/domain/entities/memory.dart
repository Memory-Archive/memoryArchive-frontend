/// A memory, as screens use it.
class Memory {
  const Memory({
    required this.id,
    required this.title,
    required this.memoryDate,
    this.description,
    this.placeName,
    this.coverImage,
    this.photoCount = 0,
  });

  final String id;
  final String title;

  /// The day it happened (`memory_date`).
  final DateTime memoryDate;
  final String? description;
  final String? placeName;

  /// A photo URL from the backend, or an asset path in mock mode.
  final String? coverImage;
  final int photoCount;
}
