import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../domain/care_reminder.dart';
import '../domain/care_schedule.dart';

String careTypeLabel(CareType t, AppLocalizations l) => switch (t) {
  CareType.taxToken => l.careTypeTaxToken,
  CareType.fitness => l.careTypeFitness,
  CareType.insurance => l.careTypeInsurance,
  CareType.routePermit => l.careTypeRoutePermit,
  CareType.cngRetest => l.careTypeCngRetest,
  CareType.oilChange => l.careTypeOilChange,
  CareType.tyreRotation => l.careTypeTyreRotation,
  CareType.custom => l.careTypeCustom,
};

/// The reminder's own name if set, else its type.
String careTitle(CareReminder r, AppLocalizations l) =>
    (r.title?.trim().isNotEmpty ?? false) ? r.title!.trim() : careTypeLabel(r.type, l);

IconData careTypeIcon(CareType t) => switch (t) {
  CareType.taxToken => Icons.receipt_long_rounded,
  CareType.fitness => Icons.verified_rounded,
  CareType.insurance => Icons.shield_rounded,
  CareType.routePermit => Icons.alt_route_rounded,
  CareType.cngRetest => Icons.propane_tank_rounded,
  CareType.oilChange => Icons.oil_barrel_rounded,
  CareType.tyreRotation => Icons.tire_repair_rounded,
  CareType.custom => Icons.build_rounded,
};

String careBandLabel(CareBand b, AppLocalizations l) => switch (b) {
  CareBand.overdue => l.careBandOverdue,
  CareBand.dueSoon => l.careBandDueSoon,
  CareBand.upcoming => l.careBandUpcoming,
  CareBand.needsSetup => l.careBandNeedsSetup,
  CareBand.done => l.careBandDone,
};

/// "7 Dec 2026" / "7 ডিসে 2026".
String careDate(DateTime d, AppLocalizations l) => '${d.day} ${monthShort(d.month, l)} ${d.year}';

String kmText(double km) => '${Fmt.number(km, maxDecimals: 0)} km';

/// One line saying where the reminder stands, e.g. "Due in 12 days · 7 Dec 2026 · In 800 km".
String careStatusText(CareReminder r, CareStatus s, AppLocalizations l) {
  switch (s.band) {
    case CareBand.needsSetup:
      return r.hasDue ? l.careNeedsOdometer : l.careNeedsSetup;
    case CareBand.done:
      return l.careDoneOn(careDate(r.lastDoneAt!, l));
    case CareBand.overdue:
      final days = s.daysLeft;
      if (days != null && days < 0) return l.careOverdueDays(-days);
      return l.careOverdueKm(kmText(-(s.kmLeft ?? 0)));
    case CareBand.dueSoon:
    case CareBand.upcoming:
      final parts = <String>[];
      final days = s.daysLeft;
      if (days != null) parts.add(days == 0 ? l.careDueToday : l.careDueInDays(days, careDate(r.dueDate!, l)));
      final km = s.kmLeft;
      if (km != null) {
        parts.add(
          l.careInKm(kmText(km)) +
              (s.dateEstimated && s.effectiveDueDate != null
                  ? l.careEstimatedDate(careDate(s.effectiveDueDate!, l))
                  : ''),
        );
      }
      return parts.join(' · ');
  }
}
