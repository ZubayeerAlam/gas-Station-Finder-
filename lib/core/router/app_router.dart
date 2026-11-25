import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/along_route/presentation/along_route_screen.dart';
import '../../features/along_route/presentation/destination_search_screen.dart';
import '../../features/assistant/presentation/assistant_screen.dart';
import '../../features/garage/domain/vehicle_profile.dart';
import '../../features/garage/presentation/garage_screen.dart';
import '../../features/garage/presentation/vehicle_form_screen.dart';
import '../../features/history/presentation/fill_up_form_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/prices/presentation/alerts_screen.dart';
import '../../features/prices/presentation/report_price_screen.dart';
import '../../features/stations/domain/entities/station.dart';
import '../../features/stations/presentation/map_screen.dart';
import '../../l10n/l10n.dart';
import 'app_routes.dart';

export 'app_routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Top-level destinations shown in the bottom navigation bar.
List<NavigationDestination> _destinations(AppLocalizations l) => [
      NavigationDestination(
          icon: const Icon(Icons.map_outlined), selectedIcon: const Icon(Icons.map_rounded), label: l.navMap),
      NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long_rounded),
          label: l.navHistory),
      NavigationDestination(
          icon: const Icon(Icons.garage_outlined), selectedIcon: const Icon(Icons.garage_rounded), label: l.navGarage),
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
          path: AppRoutes.plan,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const DestinationSearchScreen(),
        ),
        GoRoute(
          path: AppRoutes.assistant,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const AssistantScreen(),
        ),
        GoRoute(
          path: AppRoutes.planRoute,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const AlongRouteScreen(),
        ),
        GoRoute(
          path: AppRoutes.fillUpNew,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const FillUpFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.reportPrice,
          parentNavigatorKey: _rootKey,
          // Needs the station; a deep link without one falls back to the map.
          redirect: (_, state) => state.extra is Station ? null : AppRoutes.map,
          builder: (_, state) => ReportPriceScreen(station: state.extra! as Station),
        ),
        GoRoute(
          path: AppRoutes.alerts,
          parentNavigatorKey: _rootKey,
          builder: (_, _) => const AlertsScreen(),
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
        destinations: _destinations(context.l10n),
      ),
    );
  }
}
