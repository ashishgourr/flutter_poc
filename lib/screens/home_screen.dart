import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.camera.name}");
              },
              child: const Text('Camera Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.deviceInfo.name}");
              },
              child: const Text('Device Info Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.googleMaps.name}");
              },
              child: const Text('Google Maps Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.location.name}");
              },
              child: const Text('Location Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.printing.name}");
              },
              child: const Text('Printing Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/${AppRoutes.screenshot.name}");
              },
              child: const Text('Screenshot Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
