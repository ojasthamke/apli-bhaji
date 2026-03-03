import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../../orders/data/repositories/order_repository.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderRepo = ref.watch(orderRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Earnings Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Daily Earnings
            FutureBuilder<double>(
              future: orderRepo.getDailyEarnings(DateTime.now()),
              builder: (context, snapshot) {
                return _ReportCard(
                  title: 'Today\'s Earnings',
                  amount: snapshot.data ?? 0.0,
                  icon: Icons.today,
                  color: Colors.emerald,
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Area-wise Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Area-wise Earnings
            FutureBuilder<List<Map<String, dynamic>>>(
              future: orderRepo.getAreaWiseEarnings(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final areas = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.map, color: Colors.emerald),
                        title: Text(area['name'] ?? 'Unknown Area'),
                        trailing: Text(
                          '₹${(area['total'] as num?)?.toDouble().toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Pending Collections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Pending Orders Summary
            FutureBuilder<double>(
              future: _calculatePendingTotal(orderRepo),
              builder: (context, snapshot) {
                return _ReportCard(
                  title: 'Total Outstanding',
                  amount: snapshot.data ?? 0.0,
                  icon: Icons.account_balance_wallet_outlined,
                  color: Colors.orange,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<double> _calculatePendingTotal(OrderRepository repo) async {
    final pending = await repo.getPendingOrders();
    return pending.fold(0, (sum, order) => sum + order.finalAmount);
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _ReportCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
