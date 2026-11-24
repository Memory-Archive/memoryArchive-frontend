import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class DraftsScreen extends StatelessWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Drafts',
      description:
          'Memories you started but did not save, with Continue and Delete draft. Stored on the phone.',
    );
  }
}
