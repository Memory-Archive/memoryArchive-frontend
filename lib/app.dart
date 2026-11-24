import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/themes/app_theme.dart';

class MemoriesArchiveApp extends StatelessWidget {
  const MemoriesArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: getIt<AppRouter>().router,
      scrollBehavior: const _AppScrollBehavior(),
    );
  }
}

/// Lets lists and page views be dragged with a mouse or trackpad too.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}