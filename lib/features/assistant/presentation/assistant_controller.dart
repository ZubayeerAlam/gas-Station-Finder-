import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/location/location_controller.dart';
import '../../along_route/data/places_place_search_repository.dart';
import '../../along_route/domain/along_route_models.dart';
import '../../along_route/presentation/along_route_providers.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../ranking/domain/ranking_models.dart';
import '../data/firebase_assistant_api.dart';
import '../data/unavailable_assistant_api.dart';
import '../domain/assistant_models.dart';
import 'assistant_tools.dart';

final assistantApiProvider = Provider<AssistantApi>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  if (!status.ready) return UnavailableAssistantApi(status.problem ?? 'The assistant is not set up in this build.');
  return FirebaseAssistantApi(FirebaseFunctions.instanceFor(region: kFunctionsRegion), FirebaseAuth.instance);
});

final assistantToolRunnerProvider = Provider<AssistantToolRunner>(
  (ref) => AssistantToolRunner(
    vehicle: () async {
      // Wait for the garage to load (local database).
      final list = await ref.read(vehiclesProvider.future);
      final id = await ref.read(activeVehicleIdProvider.future);
      return list.where((v) => v.id == id).firstOrNull;
    },
    fillLevel: () => ref.read(fillLevelProvider),
    origin: () => ref.read(locationControllerProvider.future),
    places: ref.watch(placeSearchRepositoryProvider),
    planner: ref.watch(alongRoutePlannerProvider),
    now: ref.watch(nowProvider),
  ),
);

/// A station card under an assistant reply: a snapshot of the app's ranking.
class AssistantCard {
  const AssistantCard({required this.ranked, required this.stop, required this.rank, required this.trip});

  final RankedStation ranked;
  final RouteStop stop;

  /// 1-based position in the ranking; null = unpriced.
  final int? rank;
  final PlannedTrip trip;
}

class ChatMessage {
  const ChatMessage.user(this.text)
      : fromUser = true,
        cards = const [],
        demo = false,
        isError = false;

  const ChatMessage.assistant(this.text, {this.cards = const [], this.demo = false})
      : fromUser = false,
        isError = false;

  const ChatMessage.error(this.text)
      : fromUser = false,
        cards = const [],
        demo = false,
        isError = true;

  final bool fromUser;
  final String text;
  final List<AssistantCard> cards;
  final bool demo;
  final bool isError;
}

class AssistantChatState {
  const AssistantChatState({this.messages = const [], this.sending = false, this.sessionId, this.status});

  final List<ChatMessage> messages;
  final bool sending;
  final String? sessionId;

  /// "Planning your route…" while the app runs a tool.
  final String? status;

  AssistantChatState copyWith({List<ChatMessage>? messages, bool? sending, String? Function()? sessionId, String? Function()? status}) =>
      AssistantChatState(
        messages: messages ?? this.messages,
        sending: sending ?? this.sending,
        sessionId: sessionId == null ? this.sessionId : sessionId(),
        status: status == null ? this.status : status(),
      );
}

/// Resolves server card ids against a planned trip. Pure — exposed for tests.
List<AssistantCard> cardsFor(List<String> ids, PlannedTrip? trip) {
  if (trip == null) return const [];
  final ranked = trip.ranking.ranked;
  return [
    for (final id in ids)
      if (trip.plan.stops.where((s) => s.station.id == id).firstOrNull case final stop?)
        if ([...ranked, ...trip.ranking.unpriced].where((r) => r.offer.stationId == id).firstOrNull case final r?)
          AssistantCard(
            ranked: r,
            stop: stop,
            rank: ranked.contains(r) ? ranked.indexOf(r) + 1 : null,
            trip: trip,
          ),
  ];
}

class AssistantController extends Notifier<AssistantChatState> {
  /// Client tool round-trips per message (the server caps model calls too).
  static const maxToolRounds = 4;

  PlannedTrip? _lastTrip;

  @override
  AssistantChatState build() => const AssistantChatState();

  void newChat() {
    _lastTrip = null;
    state = const AssistantChatState();
  }

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.sending) return;
    final api = ref.read(assistantApiProvider);
    final tools = ref.read(assistantToolRunnerProvider);
    state = state.copyWith(messages: [...state.messages, ChatMessage.user(text)], sending: true);

    var result = await api.sendMessage(state.sessionId, text);
    var inToolPhase = false;
    for (var round = 0;; round++) {
      if (!ref.mounted) return;
      switch (result) {
        case Err(:final failure):
          // A failure mid tool-call leaves the server session waiting: start fresh next time.
          _finish(ChatMessage.error(failure.message), resetSession: inToolPhase);
          return;
        case Ok(value: final turn):
          state = state.copyWith(sessionId: () => turn.sessionId);
          if (!turn.needsClientTools) {
            _finish(ChatMessage.assistant(turn.reply ?? '', cards: cardsFor(turn.cards, _lastTrip), demo: turn.demo));
            return;
          }
          if (round >= maxToolRounds) {
            _finish(const ChatMessage.error('That took too many steps. Please try a simpler question.'), resetSession: true);
            return;
          }
          inToolPhase = true;
          final outputs = <ToolOutput>[];
          for (final call in turn.toolCalls) {
            state = state.copyWith(status: () => _statusFor(call.name));
            final run = await tools.run(call);
            if (run.trip != null) _lastTrip = run.trip;
            outputs.add(ToolOutput(toolUseId: call.id, output: run.output, isError: run.isError));
          }
          if (!ref.mounted) return;
          state = state.copyWith(status: () => null);
          result = await api.sendToolResults(turn.sessionId, outputs);
      }
    }
  }

  void _finish(ChatMessage m, {bool resetSession = false}) => state = state.copyWith(
        messages: [...state.messages, m],
        sending: false,
        status: () => null,
        sessionId: resetSession ? () => null : null,
      );

  static String _statusFor(String tool) => switch (tool) {
        'plan_route_stops' => 'Planning your route and ranking stations…',
        'get_vehicle' => 'Checking your vehicle…',
        _ => 'Working…',
      };
}

final assistantControllerProvider =
    NotifierProvider<AssistantController, AssistantChatState>(AssistantController.new);
