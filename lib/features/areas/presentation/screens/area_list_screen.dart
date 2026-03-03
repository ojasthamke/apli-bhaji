import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/area_provider.dart';
import 'add_area_screen.dart';
import '../../customers/presentation/screens/customer_list_screen.dart';
import '../../items/presentation/screens/items_management_screen.dart';
import '../../reports/presentation/screens/reports_screen.dart';
import '../../backup/presentation/screens/settings_screen.dart';
import '../../../orders/presentation/providers/order_provider.dart';

class AreaListScreen extends ConsumerWidget {
  const AreaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(areasProvider);
    final orderRepo = ref.watch(orderRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('APLI BHAJI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Items',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ItemsManagementScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Reports',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: areasAsync.when(
        data: (areas) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Select Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            Expanded(
              child: areas.isEmpty
                  ? const Center(child: Text('No areas added. Tap + to add.'))
                  : ListView.builder(
                      itemCount: areas.length,
                      itemBuilder: (context, index) {
                        final area = areas[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F0F0F),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.emerald.withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.map_outlined, color: Colors.emerald),
                            ),
                            title: Text(
                              area.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: FutureBuilder<double>(
                              future: orderRepo.getTotalEarningsByArea(area.id!),
                              builder: (context, snapshot) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Area ID: ${area.areaNumber}'),
                                    Text(
                                      'Earnings: ₹${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                );
                              },
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onLongPress: () => _showAreaOptions(context, ref, area),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CustomerListScreen(area: area),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAreaScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAreaOptions(BuildContext context, WidgetRef ref, area) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text('Edit Area'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddAreaScreen(area: area)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Area', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              // Check if area has customers before deleting (Logic handled in repository/provider or UI)
              // For simplicity, we'll try to delete and handle the foreign key constraint error or check manually
              ref.read(areasProvider.notifier).deleteArea(area.id!);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
