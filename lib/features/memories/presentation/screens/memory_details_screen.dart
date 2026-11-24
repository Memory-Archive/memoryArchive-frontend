import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class MemoryDetailsScreen extends StatelessWidget {
  const MemoryDetailsScreen({super.key, required this.memoryId});

  final String memoryId;

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Memory',
      description:
          'Swipe through the photos, then the title, date and time, place and note. Star to add to favourites; the pencil opens Edit memory.',
    );
  }
}
