/// Typed, user-presentable failures. Thrown into Riverpod `AsyncError`s and
/// carried by [Result]. Never contains secrets.
///
/// [message] is an English fallback (logs, tool results sent to the AI). The
/// UI shows a translated text chosen by [code] when one is set — see
/// `describeFailure` in `lib/l10n/failure_text.dart`.
sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.code});

  final String message;
  final FailureCode? code;

  @override
  String toString() => '$runtimeType: $message';
}

/// Stable, language-independent identifiers for failures the UI translates.
enum FailureCode {
  network,
  timeout,
  notFound,
  unknown,
  cancelled,
  badResponse,
  requestRejected,
  tooManyRequests,
  serverError,
  missingGoogleKey,
  missingOcmKey,
  communityUnavailable,
  communityNeedsSignIn,
  notAllowed,
  signInFailed,
  assistantFailed,
  noDetours,
  noRouteToDestination,
  noRouteToStation,
  historySaveFailed,
  garageSaveFailed,
  careSaveFailed,
  locationServiceDisabled,
  locationDenied,
  locationDeniedForever,
  locationUnavailable,
}

const _networkMsg = 'No internet connection. Check your network and try again.';
const _timeoutMsg = 'The server took too long to respond. Please try again.';
const _notFoundMsg = 'Nothing was found.';
const _unknownMsg = 'Something went wrong. Please try again.';

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = _networkMsg])
      : super(code: message == _networkMsg ? FailureCode.network : null);
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = _timeoutMsg])
      : super(code: message == _timeoutMsg ? FailureCode.timeout : null);
}

final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {this.statusCode, super.code});

  final int? statusCode;
}

/// A custom [message] without a [code] is shown as-is (untranslated).
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = _notFoundMsg, FailureCode? code])
      : super(code: code ?? (message == _notFoundMsg ? FailureCode.notFound : null));
}

final class ConfigFailure extends AppFailure {
  const ConfigFailure(super.message, {super.code});
}

enum LocationFailureReason { serviceDisabled, denied, deniedForever, unavailable }

final class LocationFailure extends AppFailure {
  const LocationFailure(this.reason, super.message, {super.code});

  final LocationFailureReason reason;
}

/// A custom [message] without a [code] is shown as-is (untranslated).
final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = _unknownMsg, FailureCode? code])
      : super(code: code ?? (message == _unknownMsg ? FailureCode.unknown : null));
}
