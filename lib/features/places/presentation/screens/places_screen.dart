import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

/// Placeholder until this screen is built. The route and links already work.
class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Places',
      description:
          'Your saved places with search and the All / Visited / Want to visit filters, plus an Add place button. Uses /saved-places and /places.',
      tab: AppTab.places,
      showBack: false,
    );
  }
}
