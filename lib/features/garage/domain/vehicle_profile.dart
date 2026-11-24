import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_profile.freezed.dart';

enum EnergyType {
  /// Liquid/gas fuel bought per litre (petrol, diesel, LPG, CNG…).
  fuel,

  /// Battery electric, energy bought per kWh.
  electric,
}

/// A user's vehicle, in metric units.
///
/// * fuel: [consumptionPer100Km] = L/100 km, [capacity] = tank litres.
/// * electric: [consumptionPer100Km] = kWh/100 km, [capacity] = usable battery kWh.
///
/// Use `Units` to convert from mpg, km/L, mi/kWh, etc.
@freezed
abstract class VehicleProfile with _$VehicleProfile {
  const VehicleProfile._();

  @Assert('consumptionPer100Km > 0', 'consumption must be positive')
  @Assert('capacity > 0', 'capacity must be positive')
  @Assert('chargingEfficiency > 0 && chargingEfficiency <= 1', 'efficiency must be in (0, 1]')
  const factory VehicleProfile({
    required String id,
    required String name,
    required EnergyType energyType,
    required double consumptionPer100Km,
    required double capacity,

    /// Places fuel type code this vehicle uses, e.g. `DIESEL`, `REGULAR_UNLEADED`.
    /// Null for EVs.
    String? preferredFuelType,

    /// Share of bought energy that reaches the battery (charging losses).
    /// Defaults to 1.0 (no assumption); set e.g. 0.9 if the user knows it.
    @Default(1.0) double chargingEfficiency,
  }) = _VehicleProfile;

  bool get isElectric => energyType == EnergyType.electric;

  /// Purchase unit label: "L" or "kWh".
  String get unit => isElectric ? 'kWh' : 'L';

  /// Units (L or kWh) consumed driving [meters].
  double unitsForDistance(double meters) => meters / 1000 * consumptionPer100Km / 100;

  /// Units that must be *bought* to replace what driving [meters] consumed
  /// (accounts for charging losses on EVs).
  double unitsToBuyForDistance(double meters) => unitsForDistance(meters) / chargingEfficiency;

  /// Remaining range in meters at a tank/battery [level] in [0, 1].
  double rangeMeters(double level) {
    final l = level.clamp(0.0, 1.0);
    return capacity * l / consumptionPer100Km * 100 * 1000;
  }
}
