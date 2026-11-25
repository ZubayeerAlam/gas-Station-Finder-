import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/care/presentation/care_notifications.dart';
import 'l10n/l10n.dart';

class FuelWiseApp extends ConsumerWidget {
  const FuelWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keeps the device's care-reminder notifications in step with the data.
    ref.watch(careSyncProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: localeFromPreference(ref.watch(localePreferenceProvider).value),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
