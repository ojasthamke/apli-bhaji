import '../../../../core/database/database_helper.dart';
import '../models/item_model.dart';

class ItemRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Item item) async {
    final db = await dbHelper.database;
    return await db.insert('Items', item.toMap());
  }

  Future<List<Item>> getByCategory(String category) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Items',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return maps.map((e) => Item.fromMap(e)).toList();
  }

  Future<int> update(Item item) async {
    final db = await dbHelper.database;
    return await db.update(
      'Items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
