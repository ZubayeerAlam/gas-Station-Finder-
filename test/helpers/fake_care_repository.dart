import 'dart:async';

import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';
import 'package:gas_station_finder/features/care/domain/care_repository.dart';

/// In-memory [CareRepository] for widget tests.
class FakeCareRepository implements CareRepository {
  FakeCareRepository([List<CareReminder> initial = const []]) : items = [...initial];

  final List<CareReminder> items;
  final _changes = StreamController<void>.broadcast();

  Stream<List<CareReminder>> _watch(List<CareReminder> Function() read) => Stream.multi((c) {
    c.add(read());
    final sub = _changes.stream.listen((_) => c.add(read()));
    c.onCancel = sub.cancel;
  });

  @override
  Stream<List<CareReminder>> watchReminders(String vehicleId) =>
      _watch(() => items.where((r) => r.vehicleId == vehicleId).toList());

  @override
  Stream<List<CareReminder>> watchAll() => _watch(() => List.of(items));

  @override
  Future<Result<void>> save(CareReminder r) async {
    final i = items.indexWhere((e) => e.id == r.id);
    i >= 0 ? items[i] = r : items.add(r);
    _changes.add(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    items.removeWhere((e) => e.id == id);
    _changes.add(null);
    return const Ok(null);
  }
}
