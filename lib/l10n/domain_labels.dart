import '../features/prices/domain/community_models.dart';
import '../features/stations/domain/entities/station.dart';
import 'app_localizations.dart';

/// Translated labels for domain codes. The domain layer keeps English
/// (used in logs and for the AI tool results); the UI goes through these.
/// Codes without a translation (E10, LPG, CCS2, …) are the same in every
/// language and fall back to the domain label.
String localizedFuelType(String code, AppLocalizations l) => switch (code) {
      'DIESEL' => l.fuelDiesel,
      'DIESEL_PLUS' => l.fuelDieselPlus,
      'TRUCK_DIESEL' => l.fuelTruckDiesel,
      'BIO_DIESEL' => l.fuelBioDiesel,
      'REGULAR_UNLEADED' => l.fuelRegular,
      'MIDGRADE' => l.fuelMidgrade,
      'PREMIUM' => l.fuelPremium,
      'METHANE' => l.fuelMethane,
      'EV_KWH' => l.fuelEvCharging,
      _ => fuelTypeLabel(code),
    };

String localizedConnector(String code, AppLocalizations l) => switch (code) {
      'EV_CONNECTOR_TYPE_UNSPECIFIED_WALL_OUTLET' => l.connectorWallOutlet,
      'EV_CONNECTOR_TYPE_OTHER' => l.connectorOther,
      _ => evConnectorLabel(code),
    };

/// Mirrors `reliabilityLabel` in the prices domain (same thresholds).
String localizedReliability(double? score, AppLocalizations l) => switch (score) {
      null => l.reliabilityNone,
      >= 0.75 => l.reliabilityHigh,
      >= 0.5 => l.reliabilityMedium,
      _ => l.reliabilityLow,
    };

/// Mirrors `reportStatusMessage` in the prices domain.
String localizedReportStatus(String? status, String? reason, AppLocalizations l) => switch ((status, reason)) {
      ('accepted', _) => l.reportAccepted,
      ('pending', 'minority_currency') => l.reportMinorityCurrency,
      ('rejected', 'outlier') => l.reportOutlier,
      ('rejected', 'duplicate_report') => l.reportDuplicate,
      ('rejected', 'too_many_reports') => l.reportTooMany,
      ('rejected', _) => l.reportRejected,
      _ => l.reportSent,
    };

/// Same rule as `validateReportPrice` (the security rules still decide).
String? validateReportPriceL10n(String? text, AppLocalizations l) {
  final v = double.tryParse((text ?? '').trim().replaceAll(',', '.'));
  if (v == null || !v.isFinite) return l.enterPrice;
  if (v < kMinReportPrice || v > kMaxReportPrice) return l.enterPriceRange;
  return null;
}
