import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:banzeiro_tour/presentation/provider/views/boatman_panel_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/provider_catalog_fakes.dart';

void main() {
  testWidgets('boatman panel displays persisted trips and derived metrics', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories(
      boatTrips: const [
        BoatTrip(
          id: 'trip-1',
          boatName: 'Voadeira Rio Negro II',
          origin: 'Manaus',
          destination: 'Tumbira',
          departureTime: '08:30',
          maxCapacity: 10,
          currentBooked: 6,
          pricePerSeat: 120,
        ),
      ],
    );
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatmanPanelPage(controller: controller)),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('R\$ 720'), findsOneWidget);
    expect(find.text('Manaus → Tumbira'), findsOneWidget);
    expect(find.text('6/10 vagas'), findsOneWidget);
  });

  testWidgets('boatman panel guides users through an empty local catalog', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatmanPanelPage(controller: controller)),
    );

    expect(find.textContaining('Nenhuma saída cadastrada'), findsOneWidget);
    expect(find.text('Manaus → Tumbira'), findsNothing);
  });

  testWidgets('guide panel displays local published trails', (tester) async {
    final fakes = FakeProviderCatalogRepositories(
      trails: const [
        Trail(
          id: 'trail-1',
          name: 'Trilha da Samaúma',
          level: TrailLevel.moderate,
          duration: '3h',
          gpsCoordinates: '-2.9998°, -59.9120°',
          maxPeople: 8,
        ),
      ],
    );
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: GuidePanelPage(controller: controller)),
    );

    expect(find.text('Trilha da Samaúma'), findsAtLeastNWidgets(1));
    expect(find.text('Moderada'), findsOneWidget);
    expect(find.text('GPS: -2.9998°, -59.9120°'), findsOneWidget);
    expect(find.textContaining('até 8 ecoturistas'), findsOneWidget);
  });
}
