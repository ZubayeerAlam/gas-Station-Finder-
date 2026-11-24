import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Never blocks the app: on any problem community features are just off.
  final firebase = await FirebaseBootstrap.init(AppConfig.fromEnvironment());
  runApp(
    // Automatic provider retry is disabled: network retries are handled by the
    // Dio RetryInterceptor, and permission errors must not be retried silently.
    ProviderScope(
      overrides: [firebaseStatusProvider.overrideWithValue(firebase)],
      retry: (retryCount, error) => null,
      child: const FuelWiseApp(),
    ),
  );
}
