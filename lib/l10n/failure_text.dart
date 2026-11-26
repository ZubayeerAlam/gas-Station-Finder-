import '../core/error/app_failure.dart';
import '../core/utils/formatters.dart';
import 'app_localizations.dart';

/// User-facing, translated text for any error caught in the UI.
///
/// Failures with a [FailureCode] are translated; failures without one carry a
/// specific message from their source (e.g. the server) and are shown as-is.
/// Non-[AppFailure] errors fall back to [fallback] (or a generic message).
String describeFailure(Object? error, AppLocalizations l, {String? fallback}) {
  if (error is! AppFailure) return fallback ?? l.errorUnknown;
  final code = error.code;
  if (code == null) return error.message;
  return switch (code) {
    FailureCode.network => l.errorNetwork,
    FailureCode.timeout => l.errorTimeout,
    FailureCode.notFound => l.errorNotFound,
    FailureCode.unknown => l.errorUnknown,
    FailureCode.cancelled => l.errorCancelled,
    FailureCode.badResponse => l.errorBadResponse,
    FailureCode.requestRejected => l.errorRequestRejected,
    FailureCode.tooManyRequests => l.errorTooManyRequests,
    FailureCode.serverError => l.errorServer(
        error is ServerFailure && error.statusCode != null ? '${error.statusCode}' : '?'),
    FailureCode.missingGoogleKey => l.errorMissingGoogleKey,
    FailureCode.missingOcmKey => l.errorMissingOcmKey,
    FailureCode.communityUnavailable => l.errorCommunityUnavailable,
    FailureCode.communityNeedsSignIn => l.errorCommunityNeedsSignIn,
    FailureCode.notAllowed => l.errorNotAllowed,
    FailureCode.signInFailed => l.errorSignInFailed,
    FailureCode.assistantFailed => l.errorAssistantFailed,
    FailureCode.noDetours => l.errorNoDetours,
    FailureCode.noRouteToDestination => l.errorNoRouteToDestination,
    FailureCode.noRouteToStation => l.errorNoRouteToStation,
    FailureCode.historySaveFailed => l.errorHistorySave,
    FailureCode.garageSaveFailed => l.errorGarageSave,
    FailureCode.careSaveFailed => l.errorCareSave,
    FailureCode.dataDeletionFailed => l.errorDataDeletion,
    FailureCode.exportFailed => l.errorExport,
    FailureCode.locationServiceDisabled => l.errorLocationServiceDisabled,
    FailureCode.locationDenied => l.errorLocationDenied,
    FailureCode.locationDeniedForever => l.errorLocationDeniedForever,
    FailureCode.locationUnavailable => l.errorLocationUnavailable,
  };
}

/// "5 min ago" / "৫ মিনিট আগে"; dates older than 30 days as yyyy-mm-dd.
String relativeTime(DateTime time, AppLocalizations l, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(time);
  if (diff.isNegative || diff.inMinutes < 1) return l.timeJustNow;
  if (diff.inHours < 1) return l.timeMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l.timeHoursAgo(diff.inHours);
  if (diff.inDays < 30) return l.timeDaysAgo(diff.inDays);
  return Fmt.date(time);
}

/// Localized short month name ("Mar" / "মার্চ").
/// (A string list instead of intl's DateFormat: it needs no async locale data.)
String monthShort(int month, AppLocalizations l) => l.monthsShort.split(',')[month - 1];
