import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/error/crash_handler.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // First, so even a failing Firebase start-up is caught and not fatal.
  crashHandler.install();
  // Never blocks the app: on any problem community features are just off.
  final firebase = await FirebaseBootstrap.init(AppConfig.fromEnvironment());
  runApp(
    // Automatic provider retry is disabled: network retries are handled by the
    // Dio RetryInterceptor, and permission errors must not be retried silently.
    ProviderScope(
      overrides: [firebaseStatusProvider.overrideWithValue(firebase)],
      retry: (retryCount, error) => null,
      observers: [CrashProviderObserver(crashHandler)],
      child: const FuelWiseApp(),
    ),
  );
}
