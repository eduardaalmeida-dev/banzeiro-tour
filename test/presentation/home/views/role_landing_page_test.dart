import 'package:banzeiro_tour/core/services/api_service.dart';
import 'package:banzeiro_tour/presentation/experience/views/tourist_explore_page.dart';
import 'package:banzeiro_tour/presentation/home/views/role_landing_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/artisan_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/boatman_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/cook_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final destinations = <UserProfileType, Type>{
    UserProfileType.tourist: TouristExplorePage,
    UserProfileType.boatman: BoatmanPanelPage,
    UserProfileType.guide: GuidePanelPage,
    UserProfileType.artisan: ArtisanPanelPage,
    UserProfileType.cook: CookPanelPage,
  };

  for (final entry in destinations.entries) {
    testWidgets('${entry.key.label} resolves to its dashboard', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RoleLandingPage(profileType: entry.key)),
      );

      expect(find.byType(entry.value), findsOneWidget);
    });
  }
}
