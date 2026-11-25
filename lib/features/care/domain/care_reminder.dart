import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_reminder.freezed.dart';

/// What a reminder is about. Documents are date-based; service items are
/// usually km-based (or both, whichever comes first).
enum CareType { taxToken, fitness, insurance, routePermit, cngRetest, oilChange, tyreRotation, custom }

/// A vehicle-care reminder: a document expiry or a service interval.
///
/// Due by [dueDate], by [dueOdometerKm], or both (whichever comes first).
/// Neither set = not set up yet (the user still has to enter a date/km).
@freezed
abstract class CareReminder with _$CareReminder {
  @Assert('notifyDaysBefore >= 0', 'notifyDaysBefore must not be negative')
  const factory CareReminder({
    required String id,
    required String vehicleId,
    required CareType type,

    /// User's own name; required for [CareType.custom], optional otherwise.
    String? title,
    DateTime? dueDate,
    double? dueOdometerKm,

    /// Repeat after "Mark done" (null = one-off).
    int? repeatMonths,
    double? repeatKm,
    DateTime? lastDoneAt,
    double? lastDoneKm,
    @Default(7) int notifyDaysBefore,
    String? note,
    required DateTime createdAt,
  }) = _CareReminder;

  const CareReminder._();

  bool get repeats => repeatMonths != null || repeatKm != null;
  bool get hasDue => dueDate != null || dueOdometerKm != null;
}
