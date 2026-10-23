import 'dart:async';
import 'dart:typed_data';

import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:banzeiro_tour/presentation/provider/views/catalog_forms/boat_trip_form_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/catalog_forms/craft_form_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/catalog_forms/meal_form_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/catalog_forms/trail_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../../../support/provider_catalog_fakes.dart';

void main() {
  testWidgets(
    'boat trip form validates required route fields then saves offline',
    (tester) async {
      final fakes = FakeProviderCatalogRepositories();
      final controller = ProviderCatalogController.withRepositories(
        fakes.value,
      );
      await controller.initialize();

      await tester.pumpWidget(
        MaterialApp(home: BoatTripFormPage(controller: controller)),
      );
      await tester.tap(find.byKey(const Key('catalog-form-submit')));
      await tester.pump();
      expect(find.text('Informe a origem.'), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'Manaus');
      await tester.enterText(fields.at(2), 'Tumbira');
      await tester.enterText(fields.at(3), '90,00');
      await tester.tap(find.byKey(const Key('catalog-form-submit')));
      await tester.pump();
      await tester.pump();

      expect(controller.boatTrips.items, hasLength(1));
      expect(controller.boatTrips.items.single.currentBooked, 0);
    },
  );

  testWidgets('keeps the form open after a write failure', (tester) async {
    final fakes = FakeProviderCatalogRepositories();
    fakes.boatTripRepository.saveError = StateError('disk unavailable');
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatTripFormPage(controller: controller)),
    );
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'Manaus');
    await tester.enterText(fields.at(2), 'Tumbira');
    await tester.enterText(fields.at(3), '90');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Nova Saída de Barco'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(fields.at(1)).controller!.text,
      'Manaus',
    );
    expect(controller.boatTrips.items, isEmpty);
  });

  testWidgets('blocks a duplicate submit while an offline write is pending', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    fakes.boatTripRepository.pendingSave = Completer<void>();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: BoatTripFormPage(controller: controller)),
    );
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'Manaus');
    await tester.enterText(fields.at(2), 'Tumbira');
    await tester.enterText(fields.at(3), '90');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();

    expect(fakes.boatTripRepository.saveCalls, 1);
    fakes.boatTripRepository.pendingSave!.complete();
    await tester.pump();
    await tester.pump();
    expect(controller.boatTrips.items, hasLength(1));
  });

  testWidgets('trail form supports the offline GPS marker', (tester) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: TrailFormPage(controller: controller)),
    );
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Trilha do Rio');
    await tester.enterText(fields.at(1), '2h');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.pump();

    expect(controller.trails.items.single.gpsCoordinates, 'Não capturado');
  });

  testWidgets('trail form saves the simulated offline GPS coordinate', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: TrailFormPage(controller: controller)),
    );
    await tester.tap(find.text('Capturar Coordenadas GPS (Sem Internet)'));
    await tester.pump(const Duration(milliseconds: 900));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Trilha do Rio');
    await tester.enterText(fields.at(1), '2h');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.pump();

    expect(
      controller.trails.items.single.gpsCoordinates,
      '-2.9998°, -59.9120°',
    );
  });

  testWidgets('craft form stores image bytes and accepts the local fallback', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();
    final imageBytes = Uint8List.fromList(_onePixelPng);
    final photoPicker = _FakeCraftPhotoPicker(imageBytes);

    await tester.pumpWidget(
      MaterialApp(
        home: CraftFormPage(controller: controller, photoPicker: photoPicker),
      ),
    );
    await tester.tap(find.text('Escolher da galeria'));
    await tester.pump();
    await tester.tap(find.text('Sementes Naturais'));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Colar de Jarina');
    await tester.enterText(fields.at(1), '45');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.pump();

    final craft = controller.crafts.items.single;
    expect(CraftImagePath.isStoredImage(craft.photoPath), isTrue);
    expect(
      await controller.craftImage(craft.photoPath),
      orderedEquals(imageBytes),
    );
  });

  testWidgets('meal form creates portions with zero reservations', (
    tester,
  ) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: MealFormPage(controller: controller)),
    );
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Peixe Moqueado');
    await tester.enterText(fields.at(1), '45');
    await tester.tap(find.byKey(const Key('catalog-form-submit')));
    await tester.pump();
    await tester.pump();

    expect(controller.meals.items, hasLength(1));
    expect(controller.meals.items.single.reservedPortions, 0);
  });
}

class _FakeCraftPhotoPicker implements CraftPhotoPicker {
  _FakeCraftPhotoPicker(this.bytes);

  final Uint8List bytes;

  @override
  Future<Uint8List?> pick(ImageSource source) async => bytes;

  @override
  Future<Uint8List?> recoverLostImage() async => null;
}

const _onePixelPng = <int>[
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  4,
  0,
  0,
  0,
  181,
  28,
  12,
  2,
  0,
  0,
  0,
  11,
  73,
  68,
  65,
  84,
  120,
  218,
  99,
  252,
  255,
  31,
  0,
  2,
  235,
  1,
  245,
  143,
  73,
  204,
  29,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];
