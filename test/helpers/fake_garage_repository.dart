import 'dart:async';

import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/garage/domain/garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';

/// In-memory [GarageRepository] for widget tests (mirrors the drift rules:
/// first vehicle becomes active, deleting the active one picks the next).
class FakeGarageRepository implements GarageRepository {
  FakeGarageRepository([List<VehicleProfile> initial = const []]) {
    for (final v in initial) {
      _upsert(v);
    }
  }

  final _vehicles = <VehicleProfile>[];
  String? activeId;
  final _changes = StreamController<void>.broadcast();

  List<VehicleProfile> get vehicles => List.unmodifiable(_vehicles);

  void _upsert(VehicleProfile v) {
    final i = _vehicles.indexWhere((e) => e.id == v.id);
    i >= 0 ? _vehicles[i] = v : _vehicles.add(v);
    activeId ??= v.id;
  }

  Stream<T> _watch<T>(T Function() read) => Stream.multi((c) {
        c.add(read());
        final sub = _changes.stream.listen((_) => c.add(read()));
        c.onCancel = sub.cancel;
      });

  @override
  Stream<List<VehicleProfile>> watchVehicles() => _watch(() => vehicles);

  @override
  Stream<String?> watchActiveVehicleId() => _watch(() => activeId);

  @override
  Future<Result<void>> save(VehicleProfile vehicle) async {
    _upsert(vehicle);
    _changes.add(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> delete(String vehicleId) async {
    _vehicles.removeWhere((v) => v.id == vehicleId);
    if (activeId == vehicleId) activeId = _vehicles.isEmpty ? null : _vehicles.first.id;
    _changes.add(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> setActiveVehicle(String? vehicleId) async {
    activeId = vehicleId;
    _changes.add(null);
    return const Ok(null);
  }
}
