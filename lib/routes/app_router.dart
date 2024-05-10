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
import '../screens/profile_screen.dart';
import '../screens/nested_navigation_wrapper.dart';
import '../screens/settings_view.dart';
import '../screens/profile_list_screen.dart';
import '../screens/sub_setting_view.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> routeNavigatorKey = GlobalKey();
  static String initialRoute = '/';
  static final shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  static final GoRouter router = GoRouter(
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NestedNavigationWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Profile
          StatefulShellBranch(
            navigatorKey: shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/${AppRoutes.profile.name}",
                name: AppRoutes.profile.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.profileList.name,
                    name: AppRoutes.profileList.name,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const ProfileListScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path:
                        "${AppRoutes.profileList.name}/subprofile/:profileId", // Use ":itemId" for dynamic value
                    name: "subProfileList",
                    builder: (BuildContext context, GoRouterState state) {
                      final itemId =
                          int.tryParse(state.pathParameters['profileId']!) ?? 0;

                      return Center(
                        child: Text(
                          'Navigated to profile $itemId',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Settings
          StatefulShellBranch(
            navigatorKey: shellNavigatorSettings,
            routes: <RouteBase>[
              GoRoute(
                path: "/${AppRoutes.settings.name}",
                name: AppRoutes.settings.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsView(),
                routes: [
                  GoRoute(
                    path: AppRoutes.subSetting.name,
                    name: AppRoutes.subSetting.name,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const SubSettingsView(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  // Define sub-route for specific item with dynamic parameter
                  GoRoute(
                    path:
                        "${AppRoutes.subSetting.name}/item/:itemId", // Use ":itemId" for dynamic value
                    name: "subSettingItem",
                    builder: (BuildContext context, GoRouterState state) {
                      final itemId =
                          int.tryParse(state.pathParameters['itemId']!) ?? 0;

                      return Center(
                        child: Text(
                          'Navigated to item $itemId',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
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
