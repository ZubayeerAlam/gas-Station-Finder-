import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';

/// Hands an exported file to the user (share sheet: Files, Drive, email, …).
abstract interface class HistoryExporter {
  /// [origin] anchors the share popover on iPad. A dismissed sheet is not an error.
  Future<Result<void>> export({required String fileName, required String csv, String? subject, Rect? origin});
}

/// Writes the CSV to the app's temporary folder, then opens the system share
/// sheet. Nothing leaves the phone unless the user picks a destination.
class ShareHistoryExporter implements HistoryExporter {
  @override
  Future<Result<void>> export({required String fileName, required String csv, String? subject, Rect? origin}) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(utf8.encode(csv), flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          subject: subject,
          sharePositionOrigin: origin,
        ),
      );
      return const Ok(null);
    } catch (e) {
      debugPrint('History export failed: ${e.runtimeType}');
      return const Err(UnknownFailure('Could not export the history.', FailureCode.exportFailed));
    }
  }
}

final historyExporterProvider = Provider<HistoryExporter>((ref) => ShareHistoryExporter());
