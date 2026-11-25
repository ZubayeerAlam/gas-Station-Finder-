import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/assistant_models.dart';

/// Used when Firebase is off: the assistant needs its server function.
class UnavailableAssistantApi implements AssistantApi {
  const UnavailableAssistantApi(this.reason);

  final String reason;

  @override
  bool get isAvailable => false;

  @override
  Future<Result<AssistantTurn>> sendMessage(String? sessionId, String text) async => Err(ConfigFailure(reason));

  @override
  Future<Result<AssistantTurn>> sendToolResults(String sessionId, List<ToolOutput> results) async =>
      Err(ConfigFailure(reason));
}
