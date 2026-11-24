import '../../../core/error/result.dart';
import 'vehicle_profile.dart';

abstract interface class GarageRepository {
  /// All vehicles, oldest first.
  Stream<List<VehicleProfile>> watchVehicles();

  /// Insert or update.
  Future<Result<void>> save(VehicleProfile vehicle);

  /// Deletes the vehicle; clears the active selection if it was active.
  Future<Result<void>> delete(String vehicleId);

  Stream<String?> watchActiveVehicleId();
  Future<Result<void>> setActiveVehicle(String? vehicleId);
}
