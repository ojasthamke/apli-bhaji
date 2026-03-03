import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_provider.dart';
import '../../data/models/customer_model.dart';
import '../../../areas/data/models/area_model.dart';

class CustomersListScreen extends ConsumerWidget {
  final Area area;

  const CustomersListScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider(area.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers in ${area.name}'),
      ),
      body: customersAsync.when(
        data: (customers) => customers.isEmpty
            ? const Center(child: Text('No customers in this area.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      title: Text(customer.name),
                      subtitle: Text('Ph: ${customer.phone}\nHouse: ${customer.houseNumber}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _showCustomerDialog(context, ref, customer: customer),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _confirmDelete(context, ref, customer),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Navigate to Customer Details / Create Order
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCustomerDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomerDialog(BuildContext context, WidgetRef ref, {Customer? customer}) {
    final nameController = TextEditingController(text: customer?.name);
    final phoneController = TextEditingController(text: customer?.phone);
    final addressController = TextEditingController(text: customer?.address);
    final houseController = TextEditingController(text: customer?.houseNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: houseController,
                decoration: const InputDecoration(labelText: 'House Number'),
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
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                if (customer == null) {
                  ref.read(customersProvider(area.id!).notifier).addCustomer(
                        Customer(
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          houseNumber: houseController.text,
                          areaId: area.id!,
                        ),
                      );
                } else {
                  ref.read(customersProvider(area.id!).notifier).updateCustomer(
                        customer.copyWith(
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          houseNumber: houseController.text,
                        ),
                      );
                }
                Navigator.pop(context);
              }
            },
            child: Text(customer == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer?'),
        content: Text('This will delete ${customer.name}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              ref.read(customersProvider(area.id!).notifier).deleteCustomer(customer.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
