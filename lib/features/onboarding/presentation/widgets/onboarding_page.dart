import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/accent_title.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.image,
    required this.titleBefore,
    required this.titleAccent,
    this.titleAfter = '',
    required this.text,
  });

  final String image;
  final String titleBefore;
  final String titleAccent;
  final String titleAfter;
  final String text;
}

/// Title and text of one onboarding page.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccentTitle(
            before: data.titleBefore,
            accent: data.titleAccent,
            after: data.titleAfter,
            size: 30,
          ),
          AppGap.h12,
          Text(
            data.text,
            style: AppTextStyles.body(size: 16, color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
