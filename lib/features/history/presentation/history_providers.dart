import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../data/drift_fill_up_repository.dart';
import '../domain/fill_up.dart';

/// Fill-ups of a vehicle, newest first.
final fillUpsProvider = StreamProvider.family<List<FillUp>, String>(
  (ref, vehicleId) => ref.watch(fillUpRepositoryProvider).watchFillUps(vehicleId),
);

class HistoryController {
  HistoryController(this._ref);

  final Ref _ref;
  final _random = Random();

  String newId() => 'fill_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 20)}';

  Future<Result<void>> save(FillUp f) => _ref.read(fillUpRepositoryProvider).save(f);
  Future<Result<void>> delete(String id) => _ref.read(fillUpRepositoryProvider).delete(id);
}

final historyControllerProvider = Provider<HistoryController>(HistoryController.new);
