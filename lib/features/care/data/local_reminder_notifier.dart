import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../l10n/l10n.dart';
import '../domain/reminder_notifier.dart';

/// [ReminderNotifier] backed by flutter_local_notifications.
///
/// Never throws: on a platform without the plugin (tests, desktop) or on any
/// plugin error it does nothing — the in-app status stays the source of truth.
class LocalReminderNotifier implements ReminderNotifier {
  LocalReminderNotifier({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<bool>? _ready;
  Future<int> _queue = Future.value(0);
  List<ScheduledCareNotice>? _last;

  Future<bool> _init() => _ready ??= () async {
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        // Unknown zone name: notices still fire, possibly offset by the zone difference.
        tz.setLocalLocation(tz.UTC);
      }
      // No permission prompt at start-up; it is asked when the first dated reminder is saved.
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      // The result is "permission granted" on iOS (false until asked), not "set up";
      // reaching this line without an exception means the plugin is ready.
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: darwin,
          macOS: darwin,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Care reminders: notifications unavailable ($e)');
      return false;
    }
  }();

  @override
  Future<bool> requestPermission() async {
    if (!await _init()) return false;
    try {
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) return await ios.requestPermissions(alert: true, badge: false, sound: true) ?? false;
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) return await android.requestNotificationsPermission() ?? false;
      return false;
    } catch (e) {
      debugPrint('Care reminders: permission request failed ($e)');
      return false;
    }
  }

  @override
  Future<int> sync(List<ScheduledCareNotice> notices) =>
      // Serialized: a burst of changes never interleaves cancel/schedule calls.
      _queue = _queue.then((_) => _sync(notices), onError: (_) => _sync(notices));

  Future<int> _sync(List<ScheduledCareNotice> notices) async {
    if (listEquals(_last, notices)) return notices.length;
    if (!await _init()) return 0;
    final l = kEnglish; // channel text is fixed at creation; the notices carry their own language
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'care_reminders',
        l.careChannelName,
        channelDescription: l.careChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    var scheduled = 0;
    try {
      for (var id = kCareNoticeBaseId; id < kCareNoticeBaseId + kMaxCareNotices; id++) {
        await _plugin.cancel(id: id);
      }
      for (final n in notices.take(kMaxCareNotices)) {
        await _plugin.zonedSchedule(
          id: n.id,
          title: n.title,
          body: n.body,
          scheduledDate: tz.TZDateTime.from(n.when, tz.local),
          notificationDetails: details,
          // Inexact: no exact-alarm permission needed; a reminder minutes late is fine.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        scheduled++;
      }
      _last = List.of(notices);
    } catch (e) {
      debugPrint('Care reminders: scheduling failed ($e)');
    }
    if (kDebugMode) debugPrint('Care reminders: $scheduled notification(s) scheduled');
    return scheduled;
  }
}

final reminderNotifierProvider = Provider<ReminderNotifier>((ref) => LocalReminderNotifier());
