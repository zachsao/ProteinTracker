import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/data/firestore.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'models/food.dart';

class FoodRepository {
  final FirestoreService firestoreService = GetIt.I.get();
  StreamingSharedPreferences? prefs;

  FoodRepository() {
    initPrefs();
  }

  void initPrefs() async {
    prefs = await StreamingSharedPreferences.instance;
  }

  Stream<QuerySnapshot<Food>> getFoods(DateTime date) {
    return firestoreService.getFoods(date);
  }


  Future<List<Food>> foodHistory() {
    return firestoreService
        .foodHistory()
        .then((snapshot) {
          var history = snapshot.docs.map((doc) => doc.data()).toList();
          // history sorted by most recent
          history.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          // if multiple foods have the same name, we want to keep the most recent one
          var historyMap = Map.fromEntries(history.map((e) => MapEntry(e.name, e)));
          return historyMap.values.toList();
        });
  }

  Future<QuerySnapshot<Food>> getWeeklyData() {
    return firestoreService.getWeeklyData();
  }

  Future<int> getStreak() async {
    return await firestoreService.getStreak();
  }

  Future<void> addFood(Food food) async {
    await firestoreService.addFood(food);

    int goal = getDailyGoal().getValue();
    await firestoreService.updateStats(
        food, null, goal, FirestoreOperation.add);

    await FirebaseAnalytics.instance.logEvent(name: "Add_food", parameters: {
      "name": food.name,
      "meal": food.type.name,
      "amount": food.amount
    });
  }

  Future<void> updateFood(Food newFood, Food oldFood) async {
    await firestoreService.updateFood(newFood);
    int goal = getDailyGoal().getValue();
    await firestoreService.updateStats(
        newFood, oldFood, goal, FirestoreOperation.update);
    await FirebaseAnalytics.instance.logEvent(name: "Update_food", parameters: {
      "new name": newFood.name,
      "new meal": newFood.type.name,
      "new amount": newFood.amount
    });
  }

  Future<void> delete(Food food) async {
    await firestoreService.delete(food);
    int goal = getDailyGoal().getValue();
    await firestoreService.updateStats(
        food, null, goal, FirestoreOperation.delete);
    await FirebaseAnalytics.instance.logEvent(name: "delete_food");
  }

  void updateDailyGoal(int newGoal) async {
    prefs!.setInt('daily_goal', newGoal);
    await FirebaseAnalytics.instance
        .logEvent(name: "Update_goal", parameters: {"newGoal": newGoal});
  }

  Preference<int> getDailyGoal() {
    return prefs!.getInt('daily_goal', defaultValue: 150);
  }
}