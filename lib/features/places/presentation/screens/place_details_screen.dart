import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Place details',
      description:
          'Cover photo, name, area, visited status, location, your note and the memories saved at this place, with "Add a memory here" and "Then & Now".',
    );
  }
}
