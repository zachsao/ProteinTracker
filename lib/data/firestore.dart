import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protein_tracker/data/auth.dart';
import 'package:protein_tracker/models/food.dart';

class FirestoreService {
  FirestoreService init() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    return this;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    userRef().set(user);
  }

  Future<void> addFood(Food food) async {
    userRef()
        .collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .add(food);
  }

  Future<void> updateFood(Food food) async {
    userRef()
        .collection('foods')
        .doc(food.id)
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .update({
      "name": food.name,
      "amount": food.amount,
      "type": food.type.index
    }).then((_) {});
  }

  Future<void> updateStats(
      Food food, Food? oldFood, int goal, FirestoreOperation operation) async {
    var statsCollection = userRef().collection('stats');
    // set or update today's total amount
    int amount;
    switch (operation) {
      case FirestoreOperation.add:
        amount = food.amount;
        break;
      case FirestoreOperation.delete:
        amount = -food.amount;
        break;
      case FirestoreOperation.update:
        amount = food.amount - oldFood!.amount;
        break;
    }

    await statsCollection.doc("${today()}").set(
      {"total": FieldValue.increment(amount)},
      SetOptions(merge: true),
    );
    updateStreakCounter(goal);
  }

  void updateStreakCounter(int goal) async {
    // Get totals from last 2 days
    var statsCollection = userRef().collection('stats');
    var yesterday = today().subtract(const Duration(days: 1));
    var docs = (await statsCollection.where(FieldPath.documentId,
            whereIn: ["${today()}", "$yesterday"]).get())
        .docs;

    int todaysTotal = docs
        .firstWhere((element) => element.id == "${today()}")
        .data()['total'];

    var streakRef = statsCollection.doc("streak");
    String counterLastUpdate =
        (await streakRef.get()).data()?["lastUpdate"] ?? "";
    // if today's goal is reached
    if (todaysTotal >= goal) {
      // and the counter wasn't updated today
      if (counterLastUpdate != "${today()}") {
        // first, reset the counter if yesterday has no entry
        try {
          int yesterdaysTotal = docs
              .firstWhere((element) => element.id == "$yesterday")
              .data()['total'];

          if (yesterdaysTotal <= goal) {
            resetCounter();
          }
        } catch (exception) {
          // there was no entry yesterday, reset the counter and exit.
          resetCounter();
        }
        // then increment the counter
        await streakRef.set(
            {"count": FieldValue.increment(1), "lastUpdate": "${today()}"},
            SetOptions(merge: true));
      }
    } else {
      // we reduced the intake and fell back under the goal
      if (counterLastUpdate == "${today()}") {
        await streakRef.set(
            {"count": FieldValue.increment(-1), "lastUpdate": ""},
            SetOptions(merge: true));
      }
    }
  }

  Stream<QuerySnapshot<Food>> getFoods() {
    var todayTimestamp = Timestamp.fromDate(today());
    return userRef()
        .collection('foods')
        .where("createdAt", isGreaterThan: todayTimestamp)
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .snapshots();
  }

  Future<QuerySnapshot<Food>> foodHistory() {
    return userRef()
        .collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .get(const GetOptions(source: Source.cache));
  }

  Future<void> delete(Food food) async {
    await userRef().collection('foods').doc(food.id!).delete();
  }

  Future<QuerySnapshot<Food>> getWeeklyData() {
    DateTime weekStart = today().subtract(Duration(days: today().weekday - 1));
    return userRef()
        .collection('foods')
        .where("createdAt", isGreaterThan: Timestamp.fromDate(weekStart))
        .withConverter(
            fromFirestore: Food.fromFirestore,
            toFirestore: ((Food food, options) => food.toFirestore()))
        .get();
  }

  Future<int> getStreak() async {
    var docs = (await userRef()
            .collection("stats")
            .where(FieldPath.documentId, isEqualTo: "streak")
            .get())
        .docs;
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

  Future<void> deleteUser() async {
    userRef().delete();
  }

  void resetCounter() async {
    await userRef()
        .collection('stats')
        .doc("streak")
        .set({"count": 0, "lastUpdate": ""});
  }

  DocumentReference userRef() => FirebaseFirestore.instance
      .collection("users")
      .doc(Auth().currentUser!.uid);
}

enum FirestoreOperation { add, delete, update }
