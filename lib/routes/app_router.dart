import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_poc/screens/camera_screen.dart';
import 'package:web_poc/screens/google_maps_screen.dart';
import 'package:web_poc/screens/location_screen.dart';
import 'package:web_poc/screens/printing_screen.dart';
import 'package:web_poc/screens/screenshot_screen.dart';

import '../screens/device_info_screen.dart';
import '../screens/home_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> routeNavigatorKey = GlobalKey();
String initialRoute = '/';

final GoRouter router = GoRouter(
  navigatorKey: routeNavigatorKey,
  initialLocation: initialRoute,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.camera.name}",
      name: AppRoutes.camera.name,
      builder: (BuildContext context, GoRouterState state) {
        return const CameraScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.deviceInfo.name}",
      name: AppRoutes.deviceInfo.name,
      builder: (BuildContext context, GoRouterState state) {
        return const DeviceInfoScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.googleMaps.name}",
      name: AppRoutes.googleMaps.name,
      builder: (BuildContext context, GoRouterState state) {
        return const GoogleMapScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.location.name}",
      name: AppRoutes.location.name,
      builder: (BuildContext context, GoRouterState state) {
        return const LocationScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.printing.name}",
      name: AppRoutes.printing.name,
      builder: (BuildContext context, GoRouterState state) {
        return const PrintingScreen();
      },
    ),
    GoRoute(
      path: "/${AppRoutes.screenshot.name}",
      name: AppRoutes.screenshot.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ScreenShotScreen();
      },
    ),
  ],
);
