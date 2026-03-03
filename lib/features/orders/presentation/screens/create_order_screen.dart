import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../../items/presentation/providers/item_provider.dart';
import '../../items/data/models/item_model.dart';
import '../../../customers/data/models/customer_model.dart';
import '../models/order_model.dart';
import '../../../../services/pdf_service.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  final Customer customer;

  const CreateOrderScreen({super.key, required this.customer});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final _discountController = TextEditingController(text: '0');
  String _status = 'Delivered';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newOrderProvider.notifier).clear());
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _saveOrder() async {
    final selectedItems = ref.read(newOrderProvider);
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    final totalAmount = ref.read(newOrderProvider.notifier).totalSellingPrice;
    final discount = double.tryParse(_discountController.text) ?? 0.0;
    final finalAmount = totalAmount - discount;

    final order = OrderModel(
      customerId: widget.customer.id!,
      totalAmount: totalAmount,
      discount: discount,
      finalAmount: finalAmount,
      status: _status,
      dateTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final List<OrderItemModel> items = selectedItems.map((si) => OrderItemModel(
      orderId: 0, // Will be set in transaction
      itemId: si.item.id!,
      quantity: si.quantity,
      price: si.item.price,
      mrp: si.item.mrp,
      total: si.total,
    )).toList();

    try {
      final orderId = await ref.read(orderRepositoryProvider).saveOrder(order, items);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order saved successfully!')),
      );

      // Refresh customer orders
      ref.invalidate(customerOrdersProvider(widget.customer.id!));

      // Generate PDF logic here (Service will be implemented next)
      // await PdfService.generateAndShareInvoice(order.copyWith(id: orderId), items, widget.customer);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsProvider);
    final orderItems = ref.watch(newOrderProvider);
    final totalSelling = ref.watch(newOrderProvider.notifier).totalSellingPrice;
    final totalMrp = ref.watch(newOrderProvider.notifier).totalMrp;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(widget.customer.phone, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(DateFormat('dd MMM, hh:mm a').format(DateTime.now())),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                final enabledItems = items.where((i) => i.isEnabled).toList();
                return ListView.builder(
                  itemCount: enabledItems.length,
                  itemBuilder: (context, index) {
                    final item = enabledItems[index];
                    final currentQty = orderItems.firstWhere((element) => element.item.id == item.id, orElse: () => OrderItemState(item: item)).quantity;

                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('₹${item.price} / ${item.unit}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                              onPressed: () => ref.read(newOrderProvider.notifier).updateQuantity(item, currentQty - 1),
                            ),
                            Text('$currentQty', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => ref.read(newOrderProvider.notifier).updateQuantity(item, currentQty + 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          _buildSummary(totalSelling, totalMrp),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveOrder,
          child: const Text('SAVE & GENERATE PDF'),
        ),
      ),
    );
  }

  Widget _buildSummary(double totalSelling, double totalMrp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MRP Total:'),
              Text('₹${totalMrp.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Selling Total:'),
              Text('₹${totalSelling.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Text('Discount (₹):')),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  onChanged: (val) => setState(() {}),
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status:'),
              DropdownButton<String>(
                value: _status,
                items: ['Delivered', 'Pending', 'Cancelled'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _status = val!),
                underline: const SizedBox(),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Final Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '₹${(totalSelling - (double.tryParse(_discountController.text) ?? 0)).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
