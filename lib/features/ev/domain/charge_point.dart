import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/location/geo_point.dart';

part 'charge_point.freezed.dart';

/// Fast charging threshold used for filters/markers (DC fast ≥ 50 kW).
const kFastChargeKw = 50.0;

/// An EV charging location (Open Charge Map). Community data: fields may be
/// missing or outdated — shown with "last verified" dates, never filled in.
@freezed
abstract class ChargePoint with _$ChargePoint {
  const ChargePoint._();

  const factory ChargePoint({
    required String id,
    required String name,
    required GeoPoint location,
    String? address,
    String? operatorName,
    @Default(<ChargeConnector>[]) List<ChargeConnector> connectors,
    int? numberOfPoints,

    /// Null = status unknown.
    bool? isOperational,
    String? statusLabel,

    /// Operator's free-text cost (e.g. "0,39 €/kWh"). Never parsed into a price.
    String? usageCost,
    DateTime? lastVerified,
    DateTime? lastStatusUpdate,
  }) = _ChargePoint;

  double? get maxPowerKw {
    double? best;
    for (final c in connectors) {
      final p = c.powerKw;
      if (p != null && (best == null || p > best)) best = p;
    }
    return best;
  }

  bool get isFast => (maxPowerKw ?? 0) >= kFastChargeKw;

  Set<String> get connectorTypes => {for (final c in connectors) c.type};
}

@freezed
abstract class ChargeConnector with _$ChargeConnector {
  const factory ChargeConnector({
    required String type,
    double? powerKw,
    int? quantity,
    bool? isDc,
    bool? isOperational,
  }) = _ChargeConnector;
}

/// Client-side filters (no extra API calls).
@freezed
abstract class EvFilter with _$EvFilter {
  const EvFilter._();

  const factory EvFilter({
    @Default(0) double minPowerKw,

    /// Empty = any connector.
    @Default(<String>{}) Set<String> connectorTypes,
    @Default(false) bool operationalOnly,
  }) = _EvFilter;

  bool get isActive => minPowerKw > 0 || connectorTypes.isNotEmpty || operationalOnly;

  bool matches(ChargePoint p) {
    if (operationalOnly && p.isOperational != true) return false;
    final matching = p.connectors.where(
      (c) =>
          (connectorTypes.isEmpty || connectorTypes.contains(c.type)) &&
          (minPowerKw <= 0 || (c.powerKw ?? 0) >= minPowerKw),
    );
    // A station with no connector data only passes when no connector/power filter is set.
    if (p.connectors.isEmpty) return connectorTypes.isEmpty && minPowerKw <= 0;
    return matching.isNotEmpty;
  }

  List<ChargePoint> apply(List<ChargePoint> points) => [
    for (final p in points)
      if (matches(p)) p,
  ];
}

/// Marker label: "150 kW" / "22 kW" / "EV" when power is unknown.
String chargeMarkerLabel(ChargePoint p) {
  final kw = p.maxPowerKw;
  if (kw == null || kw <= 0) return 'EV';
  return '${kw >= 10 ? kw.round() : kw.toStringAsFixed(1)} kW';
}
