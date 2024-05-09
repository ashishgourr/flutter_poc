import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_poc/screens/camera_screen.dart';
import 'package:web_poc/screens/google_maps_screen.dart';
import 'package:web_poc/screens/location_screen.dart';
import 'package:web_poc/screens/printing_screen.dart';
import 'package:web_poc/screens/screenshot_screen.dart';

import '../screens/device_info_screen.dart';
import '../screens/error_screen.dart';
import '../screens/home_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> routeNavigatorKey = GlobalKey();
String initialRoute = '/';

final GoRouter router = GoRouter(
  navigatorKey: routeNavigatorKey,
  initialLocation: initialRoute,
  errorBuilder: (context, state) =>
      ErrorScreen(message: state.error?.message ?? ""),
  routes: [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        },
        routes: [
          GoRoute(
            path: AppRoutes.camera.name,
            name: AppRoutes.camera.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: CameraScreen());
            },
          ),
          GoRoute(
            path: AppRoutes.deviceInfo.name,
            name: AppRoutes.deviceInfo.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: DeviceInfoScreen());
            },
          ),
          GoRoute(
            path: AppRoutes.googleMaps.name,
            name: AppRoutes.googleMaps.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: GoogleMapScreen());
            },
          ),
          GoRoute(
            path: AppRoutes.location.name,
            name: AppRoutes.location.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: LocationScreen());
            },
          ),
          GoRoute(
            path: AppRoutes.printing.name,
            name: AppRoutes.printing.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: PrintingScreen());
            },
          ),
          GoRoute(
            path: AppRoutes.screenshot.name,
            name: AppRoutes.screenshot.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ScreenShotScreen());
            },
          ),
        ]),
  ],
);
