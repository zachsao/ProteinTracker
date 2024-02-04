import 'package:cloud_firestore/cloud_firestore.dart';

import 'food.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class WeeklyStats {
  int dailyAvg = 0;
  int streak = 0;
  Map<MealType, int> avgPerMeal =
      MealType.values.asMap().map((key, value) => MapEntry(value, 0));
  Map<String, int> groupedTotals = {};

  WeeklyStats(List<Food> foods) {
    if (foods.isNotEmpty) {
      var foodsPerDay = foods.groupListsBy((e) => e.type).map((key, value) =>
          MapEntry(
              key,
              value.groupListsBy((e) => e.createdAt!.toDate().day).map(
                  (key, value) =>
                      MapEntry(key, value.map((e) => e.amount).sum))));

      avgPerMeal = foodsPerDay.map((key, value) =>
          MapEntry(key, (value.values.isEmpty) ? 0 : value.values.average.round()));

      var dailyAmounts = <int, int>{};
      for (var map in foodsPerDay.values) {
        for (var entry in map.entries) {
          dailyAmounts[entry.key] = (dailyAmounts[entry.key] ?? 0) + entry.value;
        }
      }
      dailyAvg = dailyAmounts.values.average.round();

      groupedTotals = foods
          .groupListsBy((element) => dayFromTimestamp(element.createdAt!))
          .map((timestamp, foods) =>
          MapEntry(timestamp, foods.map((e) => e.amount).toList().sum));
    }
  }

  String dayFromTimestamp(Timestamp timestamp) {
    return DateFormat('EEE').format(timestamp.toDate()).toUpperCase();
  }
}
