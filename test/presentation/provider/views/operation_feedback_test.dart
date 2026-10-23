import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_scope.dart';
import 'package:banzeiro_tour/presentation/provider/views/artisan_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/boatman_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/cook_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/provider_catalog_fakes.dart';

void main() {
  testWidgets('scoped provider panel renders an empty local catalog', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      ProviderCatalogScope(
        controller: controller,
        child: const MaterialApp(home: BoatmanPanelPage()),
      ),
    );

    expect(
      find.text(
        'Nenhuma saída cadastrada. Cadastre a primeira viagem offline.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('catalog form can be cancelled without mutating local data', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatmanPanelPage(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('boatman-add-trip')));
    await tester.pumpAndSettle();

    expect(find.text('Nova Saída de Barco'), findsOneWidget);
    await tester.tap(find.byKey(const Key('catalog-form-back')));
    await tester.pumpAndSettle();

    expect(controller.boatTrips.items, isEmpty);
  });

  testWidgets('successful registration returns to and updates its panel', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatmanPanelPage(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('boatman-add-trip')));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'Manaus');
    await tester.enterText(fields.at(2), 'Tumbira');
    await tester.enterText(fields.at(3), '90');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Manaus → Tumbira'), findsOneWidget);
    expect(controller.boatTrips.items, hasLength(1));
  });

  testWidgets('all provider registration actions route to their forms', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();
    final destinations = [
      _CatalogDestination(
        page: BoatmanPanelPage(controller: controller),
        buttonKey: const Key('boatman-add-trip'),
        title: 'Nova Saída de Barco',
      ),
      _CatalogDestination(
        page: GuidePanelPage(controller: controller),
        buttonKey: const Key('guide-add-trail'),
        title: 'Nova Trilha',
      ),
      _CatalogDestination(
        page: ArtisanPanelPage(controller: controller),
        buttonKey: const Key('artisan-add-craft'),
        title: 'Nova Peça de Artesanato',
      ),
      _CatalogDestination(
        page: CookPanelPage(controller: controller),
        buttonKey: const Key('cook-plan-menu'),
        title: 'Nova Refeição',
      ),
    ];

    for (final destination in destinations) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(destination.title),
          home: destination.page,
        ),
      );
      await tester.tap(find.byKey(destination.buttonKey));
      await tester.pumpAndSettle();

      expect(find.text(destination.title), findsOneWidget);
    }
  });

  testWidgets('unrelated guide action keeps its pending feedback', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: GuidePanelPage(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('guide-release-stamp')));
    await tester.pump();

    expect(
      find.text('Liberação de selo estará disponível em breve.'),
      findsOneWidget,
    );
  });
}

class _CatalogDestination {
  const _CatalogDestination({
    required this.page,
    required this.buttonKey,
    required this.title,
  });

  final Widget page;
  final Key buttonKey;
  final String title;
}
