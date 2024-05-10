import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_poc/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Profile",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 12,
            ),
            MaterialButton(
              color: Colors.redAccent,
              onPressed: () {
                context.pushNamed(AppRoutes.profileList.name);
              },
              child: const Text(
                "Navigate To profile's list",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
