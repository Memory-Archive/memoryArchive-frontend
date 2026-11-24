import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../cubit/settings_cubit.dart';

/// Settings: account, security, about and Log out (working).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  tooltip: 'Back',
                  onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.profile),
                ),
                AppGap.w10,
                Text('Settings', style: AppTextStyles.display(size: 28)),
              ],
            ),
            AppGap.h20,
            const _SectionTitle('ACCOUNT'),
            _Group(children: [
              _Row(label: 'Edit profile', onTap: () => context.push(AppRoutes.editProfile)),
              const _Row(label: 'Change password', trailing: 'Coming soon'),
            ]),
            const _SectionTitle('SECURITY'),
            _Group(children: [
              _Row(label: 'App lock', onTap: () => context.push(AppRoutes.appLock)),
            ]),
            const _SectionTitle('ABOUT'),
            const _Group(children: [
              _Row(label: 'About ${AppStrings.appName}'),
              _Row(label: 'Terms and privacy policy'),
              _Row(label: 'App version', trailing: AppStrings.appVersion),
            ]),
            AppGap.h32,
            BlocBuilder<SettingsCubit, bool>(
              builder: (context, loggingOut) => AppButton(
                label: 'Log out',
                variant: AppButtonVariant.outline,
                isLoading: loggingOut,
                onPressed: () => context.read<SettingsCubit>().logout(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
        child: Text(text, style: AppTextStyles.eyebrow()),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadii.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(height: 1, color: AppColors.sand),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, this.trailing, this.onTap});

  final String label;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 54),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.body())),
              if (trailing != null)
                Text(trailing!, style: AppTextStyles.body(size: 13, color: AppColors.muted)),
              if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
