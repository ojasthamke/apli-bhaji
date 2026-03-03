import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('apli_bhaji.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Areas Table
    await db.execute('''
      CREATE TABLE Areas (
        id $idType,
        name $textType,
        photoPath $textTypeNullable,
        areaNumber $textType,
        createdAt $textType
      )
    ''');

    // Customers Table
    await db.execute('''
      CREATE TABLE Customers (
        id $idType,
        name $textType,
        phone $textType,
        address $textTypeNullable,
        houseNumber $textTypeNullable,
        areaId $integerType,
        locationLink $textTypeNullable,
        photoPath $textTypeNullable,
        notes $textTypeNullable,
        createdAt $textType,
        FOREIGN KEY (areaId) REFERENCES Areas (id) ON DELETE RESTRICT
      )
    ''');

    // Items Table
    await db.execute('''
      CREATE TABLE Items (
        id $idType,
        name $textType,
        category $textType,
        price $realType,
        mrp $realType,
        unit $textType,
        isEnabled $boolType,
        createdAt $textType
      )
    ''');

    // Orders Table
    await db.execute('''
      CREATE TABLE Orders (
        id $idType,
        customerId $integerType,
        totalAmount $realType,
        discount $realType,
        finalAmount $realType,
        status $textType,
        dateTime $textType,
        updatedAt $textType,
        FOREIGN KEY (customerId) REFERENCES Customers (id)
      )
    ''');

    // OrderItems Table
    await db.execute('''
      CREATE TABLE OrderItems (
        id $idType,
        orderId $integerType,
        itemId $integerType,
        quantity $realType,
        price $realType,
        mrp $realType,
        total $realType,
        FOREIGN KEY (orderId) REFERENCES Orders (id),
        FOREIGN KEY (itemId) REFERENCES Items (id)
      )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_customers_areaId ON Customers (areaId)');
    await db.execute('CREATE INDEX idx_orders_customerId ON Orders (customerId)');
    await db.execute('CREATE INDEX idx_orderitems_orderId ON OrderItems (orderId)');
    await db.execute('CREATE INDEX idx_orders_dateTime ON Orders (dateTime)');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
