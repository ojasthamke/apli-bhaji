import '../../../../core/database/database_helper.dart';
import '../models/area_model.dart';

class AreaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Area area) async {
    final db = await dbHelper.database;
    return await db.insert('Areas', area.toMap());
  }

  Future<List<Area>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('Areas', orderBy: 'name ASC');
    return maps.map((e) => Area.fromMap(e)).toList();
  }

  Future<int> update(Area area) async {
    final db = await dbHelper.database;
    return await db.update(
      'Areas',
      area.toMap(),
      where: 'id = ?',
      whereArgs: [area.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Areas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
