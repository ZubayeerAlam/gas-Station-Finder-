import 'package:freezed_annotation/freezed_annotation.dart';

part 'fill_up.freezed.dart';

/// One refuel or charging session, as entered by the user.
///
/// [amount] is in the vehicle's purchase unit (L or kWh). Money is kept in the
/// currency the user paid in — FuelWise never converts currencies.
@freezed
abstract class FillUp with _$FillUp {
  const FillUp._();

  @Assert('amount > 0', 'amount must be positive')
  @Assert('totalCost >= 0', 'totalCost must not be negative')
  const factory FillUp({
    required String id,
    required String vehicleId,
    required DateTime date,
    required double amount,
    required double totalCost,
    required String currencyCode,

    /// Odometer reading in km; needed for consumption / cost-per-km.
    double? odometerKm,

    /// Filled to full (tank full / charged to the usual target). Consumption
    /// is computed full-to-full, so partial fills are added to the next one.
    @Default(true) bool isFull,
    String? stationName,
  }) = _FillUp;

  double get unitPrice => totalCost / amount;
}
