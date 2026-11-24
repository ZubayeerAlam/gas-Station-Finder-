import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(
    // Automatic provider retry is disabled: network retries are handled by the
    // Dio RetryInterceptor, and permission errors must not be retried silently.
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const FuelWiseApp(),
    ),
  );
}
