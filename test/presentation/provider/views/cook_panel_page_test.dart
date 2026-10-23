import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:banzeiro_tour/presentation/provider/views/cook_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/provider_catalog_fakes.dart';

void main() {
  testWidgets('cook panel clamps and persists meal reservations', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories(
      meals: const [
        Meal(
          id: 'meal-1',
          mealType: MealType.forestLunch,
          dishName: 'Peixe Moqueado',
          timeWindow: '11:30 - 13:30',
          maxPortions: 2,
          reservedPortions: 1,
          price: 45,
        ),
      ],
    );
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: CookPanelPage(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('meal-meal-1-increase')));
    await tester.pump();
    await tester.pump();
    expect(find.text('2 de 2 pratos reservados'), findsOneWidget);

    expect(controller.meals.items.single.reservedPortions, 2);
  });
}
