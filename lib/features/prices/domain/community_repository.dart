import '../../../core/error/result.dart';
import 'community_models.dart';

/// Server verdict on one report (null fields = still being processed).
typedef ReportStatus = ({String? status, String? reason});

/// Crowdsourced prices, history, reliability, votes and alert rules.
///
/// Implementations: Firestore (emulator or a configured project) and an
/// "unavailable" one when Firebase is not configured. All aggregates are
/// computed by Cloud Functions; the client only writes reports, its own vote
/// and its own alert rules.
abstract interface class CommunityRepository {
  /// Whether the backend is configured at all (false = show setup hint).
  bool get isAvailable;

  Stream<List<CommunityPrice>> watchPrices(String stationId);

  /// Daily consensus history, oldest first, for the last [days] days.
  Stream<List<PriceHistoryDay>> watchHistory(String stationId, String fuelType, {int days = 30});

  Stream<StationReliability?> watchReliability(String stationId);

  /// Creates a report; returns its id.
  Future<Result<String>> submitReport(PriceReportDraft draft);

  Stream<ReportStatus> watchReportStatus(String reportId);

  Stream<StationVote?> watchMyVote(String stationId);

  Future<Result<void>> vote(String stationId, StationVote vote);

  Stream<List<PriceAlertRule>> watchAlertRules();

  Future<Result<void>> saveAlertRule(PriceAlertRule rule);

  Future<Result<void>> deleteAlertRule(String id);

  String newId();
}
