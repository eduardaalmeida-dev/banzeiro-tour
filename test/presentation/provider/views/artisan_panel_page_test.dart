import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:banzeiro_tour/presentation/provider/views/artisan_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/provider_catalog_fakes.dart';

void main() {
  testWidgets('artisan panel persists local stock changes', (tester) async {
    final fakes = FakeProviderCatalogRepositories(
      crafts: const [
        Craft(
          id: 'craft-1',
          photoPath: CraftImagePath.placeholder,
          name: 'Colar de Jarina',
          rawMaterial: CraftMaterial.naturalSeeds,
          quantity: 2,
          price: 45,
        ),
      ],
    );
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: ArtisanPanelPage(controller: controller)),
    );
    final decrease = find.byKey(const Key('craft-craft-1-decrease'));
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(decrease);
    await tester.pump();
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const Key('craft-craft-1-quantity'))).data,
      '1',
    );
    expect(controller.crafts.items.single.quantity, 1);

    final recreated = ProviderCatalogController.withRepositories(fakes.value);
    await recreated.initialize();
    expect(recreated.crafts.items.single.quantity, 1);
  });
}
