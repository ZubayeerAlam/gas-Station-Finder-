import 'dart:math' as math;

import '../../garage/domain/vehicle_profile.dart';
import 'care_reminder.dart';

/// Urgency band, most urgent first.
enum CareBand { overdue, dueSoon, upcoming, needsSetup, done }

/// A reminder is "due soon" this many km before its due odometer.
const kCareSoonKm = 500.0;

/// Where a reminder stands right now. Everything is computed, nothing stored.
class CareStatus {
  const CareStatus({
    required this.band,
    this.daysLeft,
    this.kmLeft,
    this.effectiveDueDate,
    this.dateEstimated = false,
    this.progress,
  });

  final CareBand band;

  /// Days until [CareReminder.dueDate] (negative = overdue, 0 = today).
  final int? daysLeft;

  /// Km until [CareReminder.dueOdometerKm] (≤ 0 = reached); null without an odometer reading.
  final double? kmLeft;

  /// The earlier of the real due date and the date estimated from km/day.
  final DateTime? effectiveDueDate;

  /// True when [effectiveDueDate] is an estimate from driving history.
  final bool dateEstimated;

  /// 0…1 share of the interval already used, when it can be computed.
  final double? progress;

  /// [odometerKm] = latest reading from history; [kmPerDay] = average driving.
  static CareStatus of(CareReminder r, {required DateTime now, double? odometerKm, double? kmPerDay}) {
    if (!r.hasDue) {
      return CareStatus(band: r.lastDoneAt != null && !r.repeats ? CareBand.done : CareBand.needsSetup);
    }
    final today = dateOnly(now);
    final daysLeft = r.dueDate == null ? null : daysBetween(today, dateOnly(r.dueDate!));

    double? kmLeft;
    int? estDays;
    if (r.dueOdometerKm != null && odometerKm != null) {
      kmLeft = r.dueOdometerKm! - odometerKm;
      if (kmPerDay != null && kmPerDay > 0) estDays = math.max(0, (kmLeft / kmPerDay).floor());
    }

    // Effective due date = whichever comes first.
    DateTime? due = r.dueDate == null ? null : dateOnly(r.dueDate!);
    var estimated = false;
    if (estDays != null) {
      final est = today.add(Duration(days: estDays));
      if (due == null || est.isBefore(due)) {
        due = est;
        estimated = true;
      }
    }

    final CareBand band;
    if ((daysLeft != null && daysLeft < 0) || (kmLeft != null && kmLeft <= 0)) {
      band = CareBand.overdue;
    } else if ((daysLeft != null && daysLeft <= r.notifyDaysBefore) ||
        (kmLeft != null && kmLeft <= kCareSoonKm) ||
        (estDays != null && estDays <= r.notifyDaysBefore)) {
      band = CareBand.dueSoon;
    } else if (daysLeft == null && kmLeft == null) {
      band = CareBand.needsSetup; // km-based but no odometer reading yet
    } else {
      band = CareBand.upcoming;
    }

    return CareStatus(
      band: band,
      daysLeft: daysLeft,
      kmLeft: kmLeft,
      effectiveDueDate: due,
      dateEstimated: estimated,
      progress: _progress(r, today, odometerKm),
    );
  }

  static double? _progress(CareReminder r, DateTime today, double? odometerKm) {
    final parts = <double>[];
    if (r.dueDate != null) {
      final start = dateOnly(r.lastDoneAt ?? r.createdAt);
      final total = daysBetween(start, dateOnly(r.dueDate!));
      if (total > 0) parts.add(daysBetween(start, today) / total);
    }
    if (r.dueOdometerKm != null && odometerKm != null) {
      final start = r.lastDoneKm ?? (r.repeatKm == null ? null : r.dueOdometerKm! - r.repeatKm!);
      if (start != null && r.dueOdometerKm! > start) parts.add((odometerKm - start) / (r.dueOdometerKm! - start));
    }
    if (parts.isEmpty) return null;
    return parts.reduce(math.max).clamp(0.0, 1.0);
  }
}

/// Most urgent first: band, then the effective due date, then km left.
List<(CareReminder, CareStatus)> sortByUrgency(List<(CareReminder, CareStatus)> items) {
  int cmp((CareReminder, CareStatus) a, (CareReminder, CareStatus) b) {
    final band = a.$2.band.index.compareTo(b.$2.band.index);
    if (band != 0) return band;
    final da = a.$2.effectiveDueDate, db = b.$2.effectiveDueDate;
    if (da != null && db != null && da != db) return da.compareTo(db);
    if (da != null && db == null) return -1;
    if (da == null && db != null) return 1;
    final ka = a.$2.kmLeft, kb = b.$2.kmLeft;
    if (ka != null && kb != null) return ka.compareTo(kb);
    return a.$1.createdAt.compareTo(b.$1.createdAt);
  }

  return [...items]..sort(cmp);
}

/// Records the service/renewal and rolls a repeating reminder forward.
/// A one-off reminder keeps its history and becomes [CareBand.done].
CareReminder markDone(CareReminder r, {required DateTime doneAt, double? doneKm}) {
  final nextDate = r.repeatMonths == null ? null : addMonths(dateOnly(doneAt), r.repeatMonths!);
  final nextKm = r.repeatKm == null || doneKm == null ? null : doneKm + r.repeatKm!;
  return r.copyWith(
    lastDoneAt: doneAt,
    lastDoneKm: doneKm ?? r.lastDoneKm,
    dueDate: nextDate,
    dueOdometerKm: nextKm,
  );
}

/// Preset intervals. Starting points only — the user checks their documents.
class CarePreset {
  const CarePreset(this.type, {this.repeatMonths, this.repeatKm, this.usesDate = true, this.usesKm = false});

  final CareType type;
  final int? repeatMonths;
  final double? repeatKm;
  final bool usesDate;
  final bool usesKm;
}

const kCarePresets = <CareType, CarePreset>{
  CareType.taxToken: CarePreset(CareType.taxToken, repeatMonths: 12),
  CareType.insurance: CarePreset(CareType.insurance, repeatMonths: 12),
  CareType.fitness: CarePreset(CareType.fitness),
  CareType.routePermit: CarePreset(CareType.routePermit),
  CareType.cngRetest: CarePreset(CareType.cngRetest, repeatMonths: 60),
  CareType.oilChange: CarePreset(CareType.oilChange, repeatMonths: 6, repeatKm: 5000, usesKm: true),
  CareType.tyreRotation: CarePreset(CareType.tyreRotation, repeatKm: 10000, usesDate: false, usesKm: true),
  CareType.custom: CarePreset(CareType.custom, usesKm: true),
};

/// Which reminders to suggest for [v]: documents for everyone, oil changes
/// only for combustion engines, the CNG cylinder retest only for CNG
/// (Places fuel code `METHANE`).
List<CareType> suggestedCareTypes(VehicleProfile v) => [
      CareType.taxToken,
      CareType.insurance,
      CareType.fitness,
      if (v.preferredFuelType == 'METHANE') CareType.cngRetest,
      if (!v.isElectric) CareType.oilChange,
      CareType.tyreRotation,
    ];

/// New, not-yet-set-up reminder from a preset (the user enters the due date / km).
CareReminder reminderFromPreset(CareType type,
        {required String id, required String vehicleId, required DateTime now}) =>
    CareReminder(
      id: id,
      vehicleId: vehicleId,
      type: type,
      repeatMonths: kCarePresets[type]?.repeatMonths,
      repeatKm: kCarePresets[type]?.repeatKm,
      createdAt: now,
    );

enum CareNoticeKind { before, onDay }

/// A local notification to schedule.
class CareNotice {
  const CareNotice({required this.reminderId, required this.when, required this.kind, this.estimated = false});

  final String reminderId;
  final DateTime when;
  final CareNoticeKind kind;
  final bool estimated;

  @override
  bool operator ==(Object other) =>
      other is CareNotice && other.reminderId == reminderId && other.when == when && other.kind == kind;

  @override
  int get hashCode => Object.hash(reminderId, when, kind);
}

/// Notices for one reminder at [hour]:00 local time; past times are dropped.
List<CareNotice> careNotices(CareReminder r, CareStatus s, {required DateTime now, int hour = 9}) {
  final due = s.effectiveDueDate;
  if (due == null || s.band == CareBand.overdue || s.band == CareBand.done) return const [];
  DateTime at(DateTime d) => DateTime(d.year, d.month, d.day, hour);
  return [
    if (r.notifyDaysBefore > 0)
      CareNotice(
        reminderId: r.id,
        when: at(due.subtract(Duration(days: r.notifyDaysBefore))),
        kind: CareNoticeKind.before,
        estimated: s.dateEstimated,
      ),
    CareNotice(reminderId: r.id, when: at(due), kind: CareNoticeKind.onDay, estimated: s.dateEstimated),
  ].where((n) => n.when.isAfter(now)).toList();
}

// ---- date helpers (calendar days, immune to DST) ----
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

int daysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// 31 Jan + 1 month = 28/29 Feb (clamped, never overflows into March).
DateTime addMonths(DateTime d, int months) {
  final total = d.month - 1 + months;
  final y = d.year + total ~/ 12, m = total % 12 + 1;
  final last = DateTime(y, m + 1, 0).day;
  return DateTime(y, m, math.min(d.day, last), d.hour, d.minute);
}
