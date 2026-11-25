import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/community_models.dart';
import '../domain/community_repository.dart';

/// Used when Firebase is not configured: reads are empty, writes fail with a
/// [ConfigFailure]. Nothing is faked.
class UnavailableCommunityRepository implements CommunityRepository {
  const UnavailableCommunityRepository([this.reason = 'Community features are not set up yet.']);

  final String reason;

  @override
  bool get isAvailable => false;

  Err<T> _err<T>() => Err<T>(ConfigFailure(reason, code: FailureCode.communityUnavailable));

  @override
  Stream<List<CommunityPrice>> watchPrices(String stationId) => Stream.value(const []);
  @override
  Stream<List<PriceHistoryDay>> watchHistory(String stationId, String fuelType, {int days = 30}) =>
      Stream.value(const []);
  @override
  Stream<StationReliability?> watchReliability(String stationId) => Stream.value(null);
  @override
  Future<Result<String>> submitReport(PriceReportDraft draft) async => _err();
  @override
  Stream<ReportStatus> watchReportStatus(String reportId) => const Stream.empty();
  @override
  Stream<StationVote?> watchMyVote(String stationId) => Stream.value(null);
  @override
  Future<Result<void>> vote(String stationId, StationVote vote) async => _err();
  @override
  Stream<List<PriceAlertRule>> watchAlertRules() => Stream.value(const []);
  @override
  Future<Result<void>> saveAlertRule(PriceAlertRule rule) async => _err();
  @override
  Future<Result<void>> deleteAlertRule(String id) async => _err();
  @override
  String newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}
