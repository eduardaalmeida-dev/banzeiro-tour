import 'package:banzeiro_tour/domain/provider_catalog/catalog_validation.dart';
import 'package:banzeiro_tour/domain/provider_catalog/models.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/provider_catalog_fakes.dart';

void main() {
  group('provider catalog models', () {
    test('normalizes persisted capacity and prices safely', () {
      final trip = BoatTrip.fromMap({
        'id': 'trip-1',
        'boat_name': 'Voadeira',
        'origin': 'Manaus',
        'destination': 'Tumbira',
        'departure_time': '08:30',
        'max_capacity': 8,
        'current_booked': 11,
        'price_per_seat': '90,50',
      });

      expect(trip.currentBooked, 8);
      expect(trip.pricePerSeat, 90.5);
      expect(trip.route, 'Manaus → Tumbira');
    });

    test('normalizes persisted portions and recognizes image paths', () {
      final meal = Meal.fromMap({
        'id': 'meal-1',
        'meal_type': 'Merenda',
        'dish_name': 'Bolo',
        'time_window': '15:00 - 16:00',
        'max_portions': 20,
        'reserved_portions': -2,
        'price': 10,
      });

      expect(meal.reservedPortions, 0);
      expect(
        CraftImagePath.isStoredImage(CraftImagePath.forCraft('craft-1')),
        isTrue,
      );
      expect(CraftImagePath.isStoredImage(CraftImagePath.placeholder), isFalse);
    });

    test('validates time windows and adjusts departure by thirty minutes', () {
      expect(CatalogValidation.timeWindow('11:30', '11:00'), isNotNull);
      expect(CatalogValidation.timeWindow('11:30', '13:30'), isNull);
      expect(CatalogValidation.adjustTime('08:30', -30), '08:00');
      expect(CatalogValidation.adjustTime('23:30', 30), '23:30');
    });
  });

  group('ProviderCatalogController', () {
    test('keeps catalog data when a controller is recreated', () async {
      final fakes = FakeProviderCatalogRepositories();
      final first = ProviderCatalogController.withRepositories(fakes.value);
      await first.initialize();

      await first.createBoatTrip(
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

      final recreated = ProviderCatalogController.withRepositories(fakes.value);
      await recreated.initialize();

      expect(recreated.boatTrips.items, hasLength(1));
      expect(recreated.boatTrips.items.single.destination, 'Tumbira');
    });

    test(
      'clamps meal reservations and craft stock before persistence',
      () async {
        final fakes = FakeProviderCatalogRepositories(
          crafts: const [
            Craft(
              id: 'craft-1',
              photoPath: CraftImagePath.placeholder,
              name: 'Colar',
              rawMaterial: CraftMaterial.naturalSeeds,
              quantity: 2,
              price: 45,
            ),
          ],
          meals: const [
            Meal(
              id: 'meal-1',
              mealType: MealType.forestLunch,
              dishName: 'Peixe',
              timeWindow: '11:30 - 13:30',
              maxPortions: 20,
              reservedPortions: 10,
              price: 45,
            ),
          ],
        );
        final controller = ProviderCatalogController.withRepositories(
          fakes.value,
        );
        await controller.initialize();

        await controller.updateCraftQuantity('craft-1', -4);
        await controller.updateMealReservations('meal-1', 99);

        expect(controller.crafts.items.single.quantity, 0);
        expect(controller.meals.items.single.reservedPortions, 20);
      },
    );

    test('exposes a recoverable storage failure', () async {
      final fakes = FakeProviderCatalogRepositories();
      fakes.boatTripRepository.listError = StateError('storage unavailable');
      final controller = ProviderCatalogController.withRepositories(
        fakes.value,
      );

      await controller.initialize();

      expect(controller.boatTrips.status, ProviderCatalogStatus.failure);
      expect(controller.trails.status, ProviderCatalogStatus.failure);
    });
  });
}
