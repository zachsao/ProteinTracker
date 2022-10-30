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
        .add(food)
        .then((_) {
    });
  }

  Future<void> updateStats(Food food, int goal) async {
    print("zsao updating stats");
    var statsCollection = userRef.collection('stats');
    // set or update today's total amount
    await statsCollection.doc("${today()}").set(
      {"total": FieldValue.increment(food.amount)},
      SetOptions(merge: true),
    );
    updateStreakCounter(goal);
  }

  void updateStreakCounter(int goal) async {
    // Get totals from last 2 days
    var statsCollection = userRef.collection('stats');
    var yesterday = today().subtract(const Duration(days: 1));
    var docs = (await statsCollection.where(FieldPath.documentId,
            whereIn: ["${today()}", "$yesterday"]).get())
        .docs;

    int todaysTotal = docs
        .firstWhere((element) => element.id == "${today()}")
        .data()['total'];
    int yesterdaysTotal = docs
            .firstWhere((element) => element.id == "$yesterday")
            .data()['total'] ??
        0;

    // if today's goal is reached
    if (todaysTotal >= goal) {
      var streakRef = statsCollection.doc("streak");
      String counterLastUpdate = (await streakRef.get()).data()?["lastUpdate"] ?? "";
      // counter wasn't updated today
      if (counterLastUpdate != "${today()}") {
        // and yesterdays's goal is reached => increment steak by 1
        if (yesterdaysTotal >= goal) {
          await streakRef.set(
              {"count": FieldValue.increment(1), "lastUpdate": "${today()}"},
              SetOptions(merge: true));
        }
        // Otherwise reset counter
        else {
          await streakRef.set({"count": 0, "lastUpdate": "${today()}"});
        }
      }
    }
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

  Future<int> getStreak() async {
    var docs = (await userRef.collection("stats").where(FieldPath.documentId, isEqualTo: "streak").get()).docs;
    if (docs.isEmpty) {
      return 0;
    } else {
      return docs.first.data()["count"];
    }
  }

  DateTime today() {
    var today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }
}
