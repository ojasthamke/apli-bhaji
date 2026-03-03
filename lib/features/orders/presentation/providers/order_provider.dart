import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../../items/data/models/item_model.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final customerOrdersProvider = FutureProvider.family<List<OrderModel>, int>((ref, customerId) {
  return ref.watch(orderRepositoryProvider).getOrdersByCustomer(customerId);
});

// State for building a new order
class OrderItemState {
  final Item item;
  double quantity;

  OrderItemState({required this.item, this.quantity = 0});

  double get total => item.price * quantity;
  double get mrpTotal => item.mrp * quantity;
}

class NewOrderNotifier extends StateNotifier<List<OrderItemState>> {
  NewOrderNotifier() : super([]);

  void updateQuantity(Item item, double qty) {
    final index = state.indexWhere((element) => element.item.id == item.id);
    if (index != -1) {
      if (qty <= 0) {
        state = [...state]..removeAt(index);
      } else {
        state = [...state]..[index].quantity = qty;
      }
    } else if (qty > 0) {
      state = [...state, OrderItemState(item: item, quantity: qty)];
    }
  }

  void clear() {
    state = [];
  }

  double get totalSellingPrice => state.fold(0, (sum, item) => sum + item.total);
  double get totalMrp => state.fold(0, (sum, item) => sum + item.mrpTotal);
}

final newOrderProvider = StateNotifierProvider<NewOrderNotifier, List<OrderItemState>>((ref) {
  return NewOrderNotifier();
});
