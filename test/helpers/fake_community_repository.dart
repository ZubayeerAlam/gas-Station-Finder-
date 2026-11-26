import 'dart:async';

import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/prices/domain/community_models.dart';
import 'package:gas_station_finder/features/prices/domain/community_repository.dart';

/// In-memory [CommunityRepository] for widget tests. Data is set by the test;
/// writes are recorded. [verdict] simulates the server's report processing.
class FakeCommunityRepository implements CommunityRepository {
  FakeCommunityRepository({
    Map<String, List<CommunityPrice>> prices = const {},
    Map<String, StationReliability> reliability = const {},
    List<PriceHistoryDay> history = const [],
    this.verdict = const (status: 'accepted', reason: null),
    this.failWrites,
  })  : prices = {...prices},
        reliability = {...reliability},
        history = [...history];

  final Map<String, List<CommunityPrice>> prices;
  final Map<String, StationReliability> reliability;
  final List<PriceHistoryDay> history;
  final ReportStatus verdict;

  /// When set, every write fails with this.
  AppFailure? failWrites;

  final reports = <PriceReportDraft>[];
  final votes = <String, StationVote>{};
  final flags = <String, Set<String>>{};
  final rules = <PriceAlertRule>[];
  final historyRequests = <({String stationId, String fuelType, int days})>[];
  var _ids = 0;
  final _changes = StreamController<void>.broadcast();

  Stream<T> _watch<T>(T Function() read) => Stream.multi((c) {
        c.add(read());
        final sub = _changes.stream.listen((_) => c.add(read()));
        c.onCancel = sub.cancel;
      });

  Future<Result<T>> _write<T>(T Function() body) async {
    if (failWrites case final f?) return Err(f);
    final v = body();
    _changes.add(null);
    return Ok(v);
  }

  @override
  bool get isAvailable => true;

  @override
  Stream<List<CommunityPrice>> watchPrices(String stationId) => _watch(() => prices[stationId] ?? const []);

  @override
  Stream<List<PriceHistoryDay>> watchHistory(String stationId, String fuelType, {int days = 30}) {
    historyRequests.add((stationId: stationId, fuelType: fuelType, days: days));
    return _watch(() => [for (final h in history) if (h.fuelType == fuelType) h]);
  }

  @override
  Stream<StationReliability?> watchReliability(String stationId) => _watch(() => reliability[stationId]);

  @override
  Future<Result<String>> submitReport(PriceReportDraft draft) => _write(() {
        reports.add(draft);
        return 'r${reports.length}';
      });

  @override
  Stream<ReportStatus> watchReportStatus(String reportId) => Stream.value(verdict);

  @override
  Stream<StationVote?> watchMyVote(String stationId) => _watch(() => votes[stationId]);

  @override
  Future<Result<void>> vote(String stationId, StationVote vote) => _write(() => votes[stationId] = vote);

  @override
  Stream<Set<String>> watchMyFlags(String stationId) => _watch(() => {...?flags[stationId]});

  @override
  Future<Result<void>> flagPrice(String stationId, String fuelType) =>
      _write(() => (flags[stationId] ??= {}).add(fuelType));

  @override
  Future<Result<void>> unflagPrice(String stationId, String fuelType) =>
      _write(() => flags[stationId]?.remove(fuelType));

  @override
  Stream<List<PriceAlertRule>> watchAlertRules() => _watch(() => List.unmodifiable(rules));

  @override
  Future<Result<void>> saveAlertRule(PriceAlertRule rule) => _write(() {
        final i = rules.indexWhere((r) => r.id == rule.id);
        i >= 0 ? rules[i] = rule : rules.add(rule);
      });

  @override
  Future<Result<void>> deleteAlertRule(String id) => _write(() => rules.removeWhere((r) => r.id == id));

  @override
  String newId() => 'id${++_ids}';
}
