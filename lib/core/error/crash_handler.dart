import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// One caught error, kept only in memory on this device.
///
/// Privacy: no crash service is used. Nothing here is sent anywhere; the
/// message is shortened and the stack trace is not kept, so the log cannot
/// slowly collect user text (labels, notes, chat messages).
@immutable
class CrashRecord {
  const CrashRecord({required this.at, required this.source, required this.type, required this.message});

  final DateTime at;
  final String source;
  final String type;
  final String message;

  @override
  String toString() => '${at.toIso8601String()} [$source] $type: $message';
}

/// Catches errors that would otherwise crash the app or only show up in the
/// console, and keeps the most recent ones in a small in-memory list.
class CrashHandler {
  CrashHandler({this.capacity = 20, this.maxMessageLength = 200, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final int capacity;
  final int maxMessageLength;
  final DateTime Function() _clock;
  final _records = ListQueue<CrashRecord>();

  /// Newest first.
  List<CrashRecord> get records => List.unmodifiable(_records.toList().reversed);

  void record(Object error, {required String source}) {
    var message = '$error'.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (message.length > maxMessageLength) message = '${message.substring(0, maxMessageLength)}…';
    _records.addLast(CrashRecord(at: _clock(), source: source, type: '${error.runtimeType}', message: message));
    while (_records.length > capacity) {
      _records.removeFirst();
    }
    if (kDebugMode) debugPrint('FuelWise caught [$source] ${error.runtimeType}: $message');
  }

  void clear() => _records.clear();

  /// Installs the framework, platform and widget-build handlers.
  ///
  /// - Framework errors (layout, build, gestures) are still printed in debug
  ///   builds, then recorded.
  /// - Uncaught async errors are recorded and marked handled, so a failed
  ///   background task (a timer, a stream without `onError`) never closes the app.
  /// - In release builds a widget that throws while building shows a small
  ///   localized "this part could not be shown" card instead of a grey box.
  ///   Debug builds keep Flutter's red error screen for developers.
  void install({bool? releaseFallback}) {
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      record(details.exception, source: details.library ?? 'flutter');
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        previous?.call(details);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      record(error, source: 'async');
      return true;
    };
    if (releaseFallback ?? kReleaseMode) {
      ErrorWidget.builder = (details) => const BuildErrorCard();
    }
  }
}

/// The app's single crash handler (installed once in `main`).
final crashHandler = CrashHandler();

final crashHandlerProvider = Provider<CrashHandler>((ref) => crashHandler);

/// Records providers that fail, so errors swallowed into `AsyncError` states
/// are still counted. The UI keeps showing its own error views.
final class CrashProviderObserver extends ProviderObserver {
  const CrashProviderObserver(this.handler);
  final CrashHandler handler;

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    handler.record(error, source: 'provider ${context.provider.name ?? context.provider.runtimeType}');
  }
}

/// Shown in place of a widget that failed to build (release builds only).
class BuildErrorCard extends StatelessWidget {
  const BuildErrorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations) ?? kEnglish;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: scheme.error),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(l.errorPartNotShown, style: TextStyle(color: scheme.onSurface)),
            ),
          ],
        ),
      ),
    );
  }
}
