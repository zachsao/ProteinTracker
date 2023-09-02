import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:protein_tracker/firestore.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'models/meal.dart';

class FoodRepository {
  final FirestoreService firestoreService = FirestoreService();
  StreamingSharedPreferences? prefs;

  FoodRepository() {
    initPrefs();
  }

  void initPrefs() async {
    prefs = await StreamingSharedPreferences.instance;
  }
  
  Stream<QuerySnapshot<Food>> getFoods() {
    return firestoreService.getFoods();
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
    await firestoreService.updateStats(food, null, goal, FirestoreOperation.add);
    
    await FirebaseAnalytics.instance.logEvent(name: "Add food", parameters: {
      "name": food.name,
      "meal": food.type.name,
      "amount": food.amount
    });
  }

  Future<void> updateFood(Food newFood, Food oldFood) async {
    await firestoreService.updateFood(newFood);
    int goal = getDailyGoal().getValue();
    await firestoreService.updateStats(newFood, oldFood,goal, FirestoreOperation.add);
    await FirebaseAnalytics.instance.logEvent(name: "Update food", parameters: {
      "new name": newFood.name,
      "new meal": newFood.type.name,
      "new amount": newFood.amount
    });
  }

  Future<void> delete(Food food) async {
    await firestoreService.delete(food);
    int goal = getDailyGoal().getValue();
    await firestoreService.updateStats(food, null, goal, FirestoreOperation.delete);
    await FirebaseAnalytics.instance.logEvent(name: "delete food");
  }

  void updateDailyGoal(int newGoal) async {
    prefs!.setInt('daily_goal', newGoal);
    await FirebaseAnalytics.instance.logEvent(name: "Update goal", parameters: {
      "newGoal": newGoal
    });
  }

  Preference<int> getDailyGoal() {
    return prefs!.getInt('daily_goal', defaultValue: 150);
  }
}