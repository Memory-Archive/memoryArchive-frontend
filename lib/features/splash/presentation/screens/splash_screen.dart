import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_image.dart';

/// Green splash with the polaroid logo, shown while the saved session is
/// checked. Navigation away happens in the router, not here.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PolaroidLogo(),
                  AppGap.h24,
                  Text(
                    AppStrings.appName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.display(size: 36, color: AppColors.card),
                  ),
                  AppGap.h6,
                  Text(
                    AppStrings.tagline,
                    style: AppTextStyles.hand(size: 24, color: AppColors.mint),
                  ),
                ],
              ),
            ),
            const Positioned(left: 0, right: 0, bottom: 64, child: _LoadingDots()),
          ],
        ),
      ),
    );
  }
}

class _PolaroidLogo extends StatelessWidget {
  const _PolaroidLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 130,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: Transform.rotate(
              angle: -0.14,
              child: Container(width: 92, height: 108, color: AppColors.mint),
            ),
          ),
          Positioned(
            left: 18,
            top: 0,
            child: Transform.rotate(
              angle: 0.07,
              child: Container(
                width: 92,
                height: 108,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 22),
                color: AppColors.card,
                child: const AppImage(AssetPaths.splashPhoto, width: 76, height: 78),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card.withValues(alpha: _opacity(i)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _opacity(int index) {
    final phase = (_controller.value - index * 0.18) % 1.0;
    final wave = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
    return 0.3 + 0.7 * wave;
  }
}
