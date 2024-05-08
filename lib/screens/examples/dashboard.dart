import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Reports Section"),
            const SizedBox(width: 20),
            const Text("Setting Section"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardCard(
                  icon: Icons.analytics,
                  title: 'Reports',
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                DashboardCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 1000,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(6, (index) {
                  return DashboardTile(
                    title: 'Tile $index',
                    onTap: () {},
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 200,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
