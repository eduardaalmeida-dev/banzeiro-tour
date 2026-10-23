import 'dart:io';
import 'dart:typed_data';

import 'package:banzeiro_tour/data/local/local_database.dart';
import 'package:banzeiro_tour/data/repositories/provider_catalog_repositories.dart';
import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'creates versioned empty boxes and preserves compatible records',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'banzeiro-catalog-test-',
      );
      try {
        final first = await LocalDatabase.initialize(
          storagePath: directory.path,
        );
        expect(
          first.schemaMeta.get('schema_version'),
          LocalDatabase.schemaVersion,
        );
        expect(first.boatTrips.values, isEmpty);
        await first.boatTrips.put('trip-1', {
          'id': 'trip-1',
          'boat_name': 'Voadeira',
          'origin': 'Manaus',
          'destination': 'Tumbira',
          'departure_time': '08:30',
          'max_capacity': 8,
          'current_booked': 0,
          'price_per_seat': 90,
        });
        await first.close();

        final reopened = await LocalDatabase.initialize(
          storagePath: directory.path,
        );
        expect(
          reopened.schemaMeta.get('schema_version'),
          LocalDatabase.schemaVersion,
        );
        expect(reopened.boatTrips.get('trip-1'), isNotNull);
        await reopened.close();
      } finally {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      }
    },
  );

  test('keeps all catalogs isolated and persists bounded updates', () async {
    final directory = await Directory.systemTemp.createTemp(
      'banzeiro-catalog-repositories-test-',
    );
    try {
      final database = await LocalDatabase.initialize(
        storagePath: directory.path,
      );
      final repositories = ProviderCatalogRepositories.fromDatabase(database);
      const craftId = 'craft-1';

      await repositories.boatTrips.save(
        const BoatTrip(
          id: 'trip-1',
          boatName: 'Voadeira',
          origin: 'Manaus',
          destination: 'Tumbira',
          departureTime: '08:30',
          maxCapacity: 8,
          currentBooked: 0,
          pricePerSeat: 90,
        ),
      );
      await repositories.trails.save(
        const Trail(
          id: 'trail-1',
          name: 'Trilha da Samaúma',
          level: TrailLevel.moderate,
          duration: '2h',
          gpsCoordinates: 'Não capturado',
          maxPeople: 10,
        ),
      );
      await repositories.crafts.save(
        const Craft(
          id: craftId,
          photoPath: CraftImagePath.placeholder,
          name: 'Colar',
          rawMaterial: CraftMaterial.naturalSeeds,
          quantity: 2,
          price: 45,
        ),
      );
      await repositories.meals.save(
        const Meal(
          id: 'meal-1',
          mealType: MealType.forestLunch,
          dishName: 'Peixe Moqueado',
          timeWindow: '11:30 - 13:30',
          maxPortions: 4,
          reservedPortions: 0,
          price: 45,
        ),
      );

      final imagePath = await repositories.craftImages.save(
        craftId,
        Uint8List.fromList([1, 2, 3]),
      );
      final craft = await repositories.crafts.updateQuantity(craftId, -5);
      final meal = await repositories.meals.updateReservedPortions(
        'meal-1',
        99,
      );

      expect(await repositories.boatTrips.list(), hasLength(1));
      expect(await repositories.trails.list(), hasLength(1));
      expect(await repositories.crafts.list(), hasLength(1));
      expect(await repositories.meals.list(), hasLength(1));
      expect(craft?.quantity, 0);
      expect(meal?.reservedPortions, 4);
      expect(
        await repositories.craftImages.read(imagePath),
        orderedEquals([1, 2, 3]),
      );
      expect(
        await repositories.craftImages.read(CraftImagePath.placeholder),
        isNull,
      );
      await database.close();
    } finally {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  });
}
