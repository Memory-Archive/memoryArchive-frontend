import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

/// A heading with one green accent word in a different font, as in the
/// designs: "Memories **Archive**", "Start your **archive**".
class AccentTitle extends StatelessWidget {
  const AccentTitle({
    super.key,
    this.before = '',
    required this.accent,
    this.after = '',
    this.size = 32,
    this.color = AppColors.ink,
    this.textAlign = TextAlign.start,
  });

  final String before;
  final String accent;
  final String after;
  final double size;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.display(size: size, color: color),
          children: [
            if (before.isNotEmpty) TextSpan(text: before),
            TextSpan(text: accent, style: AppTextStyles.accent(size: size)),
            if (after.isNotEmpty) TextSpan(text: after),
          ],
        ),
        textAlign: textAlign,
      ),
    );
  }
}
