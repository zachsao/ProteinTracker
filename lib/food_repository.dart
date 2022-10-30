import 'package:cloud_firestore/cloud_firestore.dart';
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
    await firestoreService.updateStats(food, goal);
  }

  void updateDailyGoal(int newGoal) async {
    prefs!.setInt('daily_goal', newGoal);
  }

  Preference<int> getDailyGoal() {
    return prefs!.getInt('daily_goal', defaultValue: 150);
  }
}