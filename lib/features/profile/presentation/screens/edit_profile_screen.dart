import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

/// Placeholder until this screen is built. The route and links already work.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Edit profile',
      description:
          'Change photo, display name, username (3 to 30 characters: letters, numbers, dots and underscores) and bio (up to 500 characters). Uses PATCH /users/me.',
    );
  }
}
