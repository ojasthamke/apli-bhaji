import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../../orders/presentation/screens/create_order_screen.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider(customer.id!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Navigate to AddCustomerScreen in edit mode
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(label: 'Name', value: customer.name, icon: Icons.person),
                      const Divider(height: 24, color: Colors.grey),
                      _DetailRow(label: 'Phone', value: customer.phone, icon: Icons.phone),
                      const Divider(height: 24, color: Colors.grey),
                      _DetailRow(label: 'House No.', value: customer.houseNumber ?? 'N/A', icon: Icons.home),
                      const Divider(height: 24, color: Colors.grey),
                      _DetailRow(label: 'Address', value: customer.address ?? 'N/A', icon: Icons.location_on),
                      if (customer.notes != null && customer.notes!.isNotEmpty) ...[
                        const Divider(height: 24, color: Colors.grey),
                        _DetailRow(label: 'Notes', value: customer.notes!, icon: Icons.notes),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Order History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          ),
          ordersAsync.when(
            data: (orders) => orders.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No orders yet.')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text('Order #${order.id}'),
                            subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(order.dateTime)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${order.finalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                                Text(
                                  order.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: order.status == 'Delivered' ? Colors.green : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: orders.length,
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateOrderScreen(customer: customer),
              ),
            );
          },
          child: const Text('CREATE ORDER'),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
