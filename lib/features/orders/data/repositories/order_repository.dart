import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/order_model.dart';

class OrderRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> saveOrder(OrderModel order, List<OrderItemModel> items) async {
    final db = await dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Insert Order
      final orderId = await txn.insert('Orders', order.toMap());

      // 2. Insert Order Items with the new orderId
      for (var item in items) {
        final itemMap = item.toMap();
        itemMap['orderId'] = orderId;
        await txn.insert('OrderItems', itemMap);
      }

      return orderId;
    });
  }

  Future<List<OrderModel>> getOrdersByCustomer(int customerId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Orders',
      where: 'customerId = ?',
      whereArgs: [customerId],
      orderBy: 'dateTime DESC',
    );
    return maps.map((e) => OrderModel.fromMap(e)).toList();
  }

  Future<Map<String, dynamic>> getOrderWithItems(int orderId) async {
    final db = await dbHelper.database;

    final orderMap = await db.query('Orders', where: 'id = ?', whereArgs: [orderId]);
    final itemsMap = await db.query('OrderItems', where: 'orderId = ?', whereArgs: [orderId]);

    if (orderMap.isEmpty) return {};

    return {
      'order': OrderModel.fromMap(orderMap.first),
      'items': itemsMap.map((e) => OrderItemModel.fromMap(e)).toList(),
    };
  }

  Future<double> getTotalEarningsByArea(int areaId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(finalAmount) as total
      FROM Orders
      JOIN Customers ON Orders.customerId = Customers.id
      WHERE Customers.areaId = ?
    ''', [areaId]);

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getDailyEarnings(DateTime date) async {
    final db = await dbHelper.database;
    final dateStr = date.toIso8601String().substring(0, 10); // YYYY-MM-DD
    final result = await db.rawQuery('''
      SELECT SUM(finalAmount) as total
      FROM Orders
      WHERE dateTime LIKE ?
    ''', ['$dateStr%']);

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getAreaWiseEarnings() async {
    final db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT Areas.name, SUM(Orders.finalAmount) as total
      FROM Areas
      LEFT JOIN Customers ON Areas.id = Customers.areaId
      LEFT JOIN Orders ON Customers.id = Orders.customerId
      GROUP BY Areas.id
    ''');
  }

  Future<List<OrderModel>> getPendingOrders() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Orders',
      where: 'status = ?',
      whereArgs: ['Pending'],
      orderBy: 'dateTime DESC',
    );
    return maps.map((e) => OrderModel.fromMap(e)).toList();
  }
}
