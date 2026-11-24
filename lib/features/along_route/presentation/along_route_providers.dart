import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_controller.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../ranking/domain/trip_cost_engine.dart';
import '../../route/data/osrm_route_repository.dart';
import '../data/places_place_search_repository.dart';
import '../../prices/data/community_quote_lookup.dart';
import '../domain/along_route_models.dart';
import '../domain/along_route_planner.dart';

final alongRoutePlannerProvider = Provider<AlongRoutePlanner>(
  (ref) => AlongRoutePlanner(
    routes: ref.watch(routeRepositoryProvider),
    detours: ref.watch(detourRepositoryProvider),
    places: ref.watch(placeSearchRepositoryProvider),
    quotes: ref.watch(stationQuoteLookupProvider),
  ),
);

/// What to search/price for a vehicle (or the default when there is none).
({String includedType, String? fuelType}) searchTargetFor(VehicleProfile? v) => v != null && v.isElectric
    ? (includedType: 'electric_vehicle_charging_station', fuelType: null)
    : (includedType: 'gas_station', fuelType: v?.preferredFuelType ?? 'REGULAR_UNLEADED');

/// The current trip plan (null until a destination is chosen).
class AlongRouteController extends AsyncNotifier<AlongRoutePlan?> {
  @override
  FutureOr<AlongRoutePlan?> build() => null;

  Future<void> plan(Destination destination) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final origin = await ref.read(locationControllerProvider.future);
      final target = searchTargetFor(ref.read(activeVehicleProvider).value);
      final result = await ref
          .read(alongRoutePlannerProvider)
          .plan(origin: origin, destination: destination, fuelType: target.fuelType, includedType: target.includedType);
      return result.getOrThrow();
    });
  }

  void clear() => state = const AsyncData(null);
}

final alongRouteControllerProvider = AsyncNotifierProvider<AlongRouteController, AlongRoutePlan?>(
  AlongRouteController.new,
);

class RankingStrategyNotifier extends Notifier<RankingStrategy> {
  @override
  RankingStrategy build() => RankingStrategy.cheapestTotal;
  void set(RankingStrategy s) => state = s;
}

final rankingStrategyProvider = NotifierProvider<RankingStrategyNotifier, RankingStrategy>(RankingStrategyNotifier.new);

/// Current tank / battery level (0..1) used for purchase size + reachability.
class FillLevelNotifier extends Notifier<double> {
  @override
  double build() => 0.25;
  void set(double v) => state = v.clamp(0.0, 1.0);
}

final fillLevelProvider = NotifierProvider<FillLevelNotifier, double>(FillLevelNotifier.new);

/// Injectable clock (tests).
final nowProvider = Provider<DateTime Function()>((_) => DateTime.now);

/// Turns plan stops into engine offers. Pure — exposed for tests.
List<StationOffer> offersFromPlan(AlongRoutePlan plan) => [
  for (final s in plan.stops)
    StationOffer(
      stationId: s.station.id,
      name: s.station.name,
      detourMeters: s.detour!.detourMeters,
      detourSeconds: s.detour!.detourSeconds,
      distanceToStationMeters: s.detour!.toStationMeters,
      pricePerUnit: s.price?.amount,
      currencyCode: s.price?.currencyCode,
      priceSource: s.price == null ? null : (s.priceSource ?? PriceSource.google),
      priceUpdatedAt: s.price?.updatedAt,
      openNow: s.openNow,
      reliability: s.reliability,
    ),
];

/// Ranking recomputed locally when strategy / fill level / vehicle change —
/// no network calls.
final alongRouteRankingProvider = Provider<RankingResult?>((ref) {
  final plan = ref.watch(alongRouteControllerProvider).value;
  if (plan == null) return null;
  final vehicle = ref.watch(activeVehicleProvider).value;
  return const TripCostEngine().rank(
    offers: offersFromPlan(plan),
    vehicle: vehicle,
    fill: vehicle == null ? null : FillToLevel(currentLevel: ref.watch(fillLevelProvider)),
    strategy: ref.watch(rankingStrategyProvider),
    now: ref.watch(nowProvider)(),
  );
});

/// False in widget tests (GoogleMap is a platform view).
final mapsEnabledProvider = Provider<bool>((_) => true);
