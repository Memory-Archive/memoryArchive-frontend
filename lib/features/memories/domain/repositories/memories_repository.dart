import '../../../../core/networking/api_result.dart';
import '../entities/memory.dart';

abstract interface class MemoriesRepository {
  /// Newest memories first (`GET /memories`).
  Future<ApiResult<List<Memory>>> getRecent({int limit = 3});

  /// Memories from this day in earlier years (`GET /memories/on-this-day`).
  Future<ApiResult<List<Memory>>> getOnThisDay();
}
