import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../domain/entities/memory.dart';
import '../../domain/repositories/memories_repository.dart';
import '../data_sources/memories_remote_data_source.dart';

class MemoriesRepositoryImpl implements MemoriesRepository {
  MemoriesRepositoryImpl(this._remote);

  final MemoriesRemoteDataSource _remote;

  @override
  Future<ApiResult<List<Memory>>> getRecent({int limit = 3}) => safeApiCall(() async {
        final items = await _remote.getRecent(limit: limit);
        return items.map((dto) => dto.toEntity()).toList();
      });

  @override
  Future<ApiResult<List<Memory>>> getOnThisDay() => safeApiCall(() async {
        final items = await _remote.getOnThisDay();
        return items.map((dto) => dto.toEntity()).toList();
      });
}
