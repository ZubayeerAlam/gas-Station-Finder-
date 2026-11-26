import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../domain/account_data.dart';
import 'account_providers.dart';

/// What FuelWise stores, and buttons to delete it (on the device and online).
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool _busy = false;

  Future<bool> _confirm(String title, String body) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(c).colorScheme.error,
              foregroundColor: Theme.of(c).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _run<T>(Future<Result<T>> Function() action, String Function(T value) okText) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          Ok(:final value) => okText(value),
          Err(:final failure) => describeFailure(failure, l),
        }),
      ),
    );
  }

  Future<void> _deleteDevice() async {
    final l = context.l10n;
    if (!await _confirm(l.privacyDeleteDeviceConfirmTitle, l.privacyDeleteDeviceConfirmBody)) return;
    await _run<void>(ref.read(accountControllerProvider).deleteDeviceData, (_) => l.privacyDeviceDeleted);
  }

  Future<void> _deleteOnline() async {
    final l = context.l10n;
    if (!await _confirm(l.privacyDeleteCommunityConfirmTitle, l.privacyDeleteCommunityConfirmBody)) return;
    await _run<CommunityDeletionSummary>(
      ref.read(accountControllerProvider).deleteOnlineData,
      (s) => l.privacyCommunityDeleted(s.total),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final online = ref.watch(communityAccountProvider);
    final danger = OutlinedButton.styleFrom(
      foregroundColor: theme.colorScheme.error,
      side: BorderSide(color: theme.colorScheme.error),
    );

    Widget section(IconData icon, String title, String body, Widget? action) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Semantics(header: true, child: Text(title, style: theme.textTheme.titleMedium)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(body, style: theme.textTheme.bodyMedium),
            if (action != null) ...[const SizedBox(height: AppSpacing.md), action],
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.privacyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (_busy) const LinearProgressIndicator(),
          section(
            Icons.smartphone_rounded,
            l.privacyDeviceTitle,
            l.privacyDeviceBody,
            OutlinedButton.icon(
              key: const Key('deleteDeviceData'),
              style: danger,
              onPressed: _busy ? null : _deleteDevice,
              icon: const Icon(Icons.delete_forever_rounded),
              label: Text(l.privacyDeleteDevice),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          section(
            Icons.cloud_outlined,
            l.privacyCommunityTitle,
            online.isAvailable ? l.privacyCommunityBody : l.privacyCommunityOff,
            online.isAvailable
                ? OutlinedButton.icon(
                    key: const Key('deleteOnlineData'),
                    style: danger,
                    onPressed: _busy ? null : _deleteOnline,
                    icon: const Icon(Icons.cloud_off_rounded),
                    label: Text(l.privacyDeleteCommunity),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
