import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/validation/validators.dart';

/// 0 to 4. Length counts most: long passphrases are encouraged.
int passwordStrength(String password) {
  var score = 0;
  if (password.length >= AuthRules.passwordMin) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'[0-9]').hasMatch(password) || RegExp(r'[^A-Za-z0-9 ]').hasMatch(password)) score++;
  if (RegExp(r'\s').hasMatch(password) || RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (password.length < AuthRules.passwordMin || password.length > AuthRules.passwordMax) {
    score = score > 1 ? 1 : score;
  }
  return score;
}

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  static const List<String> _labels = ['Too short', 'Weak', 'Okay', 'Good', 'Strong'];

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox(height: 4);
    final score = passwordStrength(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: i < score ? AppColors.green : AppColors.line,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              if (i < 3) const SizedBox(width: 5),
            ],
          ],
        ),
        AppGap.h6,
        Semantics(
          liveRegion: true,
          child: Text(
            'Password strength: ${_labels[score]}',
            style: AppTextStyles.body(size: 13, weight: FontWeight.w700, color: AppColors.green),
          ),
        ),
      ],
    );
  }
}

/// A rule with a tick that turns green when it's met.
class RuleCheck extends StatelessWidget {
  const RuleCheck({super.key, required this.text, required this.met});

  final String text;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.green : AppColors.muted;
    return Semantics(
      label: '$text, ${met ? 'done' : 'not yet'}',
      excludeSemantics: true,
      child: Row(
        children: [
          Icon(met ? Icons.check_circle : Icons.check_circle_outline, size: 18, color: color),
          AppGap.w8,
          Expanded(child: Text(text, style: AppTextStyles.body(size: 13, color: color))),
        ],
      ),
    );
  }
}
