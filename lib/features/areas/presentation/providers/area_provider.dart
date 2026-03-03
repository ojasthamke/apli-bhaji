import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/area_model.dart';
import '../../data/repositories/area_repository.dart';

final areaRepositoryProvider = Provider((ref) => AreaRepository());

final areasProvider = StateNotifierProvider<AreaNotifier, AsyncValue<List<Area>>>((ref) {
  return AreaNotifier(ref.watch(areaRepositoryProvider));
});

class AreaNotifier extends StateNotifier<AsyncValue<List<Area>>> {
  final AreaRepository _repository;

  AreaNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchAreas();
  }

  Future<void> fetchAreas() async {
    state = const AsyncValue.loading();
    try {
      final areas = await _repository.getAll();
      state = AsyncValue.data(areas);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addArea(Area area) async {
    try {
      await _repository.insert(area);
      fetchAreas();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateArea(Area area) async {
    try {
      await _repository.update(area);
      fetchAreas();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteArea(int id) async {
    try {
      await _repository.delete(id);
      fetchAreas();
    } catch (e) {
      // Handle error
    }
  }
}
