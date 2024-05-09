import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });

  // if (kIsWeb) {
  //   html.window.onContextMenu.listen((event) {
  //     event.preventDefault();
  //   });
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Web POC ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
