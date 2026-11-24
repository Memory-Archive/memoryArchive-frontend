import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_image.dart';
import '../widgets/onboarding_page.dart';

/// Three swipeable pages: places → memories → timeline. Shown on the first
/// launch only; after that the app opens on log in.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      image: AssetPaths.onboardingPlaces,
      titleBefore: 'Save the places that ',
      titleAccent: 'matter',
      titleAfter: '.',
      text: 'Keep a list of the spots you love and the ones you still want to see.',
    ),
    OnboardingPageData(
      image: AssetPaths.onboardingMemories,
      titleBefore: 'Turn moments into ',
      titleAccent: 'memories',
      titleAfter: '.',
      text: 'Add photos, a short note and the date, and pin it to the place where it happened.',
    ),
    OnboardingPageData(
      image: AssetPaths.onboardingTimeline,
      titleBefore: 'Relive them, month by ',
      titleAccent: 'month',
      titleAfter: '.',
      text: 'Your timeline groups every memory by month and year, so nothing gets lost.',
    ),
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == OnboardingScreen.pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish(String route) async {
    await getIt<SessionManager>().markOnboardingSeen();
    if (!mounted) return;
    context.go(route);
  }

  void _next() => _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final imageHeight = height * 0.56;

    return Scaffold(
      // SizedBox.expand: the Stack must fill the whole screen. Without it the
      // Stack is only as tall as the photo, and the text sheet below is cut off.
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Photos swipe with the pages.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: PageView.builder(
                controller: _controller,
                itemCount: OnboardingScreen.pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) => AppImage(
                  OnboardingScreen.pages[index].image,
                  width: double.infinity,
                  height: imageHeight,
                ),
              ),
            ),
            // Text sheet. Swiping on it also changes the page.
            Positioned(
              top: imageHeight - AppRadii.sheet,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragEnd: _onSheetSwipe,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Dots(count: OnboardingScreen.pages.length, current: _page),
                        AppGap.h16,
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            layoutBuilder: (current, previous) => Stack(
                              alignment: Alignment.topLeft,
                              children: [...previous, if (current != null) current],
                            ),
                            child: OnboardingPage(
                              key: ValueKey(_page),
                              data: OnboardingScreen.pages[_page],
                            ),
                          ),
                        ),
                        if (_isLast) ...[
                          AppButton(label: 'Get started', onPressed: () => _finish(AppRoutes.register)),
                          AppButton(
                            label: 'I already have an account',
                            variant: AppButtonVariant.text,
                            onPressed: () => _finish(AppRoutes.login),
                          ),
                        ] else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => _finish(AppRoutes.login),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.muted,
                                  minimumSize: const Size(0, AppSizes.touch),
                                  textStyle: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                                ),
                                child: const Text('Skip'),
                              ),
                              AppButton(label: 'Next', expand: false, onPressed: _next),
                            ],
                          ),
                        AppGap.h16,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSheetSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200 && !_isLast) {
      _next();
    } else if (velocity > 200 && _page > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${current + 1} of $count',
      child: Row(
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 6),
              width: i == current ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == current ? AppColors.green : AppColors.placeholder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}