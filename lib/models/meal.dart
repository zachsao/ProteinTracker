import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String name;
  final int amount;
  final MealType type;
  Timestamp? createdAt;

  Food({required this.name, required this.amount, required this.type, this.createdAt});

  factory Food.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Food(
      name: data?['name'],
      amount: data?['amount'],
      type: MealType.values[data?['type']],
      createdAt: data?["createdAt"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "amount": amount,
      "type": type.index,
      "createdAt": Timestamp.now()
    };
  }
}

enum MealType {
  breakfast, lunch, dinner, snack
}