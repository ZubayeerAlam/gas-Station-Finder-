import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../../../core/firebase/firebase_bootstrap.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/failure_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../prices/domain/community_models.dart';
import '../../../prices/presentation/community_providers.dart';

/// "Is this charger working?" for an Open Charge Map charger.
///
/// Reuses the station verification votes keyed by the charger id
/// (`ocm:<id>`): working = open, not working = closed. One private vote per
/// user, counted over 30 days by the existing `onVerificationWritten`
/// function and removed by "delete my data". Hidden when the community
/// backend is not configured.
class ChargerCommunityStatus extends ConsumerWidget {
  const ChargerCommunityStatus({super.key, required this.chargerId});

  final String chargerId;

  Future<void> _vote(BuildContext context, WidgetRef ref, bool working) async {
    final result = await ref.read(communityRepositoryProvider).vote(chargerId, StationVote(open: working));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(switch (result) {
        Ok() => context.l10n.thanksForConfirming,
        Err(:final failure) => describeFailure(failure, context.l10n),
      }),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(firebaseStatusProvider).ready) return const SizedBox.shrink();
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final rel = ref.watch(stationReliabilityProvider(chargerId)).value;
    final mine = ref.watch(myVoteProvider(chargerId)).value;
    final working = rel?.openVotes ?? 0, broken = rel?.closedVotes ?? 0;

    return Column(
      key: const Key('chargerCommunity'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.chargerWorkingQuestion, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          working + broken == 0 ? l.chargerVotesNone : l.chargerVotesSummary(working, broken),
          key: const Key('chargerVotes'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: broken > working ? theme.colorScheme.error : null,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              key: const Key('chargerVoteWorking'),
              avatar: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: Text(l.chargerVoteWorking),
              selected: mine?.open == true,
              onSelected: (_) => _vote(context, ref, true),
            ),
            ChoiceChip(
              key: const Key('chargerVoteBroken'),
              avatar: const Icon(Icons.report_problem_outlined, size: 18),
              label: Text(l.chargerVoteBroken),
              selected: mine?.open == false,
              onSelected: (_) => _vote(context, ref, false),
            ),
          ],
        ),
        Text(l.chargerVotesNote, style: muted),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
