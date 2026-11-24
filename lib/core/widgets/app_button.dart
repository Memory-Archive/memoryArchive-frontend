import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';

enum AppButtonVariant { primary, outline, text }

/// Pill-shaped button from the designs. Shows a spinner while [isLoading].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (variant) {
      AppButtonVariant.primary => AppColors.onGreen,
      AppButtonVariant.outline => AppColors.ink,
      AppButtonVariant.text => AppColors.green,
    };

    final text = Text(label, overflow: TextOverflow.ellipsis);
    final Widget child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), AppGap.w8],
              // Flexible only when the width is bounded (full-width buttons);
              // a compact button inside a Row gets unbounded width.
              if (expand) Flexible(child: text) else text,
            ],
          );

    final minimumSize = Size(expand ? double.infinity : 0, AppSizes.button);
    final callback = isLoading ? null : onPressed;

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: callback,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.onGreen,
            disabledBackgroundColor: AppColors.green.withValues(alpha: 0.6),
            disabledForegroundColor: AppColors.onGreen,
            minimumSize: minimumSize,
            shape: const StadiumBorder(),
            textStyle: AppTextStyles.button(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: callback,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ink,
            minimumSize: minimumSize,
            shape: const StadiumBorder(),
            side: const BorderSide(color: AppColors.ink, width: 1.5),
            textStyle: AppTextStyles.button(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.green,
            minimumSize: const Size(0, AppSizes.touch),
            textStyle: AppTextStyles.body(size: 15, weight: FontWeight.w700),
          ),
          child: child,
        ),
    };
  }
}
