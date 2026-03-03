import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/item_provider.dart';
import '../../data/models/item_model.dart';

class ItemsListScreen extends ConsumerWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    final selectedCategory = ref.watch(itemCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Items'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Vegetable', label: Text('Vegetables'), icon: Icon(Icons.eco_outlined)),
                ButtonSegment(value: 'Medicine', label: Text('Medicines'), icon: Icon(Icons.medical_services_outlined)),
              ],
              selected: {selectedCategory},
              onSelectionChanged: (newSelection) {
                ref.read(itemCategoryProvider.notifier).state = newSelection.first;
              },
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: Colors.white,
                selectedForegroundColor: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: itemsAsync.when(
        data: (items) => items.isEmpty
            ? Center(child: Text('No $selectedCategory items added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('Price: ₹${item.price} / ${item.unit} | MRP: ₹${item.mrp}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: item.isEnabled,
                            onChanged: (val) => ref.read(itemsProvider.notifier).toggleEnabled(item),
                            activeColor: Colors.green,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _showItemDialog(context, ref, selectedCategory, item: item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(context, ref, selectedCategory),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showItemDialog(BuildContext context, WidgetRef ref, String category, {Item? item}) {
    final nameController = TextEditingController(text: item?.name);
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final mrpController = TextEditingController(text: item?.mrp.toString() ?? '');
    final unitController = TextEditingController(text: item?.unit ?? 'kg');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Add $category' : 'Edit $category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: mrpController,
                      decoration: const InputDecoration(labelText: 'MRP'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unit (e.g. kg, unit, bundle)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                final newItem = Item(
                  id: item?.id,
                  name: nameController.text,
                  category: category,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  mrp: double.tryParse(mrpController.text) ?? 0.0,
                  unit: unitController.text,
                  isEnabled: item?.isEnabled ?? true,
                );

                if (item == null) {
                  ref.read(itemsProvider.notifier).addItem(newItem);
                } else {
                  ref.read(itemsProvider.notifier).updateItem(newItem);
                }
                Navigator.pop(context);
              }
            },
            child: Text(item == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
