import 'dart:async';
import 'dart:typed_data';

import 'package:banzeiro_tour/data/repositories/provider_catalog_repositories.dart';
import 'package:banzeiro_tour/domain/provider_catalog/models.dart';

class FakeProviderCatalogRepositories {
  FakeProviderCatalogRepositories({
    List<BoatTrip>? boatTrips,
    List<Trail>? trails,
    List<Craft>? crafts,
    List<Meal>? meals,
  }) : boatTripRepository = FakeBoatTripRepository(boatTrips ?? []),
       trailRepository = FakeTrailRepository(trails ?? []),
       craftRepository = FakeCraftRepository(crafts ?? []),
       mealRepository = FakeMealRepository(meals ?? []),
       craftImageRepository = FakeCraftImageRepository();

  final FakeBoatTripRepository boatTripRepository;
  final FakeTrailRepository trailRepository;
  final FakeCraftRepository craftRepository;
  final FakeMealRepository mealRepository;
  final FakeCraftImageRepository craftImageRepository;

  ProviderCatalogRepositories get value => ProviderCatalogRepositories(
    boatTrips: boatTripRepository,
    trails: trailRepository,
    crafts: craftRepository,
    meals: mealRepository,
    craftImages: craftImageRepository,
  );
}

class FakeBoatTripRepository implements BoatTripRepository {
  FakeBoatTripRepository(List<BoatTrip> values) : _values = List.of(values);

  final List<BoatTrip> _values;
  Object? listError;
  Object? saveError;
  Completer<void>? pendingSave;
  var saveCalls = 0;

  @override
  Future<List<BoatTrip>> list() async {
    if (listError != null) throw listError!;
    return List.unmodifiable(_values);
  }

  @override
  Future<void> save(BoatTrip trip) async {
    saveCalls++;
    if (saveError != null) throw saveError!;
    await pendingSave?.future;
    _values.add(trip);
  }
}

class FakeTrailRepository implements TrailRepository {
  FakeTrailRepository(List<Trail> values) : _values = List.of(values);

  final List<Trail> _values;

  @override
  Future<List<Trail>> list() async => List.unmodifiable(_values);

  @override
  Future<void> save(Trail trail) async => _values.add(trail);
}

class FakeCraftRepository implements CraftRepository {
  FakeCraftRepository(List<Craft> values) : _values = List.of(values);

  final List<Craft> _values;

  @override
  Future<List<Craft>> list() async => List.unmodifiable(_values);

  @override
  Future<void> save(Craft craft) async => _values.add(craft);

  @override
  Future<Craft?> updateQuantity(String id, int quantity) async {
    final index = _values.indexWhere((craft) => craft.id == id);
    if (index < 0) return null;
    final updated = _values[index].copyWith(quantity: quantity);
    _values[index] = updated;
    return updated;
  }
}

class FakeMealRepository implements MealRepository {
  FakeMealRepository(List<Meal> values) : _values = List.of(values);

  final List<Meal> _values;

  @override
  Future<List<Meal>> list() async => List.unmodifiable(_values);

  @override
  Future<void> save(Meal meal) async => _values.add(meal);

  @override
  Future<Meal?> updateReservedPortions(String id, int reservedPortions) async {
    final index = _values.indexWhere((meal) => meal.id == id);
    if (index < 0) return null;
    final updated = _values[index].copyWith(reservedPortions: reservedPortions);
    _values[index] = updated;
    return updated;
  }
}

class FakeCraftImageRepository implements CraftImageRepository {
  final Map<String, Uint8List> _images = {};

  @override
  Future<String> save(String craftId, Uint8List bytes) async {
    _images[craftId] = bytes;
    return CraftImagePath.forCraft(craftId);
  }

  @override
  Future<Uint8List?> read(String photoPath) async =>
      _images[photoPath.split('/').last];
}
