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
