import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/stations/presentation/map_screen.dart';

abstract final class AppRoutes {
  static const map = '/';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.map,
    routes: [
      GoRoute(path: AppRoutes.map, builder: (context, state) => const MapScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
