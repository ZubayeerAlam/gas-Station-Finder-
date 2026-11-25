import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// English strings, used when no localizations are installed (e.g. pure
/// functions and widget tests that build a bare MaterialApp).
final AppLocalizations kEnglish = lookupAppLocalizations(const Locale('en'));

extension L10nX on BuildContext {
  AppLocalizations get l10n => Localizations.of<AppLocalizations>(this, AppLocalizations) ?? kEnglish;
}

const kLocaleSettingKey = 'locale';

/// Where the language choice is kept (null = follow the device).
abstract interface class LocalePreferenceStore {
  Stream<String?> watch();
  Future<void> save(String? code);
}

class DriftLocalePreferenceStore implements LocalePreferenceStore {
  DriftLocalePreferenceStore(this._db);
  final AppDatabase _db;

  @override
  Stream<String?> watch() => _db.watchSetting(kLocaleSettingKey);

  @override
  Future<void> save(String? code) => _db.writeSetting(kLocaleSettingKey, code);
}

final localePreferenceStoreProvider = Provider<LocalePreferenceStore>(
  (ref) => DriftLocalePreferenceStore(ref.watch(appDatabaseProvider)),
);

/// The user's language choice: null = follow the device.
final localePreferenceProvider = StreamProvider<String?>((ref) => ref.watch(localePreferenceStoreProvider).watch());

/// Locale for MaterialApp: null lets Flutter pick from the device language
/// (Bengali devices get Bengali, everything else falls back to English).
Locale? localeFromPreference(String? code) =>
    code != null && AppLocalizations.supportedLocales.any((l) => l.languageCode == code) ? Locale(code) : null;

Future<void> saveLocalePreference(WidgetRef ref, String? code) => ref.read(localePreferenceStoreProvider).save(code);
