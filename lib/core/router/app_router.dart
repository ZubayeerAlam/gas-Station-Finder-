import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/garage/domain/vehicle_profile.dart';
import '../../features/garage/presentation/garage_screen.dart';
import '../../features/garage/presentation/vehicle_form_screen.dart';
import '../../features/history/presentation/fill_up_form_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/stations/presentation/map_screen.dart';
import 'app_routes.dart';

export 'app_routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Top-level destinations shown in the bottom navigation bar.
const _destinations = [
  NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Map'),
  NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'History'),
  NavigationDestination(
      icon: Icon(Icons.garage_outlined), selectedIcon: Icon(Icons.garage_rounded), label: 'Garage'),
];

GoRouter buildRouter({String initialLocation = AppRoutes.map}) => GoRouter(
      navigatorKey: _rootKey,
      initialLocation: initialLocation,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => _HomeShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.map, builder: (_, _) => const MapScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.history, builder: (_, _) => const HistoryScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.garage, builder: (_, _) => const GarageScreen()),
            ]),
          ],
        ),
        GoRoute(
          path: AppRoutes.vehicleNew,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const VehicleFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.fillUpNew,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const FillUpFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.vehicleEdit,
          parentNavigatorKey: _rootKey,
          builder: (_, state) => VehicleFormScreen(initial: state.extra as VehicleProfile?),
        ),
      ],
    );

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = buildRouter();
  ref.onDispose(router.dispose);
  return router;
});

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: _destinations,
      ),
    );
  }
}
