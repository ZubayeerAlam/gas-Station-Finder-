import 'vehicle_profile.dart';

enum CatalogKind { car, motorbike, electric }

/// A common vehicle in Bangladesh with *typical* starting values.
///
/// These are approximations to save typing, not official specifications: the
/// form says so and every value stays editable. Tank sizes are the usual
/// factory figure; consumption is a typical mixed city/highway figure and
/// varies a lot with traffic, load and condition.
class CatalogVehicle {
  const CatalogVehicle({
    required this.make,
    required this.model,
    required this.kind,
    required this.capacity,
    required this.consumptionPer100Km,
    this.fuelType,
  });

  final String make;
  final String model;
  final CatalogKind kind;

  /// Tank litres, or usable battery kWh for EVs.
  final double capacity;

  /// L/100 km, or kWh/100 km for EVs.
  final double consumptionPer100Km;

  /// Places fuel type code; null for EVs.
  final String? fuelType;

  String get name => '$make $model';
  EnergyType get energyType => kind == CatalogKind.electric ? EnergyType.electric : EnergyType.fuel;
}

const kVehicleCatalog = <CatalogVehicle>[
  // Cars
  CatalogVehicle(
    make: 'Toyota',
    model: 'Axio',
    kind: CatalogKind.car,
    capacity: 42,
    consumptionPer100Km: 6.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Allion',
    kind: CatalogKind.car,
    capacity: 60,
    consumptionPer100Km: 7.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Premio',
    kind: CatalogKind.car,
    capacity: 60,
    consumptionPer100Km: 7.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Corolla',
    kind: CatalogKind.car,
    capacity: 50,
    consumptionPer100Km: 7.0,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Noah',
    kind: CatalogKind.car,
    capacity: 55,
    consumptionPer100Km: 8.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Probox',
    kind: CatalogKind.car,
    capacity: 50,
    consumptionPer100Km: 7.0,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Toyota',
    model: 'Hiace (diesel)',
    kind: CatalogKind.car,
    capacity: 70,
    consumptionPer100Km: 10.5,
    fuelType: 'DIESEL',
  ),
  CatalogVehicle(
    make: 'Honda',
    model: 'Vezel Hybrid',
    kind: CatalogKind.car,
    capacity: 40,
    consumptionPer100Km: 5.0,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Honda',
    model: 'Grace Hybrid',
    kind: CatalogKind.car,
    capacity: 40,
    consumptionPer100Km: 4.8,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Honda',
    model: 'Civic',
    kind: CatalogKind.car,
    capacity: 47,
    consumptionPer100Km: 7.0,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Suzuki',
    model: 'Swift',
    kind: CatalogKind.car,
    capacity: 37,
    consumptionPer100Km: 5.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Nissan',
    model: 'X-Trail',
    kind: CatalogKind.car,
    capacity: 60,
    consumptionPer100Km: 8.5,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Mitsubishi',
    model: 'Pajero Sport (diesel)',
    kind: CatalogKind.car,
    capacity: 68,
    consumptionPer100Km: 9.5,
    fuelType: 'DIESEL',
  ),
  // Motorbikes
  CatalogVehicle(
    make: 'Bajaj',
    model: 'Pulsar 150',
    kind: CatalogKind.motorbike,
    capacity: 15,
    consumptionPer100Km: 2.4,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Yamaha',
    model: 'FZ-S V3',
    kind: CatalogKind.motorbike,
    capacity: 13,
    consumptionPer100Km: 2.2,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Honda',
    model: 'CB Hornet 160R',
    kind: CatalogKind.motorbike,
    capacity: 12,
    consumptionPer100Km: 2.4,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'TVS',
    model: 'Apache RTR 160 4V',
    kind: CatalogKind.motorbike,
    capacity: 12,
    consumptionPer100Km: 2.4,
    fuelType: 'REGULAR_UNLEADED',
  ),
  CatalogVehicle(
    make: 'Suzuki',
    model: 'Gixxer 155',
    kind: CatalogKind.motorbike,
    capacity: 12,
    consumptionPer100Km: 2.3,
    fuelType: 'REGULAR_UNLEADED',
  ),
  // Electric
  CatalogVehicle(make: 'BYD', model: 'Atto 3', kind: CatalogKind.electric, capacity: 60, consumptionPer100Km: 16),
  CatalogVehicle(make: 'BYD', model: 'Dolphin', kind: CatalogKind.electric, capacity: 44.9, consumptionPer100Km: 14.5),
];

/// Every word of [query] must appear in "make model" (any order, any case).
/// An empty query returns the whole catalog.
List<CatalogVehicle> searchCatalog(String query, [List<CatalogVehicle> catalog = kVehicleCatalog]) {
  final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  return [
    for (final v in catalog)
      if (words.every(v.name.toLowerCase().contains)) v,
  ];
}
