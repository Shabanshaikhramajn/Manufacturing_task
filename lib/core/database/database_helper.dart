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
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS component_operations');
          await db.execute('DROP TABLE IF EXISTS components');
          await db.execute('DROP TABLE IF EXISTS machines');
          await db.execute('DROP TABLE IF EXISTS customers');
          await db.execute('DROP TABLE IF EXISTS locations');
          await db.execute('DROP TABLE IF EXISTS machine_manufacturers');
          
          await createTables(db);
        }
      },
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  Future<void> createTables(Database db) async {
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
        FOREIGN KEY (machine_manufacturer_id) REFERENCES machine_manufacturers (id) ON DELETE SET NULL,
        FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE SET NULL
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
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
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
        FOREIGN KEY (component_id) REFERENCES components (id) ON DELETE CASCADE,
        FOREIGN KEY (machine_id) REFERENCES machines (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = dbInstance;
    if (db != null) {
      await db.close();
      dbInstance = null;
    }
  }
}
