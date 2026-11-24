import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';
import 'app_button.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(color: AppColors.green),
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.greenDark),
          ),
          AppGap.h12,
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.display(size: 20)),
          AppGap.h6,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 14, color: AppColors.muted, height: 1.4),
          ),
          if (actionLabel != null && onAction != null) ...[
            AppGap.h16,
            AppButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.cloud_off_outlined,
        title: "Couldn't load this",
        message: message,
        actionLabel: 'Try again',
        onAction: onRetry,
      );
}

/// Red-tinted message above a form's main button
/// ("Email or password is incorrect.").
class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.errorBackground,
          borderRadius: BorderRadius.circular(AppRadii.field),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            AppGap.w10,
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body(size: 14, weight: FontWeight.w500, color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
