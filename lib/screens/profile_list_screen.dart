import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});

  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.go('/profile/profileList/subprofile/$index');
            },
            child: Card(
              child: ListTile(
                leading: Text(
                  index.toString(),
                ),
                title: Text("Profiles $index"),
              ),
            ),
          );
        }),
      ),
    );
  }
}
