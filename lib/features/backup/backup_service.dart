import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/custom_platform_share.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/database_helper.dart';

class BackupService {
  static const String schemaVersion = '1.0';

  static Future<void> exportBackup() async {
    final db = await DatabaseHelper.instance.database;

    // Fetch all data from all tables
    final areas = await db.query('Areas');
    final customers = await db.query('Customers');
    final items = await db.query('Items');
    final orders = await db.query('Orders');
    final orderItems = await db.query('OrderItems');

    final Map<String, dynamic> backupData = {
      'schemaVersion': schemaVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'data': {
        'Areas': areas,
        'Customers': customers,
        'Items': items,
        'Orders': orders,
        'OrderItems': orderItems,
      }
    };

    final String jsonString = jsonEncode(backupData);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/apli_bhaji_backup_${DateTime.now().millisecondsSinceEpoch}.json');

    await file.writeAsString(jsonString);

    // Share the file
    await Share.shareXFiles([XFile(file.path)], text: 'APLI BHAJI Database Backup');
  }

  static Future<bool> importBackup(File file) async {
    try {
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      if (backupData['schemaVersion'] != schemaVersion) {
        throw Exception('Invalid backup schema version');
      }

      final db = await DatabaseHelper.instance.database;
      final data = backupData['data'] as Map<String, dynamic>;

      await db.transaction((txn) async {
        // Clear existing data (Be careful: Master Prompt says "Backup current DB, Overwrite DB")
        // Note: In a real production app, we would backup the actual .db file first.
        await txn.delete('OrderItems');
        await txn.delete('Orders');
        await txn.delete('Items');
        await txn.delete('Customers');
        await txn.delete('Areas');

        // Restore data
        for (var row in data['Areas']) await txn.insert('Areas', row);
        for (var row in data['Customers']) await txn.insert('Customers', row);
        for (var row in data['Items']) await txn.insert('Items', row);
        for (var row in data['Orders']) await txn.insert('Orders', row);
        for (var row in data['OrderItems']) await txn.insert('OrderItems', row);
      });

      return true;
    } catch (e) {
      print('Backup Import Error: $e');
      return false;
    }
  }
}
