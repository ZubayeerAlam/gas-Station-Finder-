import 'vehicle_profile.dart';

/// Purchase unit for a Places fuel code: CNG (`METHANE`) is sold per cubic
/// metre in Bangladesh, every other liquid fuel per litre.
String purchaseUnitForFuel(String? code) => code == 'METHANE' ? 'm³' : 'L';

/// Cost of driving on one fuel. [pricePerUnit] is what the user typed; FuelWise
/// never guesses a price.
class FuelCostLine {
  const FuelCostLine({required this.fuelType, required this.unitsPer100Km, this.pricePerUnit});

  final String fuelType;
  final double unitsPer100Km;
  final double? pricePerUnit;

  String get unit => purchaseUnitForFuel(fuelType);

  /// km per purchase unit (km/L or km/m³).
  double get kmPerUnit => 100 / unitsPer100Km;

  double? get costPer100Km => pricePerUnit == null ? null : unitsPer100Km * pricePerUnit!;
  double? get costPerKm => costPer100Km == null ? null : costPer100Km! / 100;
}

/// Side-by-side running cost of a dual-fuel vehicle's two fuels.
class FuelComparison {
  const FuelComparison({required this.primary, required this.secondary});

  final FuelCostLine primary;
  final FuelCostLine secondary;

  bool get isComplete => primary.costPer100Km != null && secondary.costPer100Km != null;

  /// The cheaper line, or null while a price is missing or both cost the same.
  FuelCostLine? get cheaper {
    if (!isComplete) return null;
    final a = primary.costPer100Km!, b = secondary.costPer100Km!;
    if ((a - b).abs() < 1e-9) return null;
    return a < b ? primary : secondary;
  }

  /// How much the cheaper fuel saves per 100 km (0 when equal, null when incomplete).
  double? get savingPer100Km => isComplete ? (primary.costPer100Km! - secondary.costPer100Km!).abs() : null;

  /// Saving over [km] kilometres.
  double? savingFor(double km) => savingPer100Km == null ? null : savingPer100Km! * km / 100;

  /// The cheaper fuel's saving as a share of the dearer fuel's cost (0..1).
  double? get savingShare {
    if (!isComplete) return null;
    final dearer = primary.costPer100Km! > secondary.costPer100Km! ? primary.costPer100Km! : secondary.costPer100Km!;
    return dearer <= 0 ? null : savingPer100Km! / dearer;
  }
}

/// Builds the comparison for [vehicle], or null when it is not dual-fuel.
/// Prices must be positive; anything else is treated as "not entered".
FuelComparison? compareFuels(VehicleProfile vehicle, {double? primaryPrice, double? secondaryPrice}) {
  if (!vehicle.isDualFuel || vehicle.preferredFuelType == null) return null;
  double? valid(double? p) => p != null && p.isFinite && p > 0 ? p : null;
  return FuelComparison(
    primary: FuelCostLine(
      fuelType: vehicle.preferredFuelType!,
      unitsPer100Km: vehicle.consumptionPer100Km,
      pricePerUnit: valid(primaryPrice),
    ),
    secondary: FuelCostLine(
      fuelType: vehicle.secondaryFuelType!,
      unitsPer100Km: vehicle.secondaryConsumptionPer100Km!,
      pricePerUnit: valid(secondaryPrice),
    ),
  );
}
