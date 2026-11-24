import '../../../../core/constants/asset_paths.dart';
import '../../../../core/networking/mock_http_error.dart';
import '../models/memory_dto.dart';
import 'memories_remote_data_source.dart';

/// Sample memories for `USE_MOCK=true`, matching the designs.
class MockMemoriesRemoteDataSource implements MemoriesRemoteDataSource {
  static final DateTime _now = DateTime.now();

  static final List<MemoryDto> _memories = [
    MemoryDto(
      id: 'mock-memory-1',
      title: 'Corniche at sunset',
      memoryDate: _now.subtract(const Duration(days: 14)),
      description:
          'Walked from Stanley Bridge to the Citadel. The sea was louder than the traffic for once.',
      placeName: 'Alexandria Corniche',
      coverUrl: AssetPaths.sampleMemory1,
      photoCount: 4,
    ),
    MemoryDto(
      id: 'mock-memory-2',
      title: 'Last summer swim',
      memoryDate: _now.subtract(const Duration(days: 54)),
      placeName: 'Sahel beach',
      coverUrl: AssetPaths.sampleMemory2,
      photoCount: 6,
    ),
    MemoryDto(
      id: 'mock-memory-3',
      title: 'First day of final year',
      memoryDate: _now.subtract(const Duration(days: 56)),
      placeName: 'Campus',
      coverUrl: AssetPaths.sampleMemory3,
      photoCount: 3,
    ),
  ];

  @override
  Future<List<MemoryDto>> getRecent({required int limit}) async {
    await mockDelay();
    return _memories.take(limit).toList();
  }

  @override
  Future<List<MemoryDto>> getOnThisDay() async {
    await mockDelay(300);
    return [
      MemoryDto(
        id: 'mock-memory-otd',
        title: 'Dahab with the cousins',
        memoryDate: DateTime(_now.year - 3, _now.month, _now.day),
        placeName: 'Blue Hole, Dahab',
        coverUrl: AssetPaths.onboardingMemories,
        photoCount: 6,
      ),
    ];
  }
}
