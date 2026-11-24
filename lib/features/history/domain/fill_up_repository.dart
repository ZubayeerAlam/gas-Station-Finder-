import '../../../core/error/result.dart';
import 'fill_up.dart';

abstract interface class FillUpRepository {
  /// Fill-ups of one vehicle, newest first.
  Stream<List<FillUp>> watchFillUps(String vehicleId);
  Future<Result<void>> save(FillUp fillUp);
  Future<Result<void>> delete(String fillUpId);
}
