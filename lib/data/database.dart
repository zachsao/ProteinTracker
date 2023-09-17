import 'package:path/path.dart';
import 'package:protein_tracker/models/meal.dart';
import 'package:sqflite/sqflite.dart';

class FoodDatabase {
  late Database database;

  Future<FoodDatabase> init() async {
    String path = await getDatabasesPath();
    database = await openDatabase(
      join(path, 'food_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE foods(name TEXT PRIMARY KEY, amount INTEGER, type INTEGER)',
        );
      },
      version: 3,
    );
    return this;
  }

  Future<void> insert(Food food) async {
    await database.insert(
      'foods',
      {"name": food.name, "amount": food.amount, "type": food.type.index},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
