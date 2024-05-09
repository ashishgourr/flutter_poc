import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_poc/screens/camera_screen.dart';
import 'package:web_poc/screens/google_maps_screen.dart';
import 'package:web_poc/screens/home_screen.dart';
import 'package:web_poc/screens/location_screen.dart';
import 'package:web_poc/screens/login_screen.dart';
import 'package:web_poc/screens/printing_screen.dart';
import 'package:web_poc/screens/screenshot_screen.dart';
import 'package:web_poc/utils/auth_service.dart';

import '../screens/device_info_screen.dart';
import '../screens/error_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> routeNavigatorKey = GlobalKey();
String initialRoute = '/';

class AppRouter {
  late final GoRouter router = GoRouter(
    navigatorKey: routeNavigatorKey,
    initialLocation: initialRoute,
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error?.message ?? ""),
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.home.name}",
        name: AppRoutes.home.name,
        builder: (BuildContext context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.camera.name}",
        name: AppRoutes.camera.name,
        builder: (BuildContext context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.deviceInfo.name}",
        // redirect: (context, state) => _redirect(context, state),
        name: AppRoutes.deviceInfo.name,
        builder: (BuildContext context, state) => const DeviceInfoScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.googleMaps.name}",
        // redirect: (context, state) => _redirect(context, state),
        name: AppRoutes.googleMaps.name,
        builder: (BuildContext context, state) => const GoogleMapScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.location.name}/:name",
        // redirect: (context, state) => _redirect(context, state),
        name: AppRoutes.location.name,
        builder: (context, state) {
          return LocationScreen(name: state.pathParameters['name']!);
        },
      ),
      GoRoute(
        path: "/${AppRoutes.printing.name}",
        name: AppRoutes.printing.name,
        builder: (BuildContext context, state) => const PrintingScreen(),
      ),
      GoRoute(
        path: "/${AppRoutes.screenshot.name}",
        name: AppRoutes.screenshot.name,
        builder: (BuildContext context, state) => const ScreenShotScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = AuthService.authenticated;
      if (!isAuthenticated) {
        return '/';
      } else {
        return null;
      }
    },
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    return AuthService.authenticated ? null : state.namedLocation("/");
  }
}
