enum TrailLevel {
  light('Leve'),
  moderate('Moderada'),
  denseForest('Selva Densa');

  const TrailLevel(this.label);

  final String label;

  static TrailLevel fromStorage(Object? value) => TrailLevel.values.firstWhere(
    (level) => level.label == value,
    orElse: () => TrailLevel.light,
  );
}

enum CraftMaterial {
  naturalSeeds('Sementes Naturais'),
  fallenWood('Madeira Caída'),
  arumaFiber('Fibra de Arumã');

  const CraftMaterial(this.label);

  final String label;

  static CraftMaterial fromStorage(Object? value) =>
      CraftMaterial.values.firstWhere(
        (material) => material.label == value,
        orElse: () => CraftMaterial.naturalSeeds,
      );
}

enum MealType {
  regionalBreakfast('Café Regional'),
  forestLunch('Almoço da Floresta'),
  snack('Merenda');

  const MealType(this.label);

  final String label;

  static MealType fromStorage(Object? value) => MealType.values.firstWhere(
    (type) => type.label == value,
    orElse: () => MealType.forestLunch,
  );
}

class BoatTrip {
  const BoatTrip({
    required this.id,
    required this.boatName,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.maxCapacity,
    required this.currentBooked,
    required this.pricePerSeat,
  });

  final String id;
  final String boatName;
  final String origin;
  final String destination;
  final String departureTime;
  final int maxCapacity;
  final int currentBooked;
  final double pricePerSeat;

  String get route => '$origin → $destination';
  double get amountToReceive => currentBooked * pricePerSeat;
  double get occupancy => maxCapacity == 0 ? 0 : currentBooked / maxCapacity;

  Map<String, dynamic> toMap() => {
    'id': id,
    'boat_name': boatName,
    'origin': origin,
    'destination': destination,
    'departure_time': departureTime,
    'max_capacity': maxCapacity,
    'current_booked': currentBooked,
    'price_per_seat': pricePerSeat,
  };

  factory BoatTrip.fromMap(Map<dynamic, dynamic> map, {String? fallbackId}) =>
      BoatTrip(
        id: _string(map['id'], fallback: fallbackId),
        boatName: _string(map['boat_name']),
        origin: _string(map['origin']),
        destination: _string(map['destination']),
        departureTime: _string(map['departure_time']),
        maxCapacity: _positiveInt(map['max_capacity']),
        currentBooked: _clamp(
          _nonNegativeInt(map['current_booked']),
          0,
          _positiveInt(map['max_capacity']),
        ),
        pricePerSeat: _nonNegativeDouble(map['price_per_seat']),
      );
}

class Trail {
  const Trail({
    required this.id,
    required this.name,
    required this.level,
    required this.duration,
    required this.gpsCoordinates,
    required this.maxPeople,
  });

  final String id;
  final String name;
  final TrailLevel level;
  final String duration;
  final String gpsCoordinates;
  final int maxPeople;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'level': level.label,
    'duration': duration,
    'gps_coordinates': gpsCoordinates,
    'max_people': maxPeople,
  };

  factory Trail.fromMap(Map<dynamic, dynamic> map, {String? fallbackId}) =>
      Trail(
        id: _string(map['id'], fallback: fallbackId),
        name: _string(map['name']),
        level: TrailLevel.fromStorage(map['level']),
        duration: _string(map['duration']),
        gpsCoordinates: _string(map['gps_coordinates']),
        maxPeople: _positiveInt(map['max_people']),
      );
}

class Craft {
  const Craft({
    required this.id,
    required this.photoPath,
    required this.name,
    required this.rawMaterial,
    required this.quantity,
    required this.price,
  });

  final String id;
  final String photoPath;
  final String name;
  final CraftMaterial rawMaterial;
  final int quantity;
  final double price;

  Craft copyWith({String? photoPath, int? quantity}) => Craft(
    id: id,
    photoPath: photoPath ?? this.photoPath,
    name: name,
    rawMaterial: rawMaterial,
    quantity: quantity ?? this.quantity,
    price: price,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'photo_path': photoPath,
    'name': name,
    'raw_material': rawMaterial.label,
    'quantity': quantity,
    'price': price,
  };

  factory Craft.fromMap(Map<dynamic, dynamic> map, {String? fallbackId}) =>
      Craft(
        id: _string(map['id'], fallback: fallbackId),
        photoPath: _string(
          map['photo_path'],
          fallback: CraftImagePath.placeholder,
        ),
        name: _string(map['name']),
        rawMaterial: CraftMaterial.fromStorage(map['raw_material']),
        quantity: _nonNegativeInt(map['quantity']),
        price: _nonNegativeDouble(map['price']),
      );
}

class Meal {
  const Meal({
    required this.id,
    required this.mealType,
    required this.dishName,
    required this.timeWindow,
    required this.maxPortions,
    required this.reservedPortions,
    required this.price,
  });

  final String id;
  final MealType mealType;
  final String dishName;
  final String timeWindow;
  final int maxPortions;
  final int reservedPortions;
  final double price;

  double get reservationProgress =>
      maxPortions == 0 ? 0 : reservedPortions / maxPortions;

  Meal copyWith({int? reservedPortions}) => Meal(
    id: id,
    mealType: mealType,
    dishName: dishName,
    timeWindow: timeWindow,
    maxPortions: maxPortions,
    reservedPortions: reservedPortions ?? this.reservedPortions,
    price: price,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'meal_type': mealType.label,
    'dish_name': dishName,
    'time_window': timeWindow,
    'max_portions': maxPortions,
    'reserved_portions': reservedPortions,
    'price': price,
  };

  factory Meal.fromMap(Map<dynamic, dynamic> map, {String? fallbackId}) => Meal(
    id: _string(map['id'], fallback: fallbackId),
    mealType: MealType.fromStorage(map['meal_type']),
    dishName: _string(map['dish_name']),
    timeWindow: _string(map['time_window']),
    maxPortions: _positiveInt(map['max_portions']),
    reservedPortions: _clamp(
      _nonNegativeInt(map['reserved_portions']),
      0,
      _positiveInt(map['max_portions']),
    ),
    price: _nonNegativeDouble(map['price']),
  );
}

abstract final class CraftImagePath {
  static const placeholder = 'asset://craft-placeholder';

  static String forCraft(String craftId) => 'hive://craft-images/$craftId';

  static bool isStoredImage(String value) =>
      value.startsWith('hive://craft-images/');
}

String createCatalogId(String prefix) =>
    '$prefix-${DateTime.now().microsecondsSinceEpoch}';

String _string(Object? value, {String? fallback}) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty
      ? (fallback ?? '')
      : normalized;
}

int _positiveInt(Object? value) =>
    _nonNegativeInt(value).clamp(1, 1 << 31).toInt();

int _nonNegativeInt(Object? value) => switch (value) {
  int value => value < 0 ? 0 : value,
  num value => value < 0 ? 0 : value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};

double _nonNegativeDouble(Object? value) => switch (value) {
  num value => value < 0 ? 0 : value.toDouble(),
  String value =>
    (double.tryParse(value.replaceAll(',', '.')) ?? 0)
        .clamp(0, double.infinity)
        .toDouble(),
  _ => 0,
};

int _clamp(int value, int min, int max) => value.clamp(min, max).toInt();
