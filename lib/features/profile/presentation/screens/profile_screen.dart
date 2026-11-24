import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/circle_icon_button.dart';

/// Profile. Shows the logged-in user from the session (saved at log in,
/// because `GET /users/me` isn't built yet). Stats and the memory grid come
/// later.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<SessionManager>().user;
    final bio = user?.bio;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CircleIconButton(
                icon: Icons.settings_outlined,
                tooltip: 'Settings',
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                  child: Text(
                    user?.initial ?? '?',
                    style: AppTextStyles.display(size: 36, color: AppColors.card),
                  ),
                ),
                AppGap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.nameToShow ?? '', style: AppTextStyles.display(size: 26)),
                      AppGap.h4,
                      Text(
                        '@${user?.username ?? ''}',
                        style: AppTextStyles.body(size: 14, color: AppColors.muted),
                      ),
                      if (bio != null && bio.isNotEmpty) ...[
                        AppGap.h4,
                        Text(bio, style: AppTextStyles.hand(size: 20)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            AppGap.h20,
            AppButton(
              label: 'Edit profile',
              variant: AppButtonVariant.outline,
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
            AppGap.h12,
            Row(
              children: [
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.star_rounded,
                    label: 'Favourites',
                    onTap: () => context.push(AppRoutes.favourites),
                  ),
                ),
                AppGap.w8,
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.edit_outlined,
                    label: 'Drafts',
                    onTap: () => context.push(AppRoutes.drafts),
                  ),
                ),
              ],
            ),
            AppGap.h20,
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COMING SOON', style: AppTextStyles.eyebrow(color: AppColors.green)),
                  AppGap.h8,
                  Text(
                    'Your memories, places and years counts, and a grid of your memories.',
                    style: AppTextStyles.body(color: AppColors.muted, height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.profile),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.green),
              AppGap.w10,
              Text(label, style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
