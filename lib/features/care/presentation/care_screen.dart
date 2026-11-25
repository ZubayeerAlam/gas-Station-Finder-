import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/vehicle_form_screen.dart' show parsePositive;
import '../domain/care_reminder.dart';
import '../domain/care_schedule.dart';
import 'care_form_screen.dart';
import 'care_labels.dart';
import 'care_providers.dart';

/// Document-expiry and service reminders of one vehicle, most urgent first.
class CareScreen extends ConsumerWidget {
  const CareScreen({super.key, required this.vehicle});

  final VehicleProfile vehicle;

  Future<void> _addSuggested(BuildContext context, WidgetRef ref, List<CareReminder> existing) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(careControllerProvider).addSuggested(vehicle, existing);
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          Ok(:final value) => l.careSuggestedAdded(value),
          Err(:final failure) => describeFailure(failure, l),
        }),
      ),
    );
  }

  void _openForm(BuildContext context, [CareReminder? r]) => context.push(
    AppRoutes.careEdit,
    extra: CareFormArgs(vehicle: vehicle, initial: r),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final items = ref.watch(careItemsProvider(vehicle.id));
    final stats = ref.watch(odometerStatsProvider(vehicle.id));
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: Text(l.careTitle(vehicle.name), overflow: TextOverflow.ellipsis)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_alert_rounded),
        label: Text(l.careAddReminder),
      ),
      body: switch (items) {
        AsyncData(:final value) when value.isEmpty => AppMessageView(
          icon: Icons.event_available_rounded,
          title: l.careEmptyTitle,
          message: l.careEmptyMessage,
          primaryLabel: l.careAddSuggested,
          onPrimary: () => _addSuggested(context, ref, const []),
        ),
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 96),
          children: [
            Text(
              stats.latestKm == null
                  ? l.careNoOdometer
                  : l.careOdometerKnown(kmText(stats.latestKm!)) +
                        (stats.kmPerDay == null ? '' : l.careOdometerRate(kmText(stats.kmPerDay!))),
              style: muted,
            ),
            for (final band in CareBand.values)
              if (value.any((i) => i.$2.band == band)) ...[
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
                  child: Semantics(
                    header: true,
                    child: Text(careBandLabel(band, l), style: theme.textTheme.titleSmall),
                  ),
                ),
                for (final item in value.where((i) => i.$2.band == band))
                  CareTile(
                    reminder: item.$1,
                    status: item.$2,
                    vehicle: vehicle,
                    onEdit: () => _openForm(context, item.$1),
                  ),
              ],
            if (suggestedCareTypes(vehicle).any((t) => !value.any((i) => i.$1.type == t)))
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _addSuggested(context, ref, [for (final i in value) i.$1]),
                  icon: const Icon(Icons.playlist_add_rounded),
                  label: Text(l.careAddSuggested),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            Text(l.careDisclaimer, style: muted),
          ],
        ),
        AsyncError(:final error) => AppErrorView(
          message: describeFailure(error, l),
          onRetry: () => ref.invalidate(careRemindersProvider(vehicle.id)),
        ),
        _ => const AppLoading(),
      },
    );
  }
}

class CareTile extends ConsumerWidget {
  const CareTile({
    super.key,
    required this.reminder,
    required this.status,
    required this.vehicle,
    required this.onEdit,
  });

  final CareReminder reminder;
  final CareStatus status;
  final VehicleProfile vehicle;
  final VoidCallback onEdit;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final controller = ref.read(careControllerProvider);
    final result = await controller.delete(reminder.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.isOk ? l.careDeleted : describeFailure((result as Err).failure, l)),
        action: result.isOk ? SnackBarAction(label: l.undo, onPressed: () => controller.save(reminder)) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (bg, fg) = switch (status.band) {
      CareBand.overdue => (scheme.errorContainer, scheme.onErrorContainer),
      CareBand.dueSoon => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    final progress = status.progress;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.md),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.xs, AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: CircleAvatar(backgroundColor: bg, foregroundColor: fg, child: Icon(careTypeIcon(reminder.type))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(careTitle(reminder, l), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(careStatusText(reminder, status, l), style: theme.textTheme.bodyMedium),
                    if (progress != null && status.band != CareBand.done)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
                        child: Semantics(
                          label: l.careProgressSemantics((progress * 100).round()),
                          child: ExcludeSemantics(
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                              color: status.band == CareBand.overdue
                                  ? scheme.error
                                  : status.band == CareBand.dueSoon
                                  ? scheme.tertiary
                                  : scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    if (reminder.note != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          reminder.note!,
                          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: l.careOptions,
                onSelected: (v) => switch (v) {
                  'done' => showMarkDoneSheet(context, reminder: reminder, vehicle: vehicle),
                  'edit' => onEdit(),
                  _ => _delete(context, ref),
                },
                itemBuilder: (_) => [
                  if (reminder.hasDue) PopupMenuItem(value: 'done', child: Text(l.careMarkDone)),
                  PopupMenuItem(value: 'edit', child: Text(l.edit)),
                  PopupMenuItem(value: 'delete', child: Text(l.delete)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showMarkDoneSheet(
  BuildContext context, {
  required CareReminder reminder,
  required VehicleProfile vehicle,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (sheetContext) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
    child: _MarkDoneForm(reminder: reminder, vehicle: vehicle),
  ),
);

class _MarkDoneForm extends ConsumerStatefulWidget {
  const _MarkDoneForm({required this.reminder, required this.vehicle});

  final CareReminder reminder;
  final VehicleProfile vehicle;

  @override
  ConsumerState<_MarkDoneForm> createState() => _MarkDoneFormState();
}

class _MarkDoneFormState extends ConsumerState<_MarkDoneForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _km;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _date = dateOnly(ref.read(nowProvider)());
    final latest = ref.read(odometerStatsProvider(widget.vehicle.id)).latestKm;
    _km = TextEditingController(text: latest == null ? '' : latest.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _km.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = ref.read(nowProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await ref
        .read(careControllerProvider)
        .markDone(widget.reminder, doneAt: _date, doneKm: parsePositive(_km.text));
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok(:final value):
        navigator.pop();
        final next = [
          if (value.dueDate != null) careDate(value.dueDate!, l),
          if (value.dueOdometerKm != null) kmText(value.dueOdometerKm!),
        ].join(' · ');
        messenger.showSnackBar(SnackBar(content: Text(next.isEmpty ? l.careMarkedDone : l.careMarkedDoneNext(next))));
      case Err(:final failure):
        messenger.showSnackBar(SnackBar(content: Text(describeFailure(failure, l))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('${l.careMarkDone}: ${careTitle(widget.reminder, l)}', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Text(l.careDoneDate, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_rounded),
              label: Text(careDate(_date, l)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('doneKm'),
            controller: _km,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(labelText: l.careOdometerNow, suffixText: 'km'),
            validator: (t) => (t ?? '').trim().isEmpty || parsePositive(t) != null ? null : l.enterPositiveNumber,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? l.saving : l.careMarkDone)),
        ],
      ),
    );
  }
}
