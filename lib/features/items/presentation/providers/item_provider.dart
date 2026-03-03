import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository.dart';

final itemRepositoryProvider = Provider((ref) => ItemRepository());

final itemCategoryProvider = StateProvider<String>((ref) => 'Vegetable');

final itemsProvider = StateNotifierProvider<ItemNotifier, AsyncValue<List<Item>>>((ref) {
  final category = ref.watch(itemCategoryProvider);
  return ItemNotifier(ref.watch(itemRepositoryProvider), category);
});

class ItemNotifier extends StateNotifier<AsyncValue<List<Item>>> {
  final ItemRepository _repository;
  final String _category;

  ItemNotifier(this._repository, this._category) : super(const AsyncValue.loading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getByCategory(_category);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItem(Item item) async {
    try {
      await _repository.insert(item);
      fetchItems();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await _repository.update(item);
      fetchItems();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _repository.delete(id);
      fetchItems();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleEnabled(Item item) async {
    final updatedItem = item.copyWith(isEnabled: !item.isEnabled);
    await updateItem(updatedItem);
  }
}
