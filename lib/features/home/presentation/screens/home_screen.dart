import 'package:flutter/material.dart';
import '../../../../features/areas/presentation/screens/areas_list_screen.dart';
import '../../../../features/items/presentation/screens/items_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APLI BHAJI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _HomeCard(
              title: 'Areas',
              icon: Icons.map_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AreasListScreen()),
              ),
            ),
            _HomeCard(
              title: 'Items',
              icon: Icons.inventory_2_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ItemsListScreen()),
              ),
            ),
            _HomeCard(
              title: 'Reports',
              icon: Icons.bar_chart_outlined,
              onTap: () {
                // TODO: Navigate to Reports
              },
            ),
            _HomeCard(
              title: 'Settings',
              icon: Icons.settings_outlined,
              onTap: () {
                // TODO: Navigate to Settings
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
