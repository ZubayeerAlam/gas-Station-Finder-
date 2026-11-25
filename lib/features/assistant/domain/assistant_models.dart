import '../../../core/error/result.dart';

/// A tool the server asks the app to run (its data lives on the device).
class ClientToolCall {
  const ClientToolCall({required this.id, required this.name, required this.input});

  final String id;
  final String name;
  final Map<String, Object?> input;
}

/// What the app sends back for one [ClientToolCall].
class ToolOutput {
  const ToolOutput({required this.toolUseId, required this.output, this.isError = false});

  final String toolUseId;
  final Object? output;
  final bool isError;

  Map<String, Object?> toMap() => {'toolUseId': toolUseId, 'output': output, if (isError) 'isError': true};
}

/// One response of the `assistantChat` function.
class AssistantTurn {
  const AssistantTurn({
    required this.sessionId,
    required this.needsClientTools,
    this.reply,
    this.cards = const [],
    this.toolCalls = const [],
    this.demo = false,
  });

  final String sessionId;

  /// True when the app must run [toolCalls] and send their results back.
  final bool needsClientTools;
  final String? reply;

  /// Station ids to show as cards, best first (all came from the app's own plan).
  final List<String> cards;
  final List<ClientToolCall> toolCalls;

  /// True when the emulator's scripted offline demo answered, not Claude.
  final bool demo;

  /// Parses the callable result. Throws [FormatException] on a bad shape.
  factory AssistantTurn.fromMap(Map<String, Object?> m) {
    final sessionId = m['sessionId'];
    final status = m['status'];
    if (sessionId is! String || (status != 'done' && status != 'needs_client_tools')) {
      throw const FormatException('Unexpected assistant response');
    }
    return AssistantTurn(
      sessionId: sessionId,
      needsClientTools: status == 'needs_client_tools',
      reply: m['reply'] as String?,
      cards: [for (final c in (m['cards'] as List?) ?? const []) if (c is String) c],
      toolCalls: [
        for (final c in (m['clientToolCalls'] as List?) ?? const [])
          if (c case {'id': final String id, 'name': final String name})
            ClientToolCall(id: id, name: name, input: deepStringKeys(c['input']) as Map<String, Object?>? ?? {}),
      ],
      demo: m['demo'] == true,
    );
  }
}

/// Platform channels return `Map<Object?, Object?>`; make nested maps JSON-like.
Object? deepStringKeys(Object? v) => switch (v) {
      Map() => {for (final e in v.entries) '${e.key}': deepStringKeys(e.value)},
      List() => [for (final x in v) deepStringKeys(x)],
      _ => v,
    };

/// The server side of the trip assistant (Cloud Function `assistantChat`).
abstract interface class AssistantApi {
  bool get isAvailable;

  Future<Result<AssistantTurn>> sendMessage(String? sessionId, String text);

  Future<Result<AssistantTurn>> sendToolResults(String sessionId, List<ToolOutput> results);
}
