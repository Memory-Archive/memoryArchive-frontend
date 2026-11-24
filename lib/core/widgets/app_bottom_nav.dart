import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';

enum AppTab { home, timeline, places, profile }

/// Bottom bar: Home · Timeline · (+) · Places · Profile.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current});

  final AppTab current;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSizes.bottomNav,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(tab: AppTab.home, current: current, icon: Icons.home_outlined, label: 'Home', route: AppRoutes.home),
              _NavItem(tab: AppTab.timeline, current: current, icon: Icons.calendar_month_outlined, label: 'Timeline', route: AppRoutes.timeline),
              const _CreateButton(),
              _NavItem(tab: AppTab.places, current: current, icon: Icons.place_outlined, label: 'Places', route: AppRoutes.places),
              _NavItem(tab: AppTab.profile, current: current, icon: Icons.person_outline, label: 'Profile', route: AppRoutes.profile),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.current,
    required this.icon,
    required this.label,
    required this.route,
  });

  final AppTab tab;
  final AppTab current;
  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    final selected = tab == current;
    final color = selected ? AppColors.green : AppColors.muted;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: selected ? null : () => context.go(route),
        child: SizedBox(
          width: 64,
          height: AppSizes.bottomNav,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              AppGap.h4,
              Text(
                label,
                style: AppTextStyles.body(
                  size: 11,
                  weight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'New memory',
      child: Material(
        color: AppColors.green,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.createMemory),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, color: AppColors.onGreen, size: 28, semanticLabel: 'New memory'),
          ),
        ),
      ),
    );
  }
}
