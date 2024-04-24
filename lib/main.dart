import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:web_poc/screens/device_info_screen.dart';
import 'package:web_poc/screens/home_screen.dart';
import 'package:web_poc/screens/location_screen.dart';
import 'package:web_poc/screens/printing_screen.dart';
import 'package:web_poc/screens/screenshot_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/google_maps_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });

  final cameras = await availableCameras();

  // if (kIsWeb) {
  //   html.window.onContextMenu.listen((event) {
  //     event.preventDefault();
  //   });
  // }

  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({
    super.key,
    required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web POC ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/camera': (context) => CameraScreen(cameras: cameras),
        '/device-info': (context) => const DeviceInfoScreen(),
        '/google-maps': (context) => const GoogleMapScreen(),
        '/location': (context) => const LocationScreen(),
        '/printing': (context) => const PrintingScreen(),
        '/screenshot': (context) => const ScreenShotScreen(),
      },
      initialRoute: '/',
    );
  }
}
