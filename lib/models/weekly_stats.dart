import 'meal.dart';
import 'package:collection/collection.dart';

class WeeklyStats {
  int globalAvg = 0;
  int streak = 0;
  Map<MealType, int> avgPerMeal =
      MealType.values.asMap().map((key, value) => MapEntry(value, 0));

  WeeklyStats(List<Food> foods) {
    if (foods.isNotEmpty) {
      globalAvg = foods.map((e) => e.amount).toList().average.round();
      avgPerMeal = groupBy(foods, (Food e) => e.type).map((key, value) =>
          MapEntry(key, value.map((e) => e.amount).average.round()));
    }
  }
}
