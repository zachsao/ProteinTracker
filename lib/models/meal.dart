import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final List<Food> items;

  Meal(this.items);
}

class Food {
  final String name;
  final int amount;
  final MealType type;

  Food({required this.name, required this.amount, required this.type});

  factory Food.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Food(
      name: data?['name'],
      amount: data?['amount'],
      type: MealType.values[data?['type']]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "amount": amount,
      "type": type.index
    };
  }
}

enum MealType {
  breakfast, lunch, dinner, snack
}