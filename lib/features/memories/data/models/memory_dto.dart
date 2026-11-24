import '../../../../core/networking/json_helpers.dart';
import '../../domain/entities/memory.dart';

/// A memory as the backend returns it. Column names follow the `memories`
/// table (`memory_date`, `place_id`...); camelCase and snake_case are both
/// accepted until the backend's memory endpoints are built.
class MemoryDto {
  const MemoryDto({
    required this.id,
    required this.title,
    required this.memoryDate,
    this.description,
    this.placeName,
    this.coverUrl,
    this.photoCount = 0,
  });

  factory MemoryDto.fromJson(Map<String, dynamic> json) {
    final date = readDate(json, const ['memoryDate', 'memory_date']);
    if (date == null) throw DtoParsingException('MemoryDto: missing "memoryDate"');

    String? placeName = readString(json, const ['placeName', 'place_name']);
    final place = json['place'];
    if (placeName == null && place is Map) {
      placeName = readString(asJsonMap(place, 'MemoryDto.place'), const ['name']);
    }

    return MemoryDto(
      id: readRequiredString(json, const ['id'], 'MemoryDto'),
      title: readRequiredString(json, const ['title'], 'MemoryDto'),
      memoryDate: date,
      description: readString(json, const ['description']),
      placeName: placeName,
      coverUrl: readString(json, const ['coverUrl', 'cover_url']),
      photoCount: readInt(json, const ['photoCount', 'photo_count']) ?? 0,
    );
  }

  final String id;
  final String title;
  final DateTime memoryDate;
  final String? description;
  final String? placeName;
  final String? coverUrl;
  final int photoCount;

  Memory toEntity() => Memory(
        id: id,
        title: title,
        memoryDate: memoryDate,
        description: description,
        placeName: placeName,
        coverImage: coverUrl,
        photoCount: photoCount,
      );
}

/// Accepts a plain list or a list wrapped in `items` / `memories` / `results`
/// (for paginated responses).
List<MemoryDto> parseMemoryList(Object? data) {
  Object? source = data;
  if (data is Map) {
    for (final key in const ['items', 'memories', 'results']) {
      if (data[key] is List) {
        source = data[key];
        break;
      }
    }
  }
  return [
    for (final item in asJsonList(source, 'memories'))
      MemoryDto.fromJson(asJsonMap(item, 'MemoryDto')),
  ];
}
