import 'dart:async';

import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/history/domain/fill_up_repository.dart';

class FakeFillUpRepository implements FillUpRepository {
  FakeFillUpRepository([List<FillUp> initial = const []]) : items = [...initial];

  final List<FillUp> items;
  final _changes = StreamController<void>.broadcast();

  List<FillUp> _of(String vehicleId) =>
      items.where((f) => f.vehicleId == vehicleId).toList()..sort((a, b) => b.date.compareTo(a.date));

  @override
  Stream<List<FillUp>> watchFillUps(String vehicleId) => Stream.multi((c) {
        c.add(_of(vehicleId));
        final sub = _changes.stream.listen((_) => c.add(_of(vehicleId)));
        c.onCancel = sub.cancel;
      });

  @override
  Future<Result<void>> save(FillUp f) async {
    items
      ..removeWhere((e) => e.id == f.id)
      ..add(f);
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
