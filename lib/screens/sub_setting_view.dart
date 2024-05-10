import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubSettingsView extends StatefulWidget {
  const SubSettingsView({super.key});

  @override
  State<SubSettingsView> createState() => _SubSettingsViewState();
}

class _SubSettingsViewState extends State<SubSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.go('/settings/subSetting/item/$index');
              },
              child: Card(
                child: ListTile(
                  leading: Text(
                    index.toString(),
                  ),
                  title: Text("Settings no. $index"),
                ),
              ),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }
}
