import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';

/// Round 44 px button (back, edit, settings...).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.background = AppColors.card,
    this.foreground = AppColors.ink,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: AppSizes.touch,
            height: AppSizes.touch,
            child: Icon(icon, color: foreground, size: 22, semanticLabel: tooltip),
          ),
        ),
      ),
    );
  }
}
