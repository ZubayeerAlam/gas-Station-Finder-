import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../along_route/presentation/along_route_providers.dart';
import '../../along_route/presentation/along_route_screen.dart' show StationResultCard;
import 'assistant_controller.dart';

const kAssistantSuggestions = [
  'Where should I fill up on my way to the airport?',
  'Cheapest charging stop on the way to Hamburg?',
  'Which station has the smallest detour on my way to work?',
];

/// Chat with the trip assistant. Station cards are the app's own ranking —
/// the model only chooses which stations to show.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final t = (text ?? _input.text).trim();
    if (t.isEmpty) return;
    _input.clear();
    ref.read(assistantControllerProvider.notifier).send(t);
  }

  void _showOnMap(AssistantCard card) {
    ref.read(rankingStrategyProvider.notifier).set(card.trip.ranking.strategy);
    ref.read(alongRouteControllerProvider.notifier).show(card.trip.plan);
    context.push(AppRoutes.planRoute);
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(assistantApiProvider);
    final chat = ref.watch(assistantControllerProvider);
    final theme = Theme.of(context);
    ref.listen(assistantControllerProvider.select((s) => s.messages.length), (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip assistant'),
        actions: [
          if (chat.messages.isNotEmpty)
            IconButton(
              tooltip: 'New chat',
              icon: const Icon(Icons.add_comment_outlined),
              onPressed: chat.sending ? null : () => ref.read(assistantControllerProvider.notifier).newChat(),
            ),
        ],
      ),
      body: !api.isAvailable
          ? const AppMessageView(
              icon: Icons.cloud_off_rounded,
              title: 'Assistant not available',
              message: 'The trip assistant runs on the FuelWise server, which is not set up in this build.',
            )
          : Column(
              children: [
                Expanded(
                  child: chat.messages.isEmpty
                      ? _Welcome(onPick: _send)
                      : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: chat.messages.length + (chat.sending ? 1 : 0),
                          itemBuilder: (context, i) => i == chat.messages.length
                              ? _Thinking(status: chat.status)
                              : _MessageView(message: chat.messages[i], onShowOnMap: _showOnMap),
                        ),
                ),
                const Divider(height: 1),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const Key('assistantInput'),
                            controller: _input,
                            minLines: 1,
                            maxLines: 4,
                            maxLength: 1000,
                            textInputAction: TextInputAction.send,
                            onSubmitted: chat.sending ? null : (_) => _send(),
                            decoration: const InputDecoration(
                              hintText: 'Ask about fuel or charging on your trip',
                              counterText: '',
                            ),
                          ),
                        ),
                        IconButton.filled(
                          tooltip: 'Send',
                          onPressed: chat.sending ? null : _send,
                          icon: const Icon(Icons.arrow_upward_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
                  child: Text(
                    'Answers use the app\'s own route ranking. Check prices at the pump.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Icon(Icons.auto_awesome_rounded, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.md),
        Text('Plan smarter stops', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tell me where you are driving. I rank fuel or charging stops on the way by total cost, '
          'detour and reliability, using your vehicle from the garage.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final s in kAssistantSuggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => onPick(s),
              child: Text(s),
            ),
          ),
      ],
    );
  }
}

class _Thinking extends StatelessWidget {
  const _Thinking({this.status});

  final String? status;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: Text(status ?? 'Thinking…', style: Theme.of(context).textTheme.bodySmall)),
          ],
        ),
      );
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, required this.onShowOnMap});

  final ChatMessage message;
  final void Function(AssistantCard) onShowOnMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final m = message;
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.82),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: m.fromUser
            ? cs.primary
            : m.isError
                ? cs.errorContainer
                : cs.surfaceContainerHigh,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(m.fromUser ? 18 : 4),
          bottomRight: Radius.circular(m.fromUser ? 4 : 18),
        ),
      ),
      child: Text(
        m.text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: m.fromUser
              ? cs.onPrimary
              : m.isError
                  ? cs.onErrorContainer
                  : cs.onSurface,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: m.fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (m.demo)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text('Offline demo — not Claude',
                  style: theme.textTheme.labelSmall?.copyWith(color: cs.tertiary)),
            ),
          bubble,
          if (m.cards.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final c in m.cards)
              StationResultCard(
                ranked: c.ranked,
                stop: c.stop,
                rank: c.rank,
                mode: c.trip.ranking.mode,
                unit: c.trip.unit,
                selected: false,
                onShowOnMap: () => onShowOnMap(c),
              ),
          ],
        ],
      ),
    );
  }
}
