import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/customer_repository.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository());

final searchQueryProvider = StateProvider.family<String, int>((ref, areaId) => '');

final customersProvider = StateNotifierProvider.family<CustomerNotifier, AsyncValue<List<Customer>>, int>((ref, areaId) {
  final query = ref.watch(searchQueryProvider(areaId));
  return CustomerNotifier(ref.watch(customerRepositoryProvider), areaId, query);
});

class CustomerNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final CustomerRepository _repository;
  final int _areaId;
  final String _query;

  CustomerNotifier(this._repository, this._areaId, this._query) : super(const AsyncValue.loading()) {
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    state = const AsyncValue.loading();
    try {
      List<Customer> customers;
      if (_query.isEmpty) {
        customers = await _repository.getByArea(_areaId);
      } else {
        customers = await _repository.searchCustomers(_areaId, _query);
      }
      state = AsyncValue.data(customers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await _repository.insert(customer);
      fetchCustomers();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _repository.update(customer);
      fetchCustomers();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _repository.delete(id);
      fetchCustomers();
    } catch (e) {
      // Handle error
    }
  }
}
