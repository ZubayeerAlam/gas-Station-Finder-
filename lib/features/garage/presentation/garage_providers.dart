import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../data/drift_garage_repository.dart';
import '../domain/vehicle_profile.dart';

final vehiclesProvider = StreamProvider<List<VehicleProfile>>(
  (ref) => ref.watch(garageRepositoryProvider).watchVehicles(),
);

final activeVehicleIdProvider = StreamProvider<String?>(
  (ref) => ref.watch(garageRepositoryProvider).watchActiveVehicleId(),
);

/// The active vehicle, or null when the garage is empty / none selected.
final activeVehicleProvider = Provider<AsyncValue<VehicleProfile?>>((ref) {
  final vehicles = ref.watch(vehiclesProvider);
  final activeId = ref.watch(activeVehicleIdProvider);
  if (vehicles is AsyncError) return AsyncError(vehicles.error!, vehicles.stackTrace!);
  if (activeId is AsyncError) return AsyncError(activeId.error!, activeId.stackTrace!);
  final list = vehicles.value, id = activeId.value;
  if (list == null || !activeId.hasValue) return const AsyncLoading();
  for (final v in list) {
    if (v.id == id) return AsyncData(v);
  }
  return const AsyncData(null);
});

/// Write operations (MVVM view-model for the garage screens).
class GarageController {
  GarageController(this._ref);

  final Ref _ref;
  final _random = Random();

  String newId() => 'veh_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 20)}';

  Future<Result<void>> save(VehicleProfile v) => _ref.read(garageRepositoryProvider).save(v);
  Future<Result<void>> delete(String id) => _ref.read(garageRepositoryProvider).delete(id);
  Future<Result<void>> setActive(String? id) => _ref.read(garageRepositoryProvider).setActiveVehicle(id);
}

final garageControllerProvider = Provider<GarageController>(GarageController.new);
