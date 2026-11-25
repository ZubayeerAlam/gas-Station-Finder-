import 'package:gas_station_finder/features/care/domain/reminder_notifier.dart';

class FakeReminderNotifier implements ReminderNotifier {
  int permissionRequests = 0;
  bool grant = true;
  final syncs = <List<ScheduledCareNotice>>[];

  List<ScheduledCareNotice> get last => syncs.isEmpty ? const [] : syncs.last;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<int> sync(List<ScheduledCareNotice> notices) async {
    syncs.add(List.of(notices));
    return notices.length;
  }
}
