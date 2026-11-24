import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Favourites',
      description:
          'Starred memories and places in two tabs. Needs the favourites tables (backend/favourites.mysql.sql).',
    );
  }
}
