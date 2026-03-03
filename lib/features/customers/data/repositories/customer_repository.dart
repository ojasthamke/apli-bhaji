import '../../../../core/database/database_helper.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Customer customer) async {
    final db = await dbHelper.database;
    return await db.insert('Customers', customer.toMap());
  }

  Future<List<Customer>> getByArea(int areaId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Customers',
      where: 'areaId = ?',
      whereArgs: [areaId],
      orderBy: 'name ASC',
    );
    return maps.map((e) => Customer.fromMap(e)).toList();
  }

  Future<List<Customer>> searchCustomers(int areaId, String query) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Customers',
      where: 'areaId = ? AND name LIKE ?',
      whereArgs: [areaId, '%$query%'],
      orderBy: 'name ASC',
    );
    return maps.map((e) => Customer.fromMap(e)).toList();
  }

  Future<int> update(Customer customer) async {
    final db = await dbHelper.database;
    return await db.update(
      'Customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Customer?> getById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('Customers', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Customer.fromMap(maps.first);
    return null;
  }
}
