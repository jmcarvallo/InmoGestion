import 'package:sqflite/sqflite.dart';
import '../../../../core/db/app_database.dart';
import '../models/property.dart';

class PropertyDao {
  Future<int> insert(Property property) async {
    final db = await AppDatabase().database;
    return db.insert('properties', property.toMap());
  }

  Future<int> update(Property property) async {
    final db = await AppDatabase().database;
    return db.update(
      'properties',
      property.toMap(),
      where: 'id = ?',
      whereArgs: [property.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase().database;
    return db.delete('properties', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Property>> getAll() async {
    final db = await AppDatabase().database;
    final rows = await db.query('properties', orderBy: 'id DESC');
    return rows.map((e) => Property.fromMap(e)).toList();
  }

  Future<List<Property>> search(String q) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      'properties',
      where: 'title LIKE ? OR address LIKE ?',
      whereArgs: ['%$q%', '%$q%'],
      orderBy: 'id DESC',
    );
    return rows.map((e) => Property.fromMap(e)).toList();
  }

  Future<Property?> getById(int id) async {
    final db = await AppDatabase().database;
    final rows = await db.query('properties', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Property.fromMap(rows.first);
  }
}
