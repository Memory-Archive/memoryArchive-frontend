import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class PlaceFormScreen extends StatelessWidget {
  const PlaceFormScreen({super.key, this.placeId});

  /// Null when adding a new one.
  final String? placeId;

  @override
  Widget build(BuildContext context) {
    return ComingSoonScreen(
      title: placeId == null ? 'Add place' : 'Edit place',
      description:
          'Name, area or address, location (use current location), Visited / Want to visit, a note and a cover photo. Editing also shows Delete place.',
    );
  }
}
