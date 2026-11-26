import '../../../core/error/result.dart';

/// What the server removed (counts only; never user content).
class CommunityDeletionSummary {
  const CommunityDeletionSummary({
    this.priceReports = 0,
    this.votes = 0,
    this.alertRules = 0,
    this.assistantSessions = 0,
  });

  factory CommunityDeletionSummary.fromMap(Map<Object?, Object?> m) {
    int n(String k) => (m[k] as num?)?.toInt() ?? 0;
    return CommunityDeletionSummary(
      priceReports: n('priceReports'),
      votes: n('votes'),
      alertRules: n('alertRules'),
      assistantSessions: n('assistantSessions'),
    );
  }

  static const none = CommunityDeletionSummary();

  final int priceReports, votes, alertRules, assistantSessions;

  int get total => priceReports + votes + alertRules + assistantSessions;
}

/// The user's online (community) data, linked to an anonymous account.
abstract interface class CommunityAccount {
  /// False when community features are not configured in this build.
  bool get isAvailable;

  /// Deletes the caller's online data and anonymous account, then signs out.
  /// A device that never signed in has nothing online: returns [CommunityDeletionSummary.none].
  Future<Result<CommunityDeletionSummary>> deleteMyData();
}

/// Everything the app stores on the device.
abstract interface class LocalDataStore {
  Future<Result<void>> wipe();
}
