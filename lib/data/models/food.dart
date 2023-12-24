import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protein_tracker/data/models/food_response.dart';

class Food {
  String? id;
  final String name;
  final int amount;
  final MealType type;
  Timestamp? createdAt;
  String? image;
  List<MeasureDTO>? measures;

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
      "createdAt": createdAt ?? Timestamp.now()
    };
  }

  Food setId(String id) {
    this.id = id;
    return this;
  }

  Food copyWith({String? id, String? name, int? amount, MealType? type, Timestamp? createdAt}) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum MealType {
  breakfast, lunch, snack, dinner,
}