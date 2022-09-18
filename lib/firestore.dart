import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protein_tracker/auth.dart';
import 'package:protein_tracker/models/meal.dart';

class FirestoreService {
  DocumentReference userRef = FirebaseFirestore.instance
      .collection("users")
      .doc(Auth().currentUser!.uid);

  Future<void> saveUser(Map<String, dynamic> user) async {
    userRef.set(user);
  }

  Future<void> addFood(Food food) async {
    userRef
        .collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .add(food);
  }

  Stream<QuerySnapshot<Food>> getFoods() {
    var todayTimestamp = Timestamp.fromDate(today());
    return userRef
        .collection('foods')
        .where("createdAt", isGreaterThan: todayTimestamp)
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .snapshots();
  }

  Future<QuerySnapshot<Food>> getWeeklyData() {
    DateTime weekStart = today().subtract(Duration(days: today().weekday - 1));
    return userRef
        .collection('foods')
        .where("createdAt", isGreaterThan: Timestamp.fromDate(weekStart))
        .withConverter(
            fromFirestore: Food.fromFirestore,
            toFirestore: ((Food food, options) => food.toFirestore()))
        .get();
  }

  DateTime today() {
    var today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }
}
