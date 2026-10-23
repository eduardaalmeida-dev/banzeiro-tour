import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
import '../../experience/views/tourist_explore_page.dart';
import '../../provider/views/artisan_panel_page.dart';
import '../../provider/views/boatman_panel_page.dart';
import '../../provider/views/cook_panel_page.dart';
import '../../provider/views/guide_panel_page.dart';

class RoleLandingPage extends StatelessWidget {
  const RoleLandingPage({super.key, required this.profileType});

  final UserProfileType profileType;

  @override
  Widget build(BuildContext context) => switch (profileType) {
    UserProfileType.tourist => const TouristExplorePage(),
    UserProfileType.boatman => const BoatmanPanelPage(),
    UserProfileType.guide => const GuidePanelPage(),
    UserProfileType.artisan => const ArtisanPanelPage(),
    UserProfileType.cook => const CookPanelPage(),
  };
}
