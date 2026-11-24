import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure_mapper.dart';
import '../domain/charge_point.dart';
import '../domain/charge_points_repository.dart';

/// Open Charge Map API v3 (`GET /v3/poi`). Data is CC BY-SA 4.0 — the UI
/// shows attribution wherever it is displayed.
class OpenChargeMapRepository implements ChargePointsRepository {
  OpenChargeMapRepository(this.dio, {required this.hasApiKey});

  final Dio dio;
  final bool hasApiKey;

  static const _missingKey = ConfigFailure(
    'Open Charge Map API key is not configured. Add OCM_API_KEY to config/dev.json.',
  );

  @override
  Future<Result<List<ChargePoint>>> nearby(GeoPoint center, {double radiusKm = 10, int maxResults = 100}) async {
    if (!hasApiKey) return const Err(_missingKey);
    return guardResult(() async {
      final response = await dio.get<Object>(
        '/poi',
        queryParameters: {
          'output': 'json',
          'latitude': center.latitude,
          'longitude': center.longitude,
          'distance': radiusKm,
          'distanceunit': 'KM',
          'maxresults': maxResults,
          'compact': false, // include reference titles (connector/status names)
          'verbose': false, // drop null fields
        },
      );
      return parse(response.data);
    });
  }

  /// Tolerant parser: entries without an id or coordinates are skipped.
  static List<ChargePoint> parse(Object? json) {
    if (json is! List) throw const FormatException('OCM response is not a list');
    final out = <ChargePoint>[];
    final seen = <String>{};
    for (final raw in json) {
      if (raw is! Map) continue;
      final p = _point(raw);
      if (p != null && seen.add(p.id)) out.add(p);
    }
    return out;
  }

  static ChargePoint? _point(Map raw) {
    final id = raw['ID'];
    final addr = raw['AddressInfo'];
    if (id is! num || addr is! Map) return null;
    final lat = addr['Latitude'], lng = addr['Longitude'];
    if (lat is! num || lng is! num) return null;
    final status = raw['StatusType'];
    final address = [
      addr['AddressLine1'],
      addr['Town'],
      addr['Postcode'],
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(', ');
    return ChargePoint(
      id: 'ocm:${id.toInt()}',
      name: _str(addr['Title']) ?? 'Charging station',
      location: GeoPoint(latitude: lat.toDouble(), longitude: lng.toDouble()),
      address: address.isEmpty ? null : address,
      operatorName: _str((raw['OperatorInfo'] as Map?)?['Title']),
      numberOfPoints: (raw['NumberOfPoints'] as num?)?.toInt(),
      isOperational: status is Map ? status['IsOperational'] as bool? : null,
      statusLabel: status is Map ? _str(status['Title']) : null,
      usageCost: _str(raw['UsageCost']),
      lastVerified: _date(raw['DateLastVerified']),
      lastStatusUpdate: _date(raw['DateLastStatusUpdate']),
      connectors: [
        for (final c in raw['Connections'] as List? ?? const [])
          if (c is Map) _connector(c),
      ],
    );
  }

  static ChargeConnector _connector(Map c) {
    final type = c['ConnectionType'];
    final current = (c['CurrentType'] as Map?)?['Title'] as String?;
    final status = c['StatusType'];
    return ChargeConnector(
      type: _str(type is Map ? type['Title'] : null) ?? 'Connector ${c['ConnectionTypeID'] ?? '?'}',
      powerKw: (c['PowerKW'] as num?)?.toDouble(),
      quantity: (c['Quantity'] as num?)?.toInt(),
      isDc: current?.toUpperCase().startsWith('DC'),
      isOperational: status is Map ? status['IsOperational'] as bool? : null,
    );
  }

  static String? _str(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;
  static DateTime? _date(Object? v) => v is String ? DateTime.tryParse(v) : null;
}

final chargePointsRepositoryProvider = Provider<ChargePointsRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = buildDio(
    baseUrl: 'https://api.openchargemap.io/v3',
    headers: {if (config.hasOpenChargeMapKey) 'X-API-Key': config.openChargeMapApiKey},
  );
  ref.onDispose(dio.close);
  return OpenChargeMapRepository(dio, hasApiKey: config.hasOpenChargeMapKey);
});
