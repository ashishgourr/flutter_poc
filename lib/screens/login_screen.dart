import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_poc/routes/app_routes.dart';
import 'package:web_poc/utils/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                AuthService.authenticated = true;

                context.go("/${AppRoutes.home.name}");
              },
              child: const Text("Login")),
        ));
  }
}
