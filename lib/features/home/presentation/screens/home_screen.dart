import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/helpers/date_format.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/accent_title.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/home_cubit.dart';
import '../widgets/memory_cards.dart';

/// Home: greeting, "On this day" and the most recent memories.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<SessionManager>().user;
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: () => context.read<HomeCubit>().refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppDateFormat.weekdayDayMonth(now),
                          style: AppTextStyles.body(size: 14, color: AppColors.muted),
                        ),
                        AppGap.h4,
                        AccentTitle(
                          before: '${AppDateFormat.greeting(now)}, ',
                          accent: user?.firstName ?? 'friend',
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  AppGap.w12,
                  _Avatar(initial: user?.initial ?? '?'),
                ],
              ),
              AppGap.h20,
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) => switch (state) {
                  HomeLoading() => const AppLoader(),
                  HomeFailure(:final error) => ErrorState(
                      message: error.message,
                      onRetry: () => context.read<HomeCubit>().load(),
                    ),
                  HomeLoaded loaded => _HomeContent(state: loaded),
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.home),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final onThisDay = state.onThisDay;
    final recent = state.recent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onThisDay != null) ...[
          OnThisDayCard(
            memory: onThisDay,
            onTap: () => context.push(AppRoutes.memoryDetailsPath(onThisDay.id)),
          ),
          AppGap.h20,
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent memories',
                style: AppTextStyles.body(size: 18, weight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.timeline),
              style: TextButton.styleFrom(foregroundColor: AppColors.green),
              child: Text('See all', style: AppTextStyles.body(size: 14, weight: FontWeight.w700, color: AppColors.green)),
            ),
          ],
        ),
        AppGap.h8,
        if (recent.isEmpty)
          EmptyState(
            icon: Icons.photo_album_outlined,
            title: state.memoriesComingSoon ? 'Memories are coming soon' : 'No memories yet',
            message: state.memoriesComingSoon
                ? 'Saving and viewing memories will work here as soon as that part of the app is ready.'
                : 'Tap + to save your first memory: a few photos, a note and the place.',
            actionLabel: state.memoriesComingSoon ? null : 'Add a memory',
            onAction: state.memoriesComingSoon ? null : () => context.push(AppRoutes.createMemory),
          )
        else ...[
          FeaturedMemoryCard(
            memory: recent.first,
            onTap: () => context.push(AppRoutes.memoryDetailsPath(recent.first.id)),
          ),
          for (final memory in recent.skip(1)) ...[
            AppGap.h12,
            CompactMemoryCard(
              memory: memory,
              onTap: () => context.push(AppRoutes.memoryDetailsPath(memory.id)),
            ),
          ],
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Your profile',
      child: Material(
        color: AppColors.green,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go(AppRoutes.profile),
          child: SizedBox(
            width: AppSizes.touch,
            height: AppSizes.touch,
            child: Center(
              child: Text(initial, style: AppTextStyles.display(size: 18, color: AppColors.card)),
            ),
          ),
        ),
      ),
    );
  }
}
