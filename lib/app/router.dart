import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/trip/route_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/history/history_screen.dart';
import '../shell/shell_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/route',
      builder: (context, state) => const RouteScreen(),
    ),
  ],
);
