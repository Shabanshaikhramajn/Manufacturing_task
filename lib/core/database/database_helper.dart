import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper.internal();
  static final DatabaseHelper instance = DatabaseHelper.internal();

  static Database? dbInstance;

  Future<Database> get database async {
    if (dbInstance != null) return dbInstance!;
    dbInstance = await initDatabase();
    return dbInstance!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'manufacturing_mes.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE machine_manufacturers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            latitude REAL,
            longitude REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE machines (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            machine_name TEXT NOT NULL,
            machine_serial_number TEXT,
            machine_manufacturer_id INTEGER,
            machine_model TEXT,
            year_of_manufacture INTEGER,
            type_of_machine INTEGER,
            location_id INTEGER,
            FOREIGN KEY (machine_manufacturer_id) REFERENCES machine_manufacturers (id),
            FOREIGN KEY (location_id) REFERENCES locations (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE components (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER,
            component_name TEXT NOT NULL,
            part_no TEXT,
            ecn TEXT,
            FOREIGN KEY (customer_id) REFERENCES customers (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE component_operations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            component_id INTEGER,
            machine_id INTEGER,
            operation_code TEXT,
            operation_name TEXT,
            operation_description TEXT,
            operation_type INTEGER,
            FOREIGN KEY (component_id) REFERENCES components (id),
            FOREIGN KEY (machine_id) REFERENCES machines (id)
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = dbInstance;
    if (db != null) {
      await db.close();
      dbInstance = null;
    }
  }
}
