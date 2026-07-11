import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class GenericLocalDataSource<T> {
  final String tableName;
  final Map<String, dynamic> Function(T item) toMap;
  final T Function(Map<String, dynamic> map) fromMap;
  final String idColumn;
  final int Function(T item) getId;

  GenericLocalDataSource({
    required this.tableName,
    required this.toMap,
    required this.fromMap,
    required this.getId,
    this.idColumn = 'id',
  });

  Future<Database> get database async => DatabaseHelper.instance.database;

  Future<List<T>> getAll() async {
    final db = await database;
    final rows = await db.query(tableName);
    return rows.map(fromMap).toList();
  }

  Future<T?> getById(int id) async {
    final db = await database;
    final rows = await db.query(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return fromMap(rows.first);
  }

  Future<int> insert(T item) async {
    final db = await database;
    final map = Map<String, dynamic>.from(toMap(item));
    map.remove(idColumn);
    return db.insert(tableName, map);
  }

  Future<int> update(T item) async {
    final db = await database;
    final map = Map<String, dynamic>.from(toMap(item));
    map.remove(idColumn);
    return db.update(
      tableName,
      map,
      where: '$idColumn = ?',
      whereArgs: [getId(item)],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }
}
