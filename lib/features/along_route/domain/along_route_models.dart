import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/location/geo_point.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../route/domain/route_info.dart';
import '../../stations/domain/entities/station.dart';

part 'along_route_models.freezed.dart';

/// One autocomplete suggestion (Places Autocomplete New).
@freezed
abstract class PlaceSuggestion with _$PlaceSuggestion {
  const factory PlaceSuggestion({required String placeId, required String primaryText, String? secondaryText}) =
      _PlaceSuggestion;
}

@freezed
abstract class Destination with _$Destination {
  const factory Destination({required String name, required GeoPoint location, String? placeId, String? address}) =
      _Destination;
}

/// Driving detour for stopping at a station on the way.
@freezed
abstract class StopDetour with _$StopDetour {
  const factory StopDetour({
    /// Driving distance/time origin → station.
    required double toStationMeters,
    double? toStationSeconds,

    /// (origin → station → destination) − (origin → destination), ≥ 0.
    required double detourMeters,
    double? detourSeconds,
  }) = _StopDetour;
}

/// A station found near the route, with what we know about stopping there.
@freezed
abstract class RouteStop with _$RouteStop {
  const factory RouteStop({
    required Station station,
    required double alongMeters,
    required double offRouteMeters,

    /// Null when the routing service could not compute it.
    StopDetour? detour,

    /// Price for the vehicle's fuel (from a real source) — null = unknown.
    FuelPrice? price,
    PriceSource? priceSource,
    bool? openNow,

    /// 0..1 community data-reliability score; null = unknown.
    double? reliability,
  }) = _RouteStop;
}

@freezed
abstract class AlongRoutePlan with _$AlongRoutePlan {
  const factory AlongRoutePlan({
    required GeoPoint origin,
    required Destination destination,
    required RouteInfo route,
    required List<RouteStop> stops,

    /// Places fuel code that prices refer to; null = none (EV or no vehicle fuel).
    String? fuelType,

    /// True when detours are straight-line estimates (routing table failed).
    @Default(false) bool detoursApproximate,

    /// Stations beyond the detour/price budget (listed, not priced/routed).
    @Default(0) int skippedForDetour,
  }) = _AlongRoutePlan;
}
