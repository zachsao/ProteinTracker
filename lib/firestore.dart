import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protein_tracker/models/meal.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(Map<String, dynamic> user, String? uid) async {
    _firestore.collection("users").doc(uid).set(user);
  }

  Future<void> addFood(Food food) async {
    _firestore
        .collection("foods")
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .add(food);
  }

  Stream<QuerySnapshot<Food>> getFoods() {
    return _firestore
        .collection("foods")
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: ((Food food, options) => food.toFirestore()),
        )
        .snapshots();
  }
}
