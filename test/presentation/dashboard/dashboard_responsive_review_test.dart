import 'package:banzeiro_tour/presentation/experience/views/tourist_explore_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/artisan_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/boatman_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/cook_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final screens = <String, Widget Function()>{
    'Explorar': () => const TouristExplorePage(),
    'Barqueiro': () => const BoatmanPanelPage(),
    'Guia': () => const GuidePanelPage(),
    'Artesã': () => const ArtisanPanelPage(),
    'Cozinheira': () => const CookPanelPage(),
  };
  final viewports = <String, Size>{
    '320 px': const Size(320, 844),
    '390x844': const Size(390, 844),
    'ampla': const Size(1024, 844),
  };

  for (final viewport in viewports.entries) {
    for (final screen in screens.entries) {
      testWidgets('${screen.key} renders without overflow at ${viewport.key}', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(viewport.value);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(MaterialApp(home: screen.value()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });
    }
  }
}
