import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../along_route/domain/along_route_models.dart';
import '../../along_route/presentation/along_route_providers.dart';
import '../domain/saved_trip.dart';
import 'saved_trips_providers.dart';

/// "Saved trips" on the destination screen: one tap plans the trip again.
class SavedTripsSection extends ConsumerStatefulWidget {
  const SavedTripsSection({super.key, required this.onPlan});

  final ValueChanged<Destination> onPlan;

  @override
  ConsumerState<SavedTripsSection> createState() => _SavedTripsSectionState();
}

class _SavedTripsSectionState extends ConsumerState<SavedTripsSection> {
  String? _busyId;

  Future<void> _open(SavedTrip trip) async {
    setState(() => _busyId = trip.id);
    final result = await ref.read(savedTripsControllerProvider).destinationFor(trip);
    if (!mounted) return;
    setState(() => _busyId = null);
    switch (result) {
      case Ok(:final value):
        widget.onPlan(value);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeFailure(failure, context.l10n))));
    }
  }

  Future<void> _remove(SavedTrip trip) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(savedTripsControllerProvider);
    await controller.delete(trip.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.tripRemoved),
        action: SnackBarAction(label: l.undo, onPressed: () => controller.restore(trip)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(savedTripsProvider).value ?? const <SavedTrip>[];
    if (trips.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final theme = Theme.of(context);
    final now = ref.watch(nowProvider)();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
          child: Text(l.savedTripsTitle, style: theme.textTheme.titleSmall),
        ),
        for (final t in trips)
          ListTile(
            key: ValueKey('savedTrip-${t.id}'),
            leading: _busyId == t.id
                ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.bookmark_rounded),
            title: Text(t.label),
            subtitle: _subtitle(l, t, now),
            enabled: _busyId == null && t.canPlan(now),
            onTap: () => _open(t),
            trailing: IconButton(
              tooltip: l.removeSavedTrip,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _busyId == null ? () => _remove(t) : null,
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  static Widget? _subtitle(AppLocalizations l, SavedTrip t, DateTime now) {
    final parts = <String>[
      if ((t.lastDistanceMeters, t.lastDurationSeconds) case (final m?, final s?))
        l.savedTripLastTime('${Fmt.distance(m)} · ${Fmt.duration(Duration(seconds: s.round()))}'),
      if (!t.coordsUsable(now)) t.placeId != null ? l.savedTripNeedsLookup : l.errorTripLocationExpired,
    ];
    return parts.isEmpty ? null : Text(parts.join('\n'));
  }
}

/// Asks for a label and saves the currently planned trip.
Future<void> showSaveTripDialog(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final label = await showDialog<String>(context: context, builder: (_) => const _SaveTripDialog());
  if (label == null) return;
  final result = await ref.read(savedTripsControllerProvider).saveCurrent(label);
  messenger.showSnackBar(
    SnackBar(content: Text(switch (result) {
      Ok() => l.tripSaved,
      Err(:final failure) => describeFailure(failure, l),
    })),
  );
}

class _SaveTripDialog extends StatefulWidget {
  const _SaveTripDialog();

  @override
  State<_SaveTripDialog> createState() => _SaveTripDialogState();
}

class _SaveTripDialogState extends State<_SaveTripDialog> {
  final _form = GlobalKey<FormState>();
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) Navigator.of(context).pop(normalizeTripLabel(_text.text));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.saveTripDialogTitle),
      content: Form(
        key: _form,
        child: TextFormField(
          key: const ValueKey('tripLabel'),
          controller: _text,
          autofocus: true,
          maxLength: kMaxTripLabelLength,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: l.tripLabel, hintText: l.tripLabelHint),
          validator: (v) => normalizeTripLabel(v ?? '') == null ? l.tripLabelInvalid : null,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.cancel)),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}
