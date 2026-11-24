import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/location/geo_point.dart';

part 'community_models.freezed.dart';

/// Fuel codes accepted by the backend (must match `firestore.rules` and
/// `functions/src/pricing.ts`). `EV_KWH` = price per kWh at a charger.
const kCommunityFuelTypes = [
  'REGULAR_UNLEADED', 'MIDGRADE', 'PREMIUM', 'DIESEL', 'DIESEL_PLUS', 'LPG', 'METHANE', 'E85', 'E10', 'EV_KWH', //
];

/// Same bounds as the security rules (per unit, generous for weak currencies).
const kMinReportPrice = 0.01;
const kMaxReportPrice = 1000.0;

/// Consensus price for one station + fuel, computed server-side from recent,
/// trust- and recency-weighted reports. Never written by clients.
@freezed
abstract class CommunityPrice with _$CommunityPrice {
  const CommunityPrice._();

  const factory CommunityPrice({
    required String fuelType,
    required double price,
    required String currencyCode,
    required int reportCount,

    /// 0..1 — agreement and number of reports behind the consensus.
    required double confidence,
    required DateTime lastReportAt,

    /// After this the price is stale and must not be used for ranking.
    required DateTime expiresAt,
  }) = _CommunityPrice;

  bool isFresh(DateTime now) => now.isBefore(expiresAt);
}

/// One UTC day of consensus prices.
@freezed
abstract class PriceHistoryDay with _$PriceHistoryDay {
  const factory PriceHistoryDay({
    required DateTime day,
    required String fuelType,
    required String currencyCode,
    required double close,
    required double min,
    required double max,
    required int samples,
  }) = _PriceHistoryDay;
}

/// Community signal about a station. [score] is null when nothing is known —
/// it is a data-quality indicator, not a certification of the station.
@freezed
abstract class StationReliability with _$StationReliability {
  const StationReliability._();

  const factory StationReliability({
    double? score,
    @Default(0) int openVotes,
    @Default(0) int closedVotes,
    @Default(0) int outOfStockVotes,
  }) = _StationReliability;

  int get totalOpenClosedVotes => openVotes + closedVotes;
}

/// What the user submits. The server stamps time + uid and decides acceptance.
@freezed
abstract class PriceReportDraft with _$PriceReportDraft {
  const factory PriceReportDraft({
    required String stationId,
    String? stationName,
    required GeoPoint stationLocation,
    required String fuelType,
    required double price,
    required String currencyCode,
  }) = _PriceReportDraft;
}

/// The signed-in user's own vote for a station.
@freezed
abstract class StationVote with _$StationVote {
  const factory StationVote({bool? open, bool? fuelAvailable}) = _StationVote;
}

@freezed
abstract class PriceAlertRule with _$PriceAlertRule {
  const factory PriceAlertRule({
    required String id,
    required String fuelType,
    required String currencyCode,
    required double maxPrice,
    required GeoPoint center,
    required double radiusKm,
    @Default(true) bool enabled,

    /// Optional: only this station.
    String? stationId,
    String? stationName,
  }) = _PriceAlertRule;
}

/// Client-side validation mirroring the security rules (the rules still decide).
String? validateReportPrice(String? text) {
  final v = double.tryParse((text ?? '').trim().replaceAll(',', '.'));
  if (v == null || !v.isFinite) return 'Enter a price';
  if (v < kMinReportPrice || v > kMaxReportPrice) return 'Enter a price between 0.01 and 1000';
  return null;
}

/// Plain-language reliability band. Deliberately cautious wording.
String reliabilityLabel(double? score) => switch (score) {
      null => 'Not enough community data',
      >= 0.75 => 'Recently confirmed by the community',
      >= 0.5 => 'Some community reports',
      _ => 'Community reports are old or disagree',
    };

/// Why the server rejected / held a report, in user terms.
String reportStatusMessage(String? status, String? reason) => switch ((status, reason)) {
      ('accepted', _) => 'Thanks! Your price is now part of the community price.',
      ('pending', 'minority_currency') => 'Saved, but most reports here use another currency.',
      ('rejected', 'outlier') => 'This price is far from other recent reports, so it was not used.',
      ('rejected', 'duplicate_report') => 'You already reported this fuel here a few minutes ago.',
      ('rejected', 'too_many_reports') => 'Too many reports in the last hour. Please try later.',
      ('rejected', _) => 'This report was not accepted.',
      _ => 'Report sent. It will be checked in a moment.',
    };
