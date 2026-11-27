import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';

import '../helpers/fake_garage_repository.dart';

/// Keyboard / switch-access users move with Tab: focus must follow the
/// visual reading order and reach the Save button.
void main() {
  testWidgets('vehicle form: Tab order follows the layout and reaches Save', (tester) async {
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [garageRepositoryProvider.overrideWithValue(FakeGarageRepository())],
        retry: (_, _) => null,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: buildRouter(initialLocation: AppRoutes.vehicleNew),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextFormField).first); // vehicle name
    await tester.pumpAndSettle();

    final visited = <String>[];
    final tops = <double>[];
    for (var i = 0; i < 25; i++) {
      final focus = FocusManager.instance.primaryFocus;
      final ctx = focus?.context;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        final editable =
            ctx.findAncestorWidgetOfExactType<EditableText>() ??
            (ctx.widget is EditableText ? ctx.widget as EditableText : null);
        String? label;
        for (final k in ['consumption', 'capacity']) {
          final f = find.byKey(Key(k));
          if (f.evaluate().isNotEmpty &&
              find.descendant(of: f, matching: find.byWidget(ctx.widget)).evaluate().isNotEmpty) {
            label = k;
          }
        }
        if (editable != null && label == null && visited.isEmpty) label = 'name';
        if (ctx.findAncestorWidgetOfExactType<FilledButton>() != null || ctx.widget is FilledButton) label = 'save';
        if (label != null && (visited.isEmpty || visited.last != label)) visited.add(label);
        if (box != null && box.hasSize) tops.add(box.localToGlobal(Offset.zero).dy);
        if (label == 'save') break;
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
    }

    expect(visited, ['name', 'consumption', 'capacity', 'save']);
    // Focus never jumps back up the page (controls on the same row, such as the
    // unit menu beside the consumption field, may sit a few pixels higher).
    for (var i = 1; i < tops.length; i++) {
      expect(tops[i], greaterThanOrEqualTo(tops[i - 1] - 32), reason: 'step $i moved up: $tops');
    }
  });
}
