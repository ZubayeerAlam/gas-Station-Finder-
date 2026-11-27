import '../../garage/domain/vehicle_profile.dart';
import '../../history/domain/fill_up.dart';

/// Fuel or energy a route needs for the active vehicle, and what that costs at
/// the price the user last paid. No price is guessed: without a fill-up in
/// History the cost is null.
class RouteEnergyEstimate {
  const RouteEnergyEstimate({required this.units, required this.unit, this.cost, this.currencyCode});

  /// Litres or kWh to buy (charging losses included for EVs).
  final double units;
  final String unit;
  final double? cost;
  final String? currencyCode;
}

RouteEnergyEstimate estimateRouteEnergy(double meters, VehicleProfile vehicle, {FillUp? lastFillUp}) {
  final units = vehicle.unitsToBuyForDistance(meters);
  final price = lastFillUp?.unitPrice;
  return RouteEnergyEstimate(
    units: units,
    unit: vehicle.unit,
    cost: price == null ? null : units * price,
    currencyCode: lastFillUp?.currencyCode,
  );
}

/// Whether the vehicle reaches the end of a route from a tank / battery level.
class TripReach {
  const TripReach({required this.rangeMeters, required this.routeMeters, required this.arrivalLevel});

  /// Range at the starting level.
  final double rangeMeters;
  final double routeMeters;

  /// Level left on arrival in [0, 1]; negative means it runs out first.
  final double arrivalLevel;

  bool get reachesDestination => arrivalLevel >= 0;

  /// How far short of the destination it runs out (0 when it reaches).
  double get shortfallMeters => reachesDestination ? 0 : routeMeters - rangeMeters;
}

/// Driving consumption only (charging losses affect what is bought, not range).
TripReach tripReach(VehicleProfile vehicle, {required double level, required double routeMeters}) {
  final l = level.clamp(0.0, 1.0);
  return TripReach(
    rangeMeters: vehicle.rangeMeters(l),
    routeMeters: routeMeters,
    arrivalLevel: l - vehicle.unitsForDistance(routeMeters) / vehicle.capacity,
  );
}
