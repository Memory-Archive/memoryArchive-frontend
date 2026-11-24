import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';
import 'app_bottom_nav.dart';
import 'circle_icon_button.dart';

/// Placeholder used by every screen that isn't built yet, so all routes and
/// links already work. Replace a screen's body when you build it.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.description,
    this.tab,
    this.showBack = true,
    this.children = const [],
  });

  final String title;

  /// What the finished screen will do (from the designs).
  final String description;

  /// Set for the four main tabs, so the bottom bar shows.
  final AppTab? tab;
  final bool showBack;

  /// Optional working widgets shown under the note (for example Log out).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Row(
              children: [
                if (showBack) ...[
                  CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    tooltip: 'Back',
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go(AppRoutes.home),
                  ),
                  AppGap.w10,
                ],
                Expanded(child: Text(title, style: AppTextStyles.display(size: 28))),
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
                  Text(description, style: AppTextStyles.body(color: AppColors.muted, height: 1.45)),
                ],
              ),
            ),
            if (children.isNotEmpty) ...[AppGap.h20, ...children],
          ],
        ),
      ),
      bottomNavigationBar: tab == null ? null : AppBottomNav(current: tab!),
    );
  }
}
