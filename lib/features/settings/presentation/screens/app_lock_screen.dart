import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'App lock',
      description:
          'A 4-digit PIN or fingerprint to open the app. The PIN is stored only on this phone (secure storage), never on the server.',
    );
  }
}
