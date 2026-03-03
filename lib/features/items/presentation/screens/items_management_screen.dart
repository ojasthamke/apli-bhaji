import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/item_provider.dart';
import '../../data/models/item_model.dart';

class ItemsManagementScreen extends ConsumerWidget {
  const ItemsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(itemCategoryProvider);
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Items'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Vegetable',
                  label: Text('Vegetables'),
                  icon: Icon(Icons.eco_outlined),
                ),
                ButtonSegment(
                  value: 'Medicine',
                  label: Text('Medicines'),
                  icon: Icon(Icons.medical_services_outlined),
                ),
              ],
              selected: {selectedCategory},
              onSelectionChanged: (newSelection) {
                ref.read(itemCategoryProvider.notifier).state = newSelection.first;
              },
            ),
          ),
        ),
      ),
      body: itemsAsync.when(
        data: (items) => items.isEmpty
            ? Center(child: Text('No $selectedCategory items added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            onPressed: () => _showAddEditItemScreen(context, item: item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditItemScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditItemScreen(BuildContext context, {Item? item}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditItemScreen(item: item),
      ),
    );
  }
}

class AddEditItemScreen extends ConsumerStatefulWidget {
  final Item? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _mrpController;
  late TextEditingController _unitController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
    _mrpController = TextEditingController(text: widget.item?.mrp.toString() ?? '');
    _unitController = TextEditingController(text: widget.item?.unit ?? 'kg');
    _category = widget.item?.category ?? ref.read(itemCategoryProvider);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newItem = Item(
        id: widget.item?.id,
        name: _nameController.text.trim(),
        category: _category,
        price: double.parse(_priceController.text),
        mrp: double.parse(_mrpController.text),
        unit: _unitController.text.trim(),
        isEnabled: widget.item?.isEnabled ?? true,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
      );

      if (widget.item == null) {
        ref.read(itemsProvider.notifier).addItem(newItem);
      } else {
        ref.read(itemsProvider.notifier).updateItem(newItem);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Item Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name *'),
                validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _mrpController,
                      decoration: const InputDecoration(labelText: 'MRP *'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Selling Price *'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit (e.g. kg, bundle, unit) *'),
                validator: (val) => val == null || val.isEmpty ? 'Unit required' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Radio<String>(
                    value: 'Vegetable',
                    groupValue: _category,
                    onChanged: (val) => setState(() => _category = val!),
                    activeColor: Colors.green,
                  ),
                  const Text('Vegetable'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Medicine',
                    groupValue: _category,
                    onChanged: (val) => setState(() => _category = val!),
                    activeColor: Colors.green,
                  ),
                  const Text('Medicine'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text('SAVE ITEM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
