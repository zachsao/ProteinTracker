import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String? id;
  final String name;
  final int amount;
  final MealType type;
  Timestamp? createdAt;

  Food({this.id, required this.name, required this.amount, required this.type, this.createdAt});

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

  Food setId(String id) {
    this.id = id;
    return this;
  }
}

enum MealType {
  breakfast, lunch, snack, dinner,
}