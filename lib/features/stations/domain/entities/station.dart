import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/location/geo_point.dart';

part 'station.freezed.dart';

/// Lightweight station from a nearby search (Places "Pro" fields only to keep
/// per-request cost low). Rich data lives in [StationDetails].
@freezed
abstract class Station with _$Station {
  const factory Station({
    required String id,
    required String name,
    required GeoPoint location,
    String? address,
  }) = _Station;
}

/// Full station data from Place Details (Places API New).
/// Every optional field may legitimately be absent: fuel prices and EV data
/// are only provided for some countries/stations — never invent them.
@freezed
abstract class StationDetails with _$StationDetails {
  const StationDetails._();

  const factory StationDetails({
    required String id,
    required String name,
    required GeoPoint location,
    String? address,
    String? phone,
    double? rating,
    int? userRatingCount,
    bool? openNow,
    @Default(<String>[]) List<String> weekdayHours,
    @Default(<FuelPrice>[]) List<FuelPrice> fuelPrices,
    EvChargeInfo? evCharge,
    String? googleMapsUri,
  }) = _StationDetails;

  bool get hasFuelPrices => fuelPrices.isNotEmpty;
}

@freezed
abstract class FuelPrice with _$FuelPrice {
  const FuelPrice._();

  const factory FuelPrice({
    /// Raw Places fuel type code, e.g. `DIESEL`, `REGULAR_UNLEADED`, `SP95_E10`.
    required String fuelType,
    required double amount,
    required String currencyCode,
    DateTime? updatedAt,
  }) = _FuelPrice;

  String get fuelLabel => fuelTypeLabel(fuelType);
}

@freezed
abstract class EvChargeInfo with _$EvChargeInfo {
  const factory EvChargeInfo({
    int? connectorCount,
    @Default(<EvConnector>[]) List<EvConnector> connectors,
  }) = _EvChargeInfo;
}

@freezed
abstract class EvConnector with _$EvConnector {
  const factory EvConnector({
    required String type,
    double? maxChargeRateKw,
    int? count,

    /// Reported by Google where supported; not guaranteed real-time.
    int? availableCount,
    int? outOfServiceCount,
    DateTime? availabilityUpdatedAt,
  }) = _EvConnector;
}

const _fuelLabels = <String, String>{
  'DIESEL': 'Diesel',
  'DIESEL_PLUS': 'Diesel+',
  'TRUCK_DIESEL': 'Truck diesel',
  'BIO_DIESEL': 'Biodiesel',
  'REGULAR_UNLEADED': 'Regular',
  'MIDGRADE': 'Midgrade',
  'PREMIUM': 'Premium',
  'LPG': 'LPG',
  'METHANE': 'CNG / Methane',
  'E80': 'E80',
  'E85': 'E85',
  'E100': 'E100',
};

/// Human-readable label for a Places fuel type code.
String fuelTypeLabel(String code) {
  final known = _fuelLabels[code];
  if (known != null) return known;
  // SP95_E10 -> "SP95 E10"
  return code.replaceAll('_', ' ');
}

/// Human-readable label for a Places EV connector type code.
String evConnectorLabel(String code) {
  const labels = {
    'EV_CONNECTOR_TYPE_CCS_COMBO_1': 'CCS1',
    'EV_CONNECTOR_TYPE_CCS_COMBO_2': 'CCS2',
    'EV_CONNECTOR_TYPE_CHADEMO': 'CHAdeMO',
    'EV_CONNECTOR_TYPE_TESLA': 'Tesla',
    'EV_CONNECTOR_TYPE_J1772': 'J1772 (Type 1)',
    'EV_CONNECTOR_TYPE_TYPE_2': 'Type 2',
    'EV_CONNECTOR_TYPE_NACS': 'NACS',
    'EV_CONNECTOR_TYPE_UNSPECIFIED_GB_T': 'GB/T',
    'EV_CONNECTOR_TYPE_UNSPECIFIED_WALL_OUTLET': 'Wall outlet',
    'EV_CONNECTOR_TYPE_OTHER': 'Other',
  };
  return labels[code] ?? code.replaceFirst('EV_CONNECTOR_TYPE_', '').replaceAll('_', ' ');
}
