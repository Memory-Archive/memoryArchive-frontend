import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class EditMemoryScreen extends StatelessWidget {
  const EditMemoryScreen({super.key, required this.memoryId});

  final String memoryId;

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Edit memory',
      description:
          'The same form as New memory, filled in, with Remove on each photo and Delete memory at the bottom.',
    );
  }
}
