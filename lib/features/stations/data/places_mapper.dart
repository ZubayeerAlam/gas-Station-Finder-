import '../../../core/location/geo_point.dart';
import '../domain/entities/station.dart';

/// Maps Places API (New) JSON into domain entities.
/// Tolerant of missing fields; throws [FormatException] only when a station
/// lacks an id or location (unusable).
abstract final class PlacesMapper {
  static List<Station> stationsFromSearch(Map<String, dynamic> json) {
    final places = json['places'];
    if (places == null) return const []; // Places returns {} when nothing matches.
    if (places is! List) throw const FormatException('places is not a list');
    final result = <Station>[];
    final seen = <String>{};
    for (final raw in places) {
      if (raw is! Map<String, dynamic>) continue;
      final station = _tryStation(raw);
      if (station != null && seen.add(station.id)) result.add(station);
    }
    return result;
  }

  static StationDetails detailsFromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final location = _geo(json['location']);
    if (id == null || location == null) {
      throw const FormatException('Place details missing id or location');
    }
    final hours = json['currentOpeningHours'] as Map<String, dynamic>? ??
        json['regularOpeningHours'] as Map<String, dynamic>?;
    return StationDetails(
      id: id,
      name: _displayName(json) ?? 'Unnamed station',
      location: location,
      address: json['formattedAddress'] as String?,
      phone: (json['internationalPhoneNumber'] ?? json['nationalPhoneNumber']) as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingCount: (json['userRatingCount'] as num?)?.toInt(),
      openNow: (json['currentOpeningHours'] as Map<String, dynamic>?)?['openNow'] as bool?,
      weekdayHours: [
        for (final d in (hours?['weekdayDescriptions'] as List? ?? const [])) d.toString(),
      ],
      fuelPrices: _fuelPrices(json['fuelOptions']),
      evCharge: _evCharge(json['evChargeOptions']),
      googleMapsUri: json['googleMapsUri'] as String?,
    );
  }

  static Station? _tryStation(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final location = _geo(json['location']);
    if (id == null || location == null) return null;
    return Station(
      id: id,
      name: _displayName(json) ?? 'Unnamed station',
      location: location,
      address: (json['shortFormattedAddress'] ?? json['formattedAddress']) as String?,
    );
  }

  static String? _displayName(Map<String, dynamic> json) =>
      (json['displayName'] as Map<String, dynamic>?)?['text'] as String?;

  static GeoPoint? _geo(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final lat = (raw['latitude'] as num?)?.toDouble();
    final lng = (raw['longitude'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return GeoPoint(latitude: lat, longitude: lng);
  }

  static List<FuelPrice> _fuelPrices(Object? raw) {
    if (raw is! Map<String, dynamic>) return const [];
    final prices = raw['fuelPrices'];
    if (prices is! List) return const [];
    final out = <FuelPrice>[];
    for (final p in prices) {
      if (p is! Map<String, dynamic>) continue;
      final type = p['type'] as String?;
      final money = parseMoney(p['price']);
      if (type == null || money == null) continue; // never fabricate a price
      out.add(FuelPrice(
        fuelType: type,
        amount: money.amount,
        currencyCode: money.currency,
        updatedAt: DateTime.tryParse(p['updateTime'] as String? ?? ''),
      ));
    }
    return out;
  }

  static EvChargeInfo? _evCharge(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final aggregation = raw['connectorAggregation'];
    return EvChargeInfo(
      connectorCount: (raw['connectorCount'] as num?)?.toInt(),
      connectors: [
        if (aggregation is List)
          for (final c in aggregation.whereType<Map<String, dynamic>>())
            EvConnector(
              type: c['type'] as String? ?? 'EV_CONNECTOR_TYPE_OTHER',
              maxChargeRateKw: (c['maxChargeRateKw'] as num?)?.toDouble(),
              count: (c['count'] as num?)?.toInt(),
              availableCount: (c['availableCount'] as num?)?.toInt(),
              outOfServiceCount: (c['outOfServiceCount'] as num?)?.toInt(),
              availabilityUpdatedAt:
                  DateTime.tryParse(c['availabilityLastUpdateTime'] as String? ?? ''),
            ),
      ],
    );
  }

  /// Parses a google.type.Money `{currencyCode, units: "3", nanos: 990000000}`.
  static ({double amount, String currency})? parseMoney(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final currency = raw['currencyCode'] as String?;
    final unitsRaw = raw['units'];
    final units = unitsRaw is num ? unitsRaw.toInt() : int.tryParse('${unitsRaw ?? 0}');
    final nanos = (raw['nanos'] as num?)?.toInt() ?? 0;
    if (currency == null || units == null) return null;
    if (unitsRaw == null && nanos == 0) return null;
    return (amount: units + nanos / 1e9, currency: currency);
  }
}
