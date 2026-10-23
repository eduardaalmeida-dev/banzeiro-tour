import 'dart:typed_data';

import '../../domain/provider_catalog/models.dart';
import '../local/local_database.dart';

abstract interface class BoatTripRepository {
  Future<List<BoatTrip>> list();
  Future<void> save(BoatTrip trip);
}

abstract interface class TrailRepository {
  Future<List<Trail>> list();
  Future<void> save(Trail trail);
}

abstract interface class CraftRepository {
  Future<List<Craft>> list();
  Future<void> save(Craft craft);
  Future<Craft?> updateQuantity(String id, int quantity);
}

abstract interface class MealRepository {
  Future<List<Meal>> list();
  Future<void> save(Meal meal);
  Future<Meal?> updateReservedPortions(String id, int reservedPortions);
}

abstract interface class CraftImageRepository {
  Future<String> save(String craftId, Uint8List bytes);
  Future<Uint8List?> read(String photoPath);
}

class HiveBoatTripRepository implements BoatTripRepository {
  HiveBoatTripRepository(this._database);

  final LocalDatabase _database;

  @override
  Future<List<BoatTrip>> list() async => _records(
    _database.boatTrips.toMap().entries,
    (map, id) => BoatTrip.fromMap(map, fallbackId: id),
  );

  @override
  Future<void> save(BoatTrip trip) =>
      _database.boatTrips.put(trip.id, trip.toMap());
}

class HiveTrailRepository implements TrailRepository {
  HiveTrailRepository(this._database);

  final LocalDatabase _database;

  @override
  Future<List<Trail>> list() async => _records(
    _database.trails.toMap().entries,
    (map, id) => Trail.fromMap(map, fallbackId: id),
  );

  @override
  Future<void> save(Trail trail) =>
      _database.trails.put(trail.id, trail.toMap());
}

class HiveCraftRepository implements CraftRepository {
  HiveCraftRepository(this._database);

  final LocalDatabase _database;

  @override
  Future<List<Craft>> list() async => _records(
    _database.crafts.toMap().entries,
    (map, id) => Craft.fromMap(map, fallbackId: id),
  );

  @override
  Future<void> save(Craft craft) =>
      _database.crafts.put(craft.id, craft.toMap());

  @override
  Future<Craft?> updateQuantity(String id, int quantity) async {
    final raw = _database.crafts.get(id);
    if (raw is! Map) {
      return null;
    }
    final craft = Craft.fromMap(
      raw,
      fallbackId: id,
    ).copyWith(quantity: quantity < 0 ? 0 : quantity);
    await save(craft);
    return craft;
  }
}

class HiveMealRepository implements MealRepository {
  HiveMealRepository(this._database);

  final LocalDatabase _database;

  @override
  Future<List<Meal>> list() async => _records(
    _database.meals.toMap().entries,
    (map, id) => Meal.fromMap(map, fallbackId: id),
  );

  @override
  Future<void> save(Meal meal) => _database.meals.put(meal.id, meal.toMap());

  @override
  Future<Meal?> updateReservedPortions(String id, int reservedPortions) async {
    final raw = _database.meals.get(id);
    if (raw is! Map) {
      return null;
    }
    final currentMeal = Meal.fromMap(raw, fallbackId: id);
    final meal = currentMeal.copyWith(
      reservedPortions: reservedPortions
          .clamp(0, currentMeal.maxPortions)
          .toInt(),
    );
    await save(meal);
    return meal;
  }
}

class HiveCraftImageRepository implements CraftImageRepository {
  HiveCraftImageRepository(this._database);

  final LocalDatabase _database;

  @override
  Future<String> save(String craftId, Uint8List bytes) async {
    await _database.craftImages.put(craftId, bytes);
    return CraftImagePath.forCraft(craftId);
  }

  @override
  Future<Uint8List?> read(String photoPath) async {
    if (!CraftImagePath.isStoredImage(photoPath)) {
      return null;
    }
    final imageId = photoPath.split('/').last;
    final value = _database.craftImages.get(imageId);
    return switch (value) {
      Uint8List value => value,
      List<int> value => Uint8List.fromList(value),
      _ => null,
    };
  }
}

class ProviderCatalogRepositories {
  const ProviderCatalogRepositories({
    required this.boatTrips,
    required this.trails,
    required this.crafts,
    required this.meals,
    required this.craftImages,
  });

  final BoatTripRepository boatTrips;
  final TrailRepository trails;
  final CraftRepository crafts;
  final MealRepository meals;
  final CraftImageRepository craftImages;

  factory ProviderCatalogRepositories.fromDatabase(LocalDatabase database) =>
      ProviderCatalogRepositories(
        boatTrips: HiveBoatTripRepository(database),
        trails: HiveTrailRepository(database),
        crafts: HiveCraftRepository(database),
        meals: HiveMealRepository(database),
        craftImages: HiveCraftImageRepository(database),
      );
}

List<T> _records<T>(
  Iterable<MapEntry<dynamic, dynamic>> entries,
  T Function(Map<dynamic, dynamic> map, String id) convert,
) => entries
    .where((entry) => entry.value is Map)
    .map(
      (entry) => convert(entry.value as Map<dynamic, dynamic>, '${entry.key}'),
    )
    .toList(growable: false);
