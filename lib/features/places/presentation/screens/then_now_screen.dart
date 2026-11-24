import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class ThenNowScreen extends StatelessWidget {
  const ThenNowScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Then & Now',
      description:
          'Two photos of the same place from different years, with a slider to compare them. Uses the media_comparisons table.',
    );
  }
}
