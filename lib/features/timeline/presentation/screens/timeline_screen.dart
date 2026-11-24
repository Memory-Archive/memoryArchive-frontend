import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

/// Placeholder until this screen is built. The route and links already work.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      title: 'Timeline',
      description:
          'Every memory grouped by month and year, with a year picker at the top. Uses GET /memories with date filters.',
      tab: AppTab.timeline,
      showBack: false,
    );
  }
}
