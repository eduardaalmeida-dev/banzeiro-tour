import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalDatabase {
  LocalDatabase._({
    required this.schemaMeta,
    required this.boatTrips,
    required this.trails,
    required this.crafts,
    required this.meals,
    required this.craftImages,
  });

  static const schemaVersion = 1;
  static const _schemaMetaBox = 'schema_meta';
  static const boatTripsBox = 'boat_trips';
  static const trailsBox = 'trails';
  static const craftsBox = 'crafts';
  static const mealsBox = 'meals';
  static const craftImagesBox = 'craft_images';
  static const _schemaVersionKey = 'schema_version';

  final Box<dynamic> schemaMeta;
  final Box<dynamic> boatTrips;
  final Box<dynamic> trails;
  final Box<dynamic> crafts;
  final Box<dynamic> meals;
  final Box<dynamic> craftImages;

  static Future<LocalDatabase> initialize({String? storagePath}) async {
    if (storagePath == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(storagePath);
    }

    final schemaMeta = await _openBox(_schemaMetaBox);
    final version = _readVersion(schemaMeta.get(_schemaVersionKey));
    await _migrate(schemaMeta, version);

    return LocalDatabase._(
      schemaMeta: schemaMeta,
      boatTrips: await _openBox(boatTripsBox),
      trails: await _openBox(trailsBox),
      crafts: await _openBox(craftsBox),
      meals: await _openBox(mealsBox),
      craftImages: await _openBox(craftImagesBox),
    );
  }

  static Future<void> _migrate(Box<dynamic> schemaMeta, int fromVersion) async {
    var current = fromVersion;

    if (current < 1) {
      await _openBox(boatTripsBox);
      await _openBox(trailsBox);
      await _openBox(craftsBox);
      await _openBox(mealsBox);
      await _openBox(craftImagesBox);
      current = 1;
      await schemaMeta.put(_schemaVersionKey, current);
    }

    if (current > schemaVersion) {
      throw StateError(
        'A base local requer uma versão mais recente do aplicativo.',
      );
    }
  }

  static Future<Box<dynamic>> _openBox(String name) => Hive.isBoxOpen(name)
      ? Future.value(Hive.box<dynamic>(name))
      : Hive.openBox<dynamic>(name);

  static int _readVersion(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };

  Future<void> close() => Hive.close();
}
