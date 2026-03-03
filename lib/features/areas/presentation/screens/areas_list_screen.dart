import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/area_provider.dart';
import '../../data/models/area_model.dart';
import '../../../customers/presentation/screens/customers_list_screen.dart';

class AreasListScreen extends ConsumerWidget {
  const AreasListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(areasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Areas'),
      ),
      body: areasAsync.when(
        data: (areas) => areas.isEmpty
            ? const Center(child: Text('No areas added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  final area = areas[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          area.areaNumber,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(area.name),
                      subtitle: Text('Area #${area.areaNumber}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _showAreaDialog(context, ref, area: area),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _confirmDelete(context, ref, area),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomersListScreen(area: area),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAreaDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAreaDialog(BuildContext context, WidgetRef ref, {Area? area}) {
    final nameController = TextEditingController(text: area?.name);
    final numberController = TextEditingController(text: area?.areaNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(area == null ? 'Add Area' : 'Edit Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Area Name', hintText: 'e.g. Downtown'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Area Number', hintText: 'e.g. 101'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                if (area == null) {
                  ref.read(areasProvider.notifier).addArea(
                        Area(name: nameController.text, areaNumber: numberController.text),
                      );
                } else {
                  ref.read(areasProvider.notifier).updateArea(
                        area.copyWith(name: nameController.text, areaNumber: numberController.text),
                      );
                }
                Navigator.pop(context);
              }
            },
            child: Text(area == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Area area) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Area?'),
        content: Text('This will delete ${area.name} and all its customers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              ref.read(areasProvider.notifier).deleteArea(area.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
