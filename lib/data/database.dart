import 'package:path/path.dart';
import 'package:protein_tracker/models/food.dart';
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

  Future<List<Food>> foods(String query) async {
    return (await database.query('foods', where: 'name LIKE ?', whereArgs:["$query%"]))
        .map((Map<String, dynamic> e) => Food(
            name: e['name'],
            amount: e['amount'],
            type: MealType.values[e['type']]))
        .toList();
  }
}
