import '../../../core/error/result.dart';
import 'care_reminder.dart';

abstract interface class CareRepository {
  /// Reminders of one vehicle, oldest first.
  Stream<List<CareReminder>> watchReminders(String vehicleId);

  /// Every reminder (for notifications and badges).
  Stream<List<CareReminder>> watchAll();

  /// Insert or update.
  Future<Result<void>> save(CareReminder reminder);
  Future<Result<void>> delete(String reminderId);
}
