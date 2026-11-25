/// One local notification, ready to schedule (text already localized).
class ScheduledCareNotice {
  const ScheduledCareNotice({required this.id, required this.when, required this.title, required this.body});

  /// Stable slot in [kCareNoticeBaseId] … + [kMaxCareNotices].
  final int id;
  final DateTime when;
  final String title;
  final String body;

  @override
  bool operator ==(Object other) =>
      other is ScheduledCareNotice &&
      other.id == id &&
      other.when == when &&
      other.title == title &&
      other.body == body;

  @override
  int get hashCode => Object.hash(id, when, title, body);

  @override
  String toString() => 'ScheduledCareNotice($id, $when, $title, $body)';
}

/// Notification ids reserved for care reminders (other features never use them).
const kCareNoticeBaseId = 7000;

/// iOS keeps at most 64 pending notifications per app; stay well below.
const kMaxCareNotices = 50;

/// Schedules care reminders on the device. No server, no push service.
abstract interface class ReminderNotifier {
  /// Asks the OS for permission (iOS, Android 13+). `false` = denied or unavailable.
  Future<bool> requestPermission();

  /// Replaces every scheduled care notice with [notices]. Returns how many were scheduled.
  Future<int> sync(List<ScheduledCareNotice> notices);
}
