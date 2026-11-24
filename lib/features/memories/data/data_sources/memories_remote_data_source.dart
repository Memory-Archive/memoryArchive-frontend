import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/json_helpers.dart';
import '../models/memory_dto.dart';

/// The backend's memory routes exist and are protected, but their logic
/// returns 501 until it's built. The repository turns that 501 into a
/// "coming soon" state instead of an error.
abstract interface class MemoriesRemoteDataSource {
  Future<List<MemoryDto>> getRecent({required int limit});

  Future<List<MemoryDto>> getOnThisDay();
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  MemoriesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<MemoryDto>> getRecent({required int limit}) async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.memories,
      queryParameters: {'limit': limit},
    );
    return parseMemoryList(unwrapData(response.data));
  }

  /// The backend has no `GET /memories/on-this-day` route yet (it's on the
  /// backend's to-do list). Calling it now would hit `GET /memories/:memoryId`
  /// and fail validation with 400, so return nothing until the route exists.
  /// Then replace the body with:
  /// `final response = await _dio.get<dynamic>(ApiEndpoints.memoriesOnThisDay);`
  /// `return parseMemoryList(unwrapData(response.data));`
  @override
  Future<List<MemoryDto>> getOnThisDay() async => const [];
}
