import 'package:flutter/foundation.dart';

import '../../../data/repositories/provider_catalog_repositories.dart';
import '../../../domain/provider_catalog/models.dart';

enum ProviderCatalogStatus { loading, ready, failure }

class ProviderCatalogState<T> {
  const ProviderCatalogState({
    required this.status,
    this.items = const [],
    this.error,
  });

  const ProviderCatalogState.loading()
    : this(status: ProviderCatalogStatus.loading);

  final ProviderCatalogStatus status;
  final List<T> items;
  final Object? error;

  bool get isEmpty => status == ProviderCatalogStatus.ready && items.isEmpty;

  ProviderCatalogState<T> ready(List<T> values) => ProviderCatalogState(
    status: ProviderCatalogStatus.ready,
    items: List.unmodifiable(values),
  );

  ProviderCatalogState<T> failure(Object value) => ProviderCatalogState(
    status: ProviderCatalogStatus.failure,
    items: items,
    error: value,
  );
}

typedef ProviderCatalogBootstrap =
    Future<ProviderCatalogRepositories> Function();

class ProviderCatalogController extends ChangeNotifier {
  factory ProviderCatalogController({
    required ProviderCatalogBootstrap bootstrap,
  }) => ProviderCatalogController._(bootstrap);

  ProviderCatalogController._(this._bootstrap);

  ProviderCatalogController.withRepositories(
    ProviderCatalogRepositories repositories,
  ) : _bootstrap = (() async => repositories),
      _repositories = repositories;

  final ProviderCatalogBootstrap _bootstrap;
  ProviderCatalogRepositories? _repositories;

  ProviderCatalogState<BoatTrip> _boatTrips =
      const ProviderCatalogState.loading();
  ProviderCatalogState<Trail> _trails = const ProviderCatalogState.loading();
  ProviderCatalogState<Craft> _crafts = const ProviderCatalogState.loading();
  ProviderCatalogState<Meal> _meals = const ProviderCatalogState.loading();
  bool _isWriting = false;
  Object? _operationError;

  ProviderCatalogState<BoatTrip> get boatTrips => _boatTrips;
  ProviderCatalogState<Trail> get trails => _trails;
  ProviderCatalogState<Craft> get crafts => _crafts;
  ProviderCatalogState<Meal> get meals => _meals;
  bool get isWriting => _isWriting;
  Object? get operationError => _operationError;

  Future<void> initialize() => reload();

  Future<void> reload() async {
    _boatTrips = const ProviderCatalogState.loading();
    _trails = const ProviderCatalogState.loading();
    _crafts = const ProviderCatalogState.loading();
    _meals = const ProviderCatalogState.loading();
    _operationError = null;
    notifyListeners();

    try {
      final repositories = _repositories ??= await _bootstrap();
      final values = await Future.wait([
        repositories.boatTrips.list(),
        repositories.trails.list(),
        repositories.crafts.list(),
        repositories.meals.list(),
      ]);
      _boatTrips = _boatTrips.ready(values[0] as List<BoatTrip>);
      _trails = _trails.ready(values[1] as List<Trail>);
      _crafts = _crafts.ready(values[2] as List<Craft>);
      _meals = _meals.ready(values[3] as List<Meal>);
    } catch (error) {
      _boatTrips = _boatTrips.failure(error);
      _trails = _trails.failure(error);
      _crafts = _crafts.failure(error);
      _meals = _meals.failure(error);
    }
    notifyListeners();
  }

  Future<void> createBoatTrip(BoatTrip trip) => _write(() async {
    final repositories = await _requireRepositories();
    await repositories.boatTrips.save(trip);
    _boatTrips = _boatTrips.ready([..._boatTrips.items, trip]);
  });

  Future<void> createTrail(Trail trail) => _write(() async {
    final repositories = await _requireRepositories();
    await repositories.trails.save(trail);
    _trails = _trails.ready([..._trails.items, trail]);
  });

  Future<void> createCraft(Craft craft, {Uint8List? imageBytes}) =>
      _write(() async {
        final repositories = await _requireRepositories();
        final withImage = imageBytes == null
            ? craft
            : craft.copyWith(
                photoPath: await repositories.craftImages.save(
                  craft.id,
                  imageBytes,
                ),
              );
        await repositories.crafts.save(withImage);
        _crafts = _crafts.ready([..._crafts.items, withImage]);
      });

  Future<void> createMeal(Meal meal) => _write(() async {
    final repositories = await _requireRepositories();
    await repositories.meals.save(meal);
    _meals = _meals.ready([..._meals.items, meal]);
  });

  Future<void> updateCraftQuantity(String craftId, int value) =>
      _write(() async {
        final repositories = await _requireRepositories();
        final updated = await repositories.crafts.updateQuantity(
          craftId,
          value < 0 ? 0 : value,
        );
        if (updated == null) {
          return;
        }
        _crafts = _crafts.ready(
          _crafts.items
              .map((craft) => craft.id == craftId ? updated : craft)
              .toList(growable: false),
        );
      });

  Future<void> updateMealReservations(String mealId, int value) =>
      _write(() async {
        final current = _meals.items
            .where((meal) => meal.id == mealId)
            .firstOrNull;
        if (current == null) {
          return;
        }
        final repositories = await _requireRepositories();
        final normalized = value.clamp(0, current.maxPortions).toInt();
        final updated = await repositories.meals.updateReservedPortions(
          mealId,
          normalized,
        );
        if (updated == null) {
          return;
        }
        _meals = _meals.ready(
          _meals.items
              .map((meal) => meal.id == mealId ? updated : meal)
              .toList(growable: false),
        );
      });

  Future<Uint8List?> craftImage(String photoPath) async {
    final repositories = _repositories;
    return repositories?.craftImages.read(photoPath);
  }

  Future<ProviderCatalogRepositories> _requireRepositories() async =>
      _repositories ??= await _bootstrap();

  Future<void> _write(Future<void> Function() operation) async {
    if (_isWriting) {
      throw StateError('Uma gravação já está em andamento.');
    }
    _isWriting = true;
    _operationError = null;
    notifyListeners();
    try {
      await operation();
    } catch (error) {
      _operationError = error;
      rethrow;
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }
}

extension IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
