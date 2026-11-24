import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class CreateMemoryScreen extends StatelessWidget {
  const CreateMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'New memory',
      description:
          'Photos (up to 10, one is the cover), title, date and optional time, place, and a note. The date and place can be read from the photo. Drafts save automatically.',
    );
  }
}
