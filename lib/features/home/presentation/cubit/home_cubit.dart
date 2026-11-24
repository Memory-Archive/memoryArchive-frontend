import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_error.dart';
import '../../../../core/networking/api_result.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/domain/repositories/memories_repository.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.recent, this.onThisDay, this.memoriesComingSoon = false});

  final List<Memory> recent;
  final Memory? onThisDay;

  /// True while the backend's memory endpoints still answer 501.
  final bool memoriesComingSoon;
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.error);

  final ApiError error;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._memories) : super(const HomeLoading());

  final MemoriesRepository _memories;

  Future<void> load({bool showLoader = true}) async {
    if (showLoader) emit(const HomeLoading());

    final results = await Future.wait([
      _memories.getRecent(limit: 3),
      _memories.getOnThisDay(),
    ]);
    if (isClosed) return;

    final recent = results[0];
    final onThisDay = results[1];

    switch (recent) {
      case ApiFailure(:final error) when error.isNotImplemented:
        emit(const HomeLoaded(recent: [], memoriesComingSoon: true));
      case ApiFailure(:final error):
        emit(HomeFailure(error));
      case ApiSuccess(:final data):
        final today = switch (onThisDay) {
          ApiSuccess(data: final items) when items.isNotEmpty => items.first,
          _ => null,
        };
        emit(HomeLoaded(recent: data, onThisDay: today));
    }
  }

  Future<void> refresh() => load(showLoader: false);
}
