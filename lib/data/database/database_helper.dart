import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:restaurant_app/data/model/favorite/favorite_restaurant.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'restaurants.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT,
            city TEXT,
            pictureUrl TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<void> insertRestaurant(FavoriteRestaurant restaurant) async {
    final db = await database;
    await db.insert(_tableName, restaurant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavoriteRestaurant>> getFavoriteRestaurants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return FavoriteRestaurant.fromMap(maps[i]);
    });
  }

  Future<void> deleteRestaurant(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
