import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_controller.dart';
import '../../along_route/presentation/along_route_providers.dart';
import '../../garage/presentation/garage_providers.dart';
import '../data/open_charge_map_repository.dart';
import '../domain/charge_point.dart';
import '../domain/route_chargers.dart';

enum MapMode { fuel, ev }

/// Fuel or EV map. Defaults to the active vehicle's energy type; the user can
/// switch at any time (a vehicle change resets it to the vehicle's type).
class MapModeNotifier extends Notifier<MapMode> {
  @override
  MapMode build() => ref.watch(activeVehicleProvider).value?.isElectric == true ? MapMode.ev : MapMode.fuel;

  void set(MapMode mode) => state = mode;
}

final mapModeProvider = NotifierProvider<MapModeNotifier, MapMode>(MapModeNotifier.new);

/// Charge points around the current location (Open Charge Map).
final nearbyChargePointsProvider = FutureProvider<List<ChargePoint>>((ref) async {
  final center = await ref.watch(locationControllerProvider.future);
  final result = await ref.watch(chargePointsRepositoryProvider).nearby(center);
  return result.getOrThrow();
});

class EvFilterNotifier extends Notifier<EvFilter> {
  @override
  EvFilter build() => const EvFilter();

  void set(EvFilter f) => state = f;
  void reset() => state = const EvFilter();
}

final evFilterProvider = NotifierProvider<EvFilterNotifier, EvFilter>(EvFilterNotifier.new);

/// Filtered charge points; loading/error pass through unchanged.
final filteredChargePointsProvider = Provider<AsyncValue<List<ChargePoint>>>((ref) {
  final filter = ref.watch(evFilterProvider);
  return ref.watch(nearbyChargePointsProvider).whenData(filter.apply);
});

/// Chargers within 5 km of the planned along-route trip, for an electric
/// active vehicle only (null otherwise: no requests are made).
final routeChargersProvider = FutureProvider.autoDispose<RouteChargersResult?>((ref) async {
  final vehicle = ref.watch(activeVehicleProvider).value;
  if (vehicle == null || !vehicle.isElectric) return null;
  final plan = ref.watch(alongRouteControllerProvider).value;
  if (plan == null || plan.route.points.isEmpty) return null;
  final result = await RouteChargerFinder(ref.watch(chargePointsRepositoryProvider)).find(plan.route.points);
  return result.getOrThrow();
});
