import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protein_tracker/data/models/food_response.dart';

class Food {
  String? id;
  final String name;
  final int amount;
  final MealType type;
  Timestamp? createdAt;
  String? image;
  MeasureDTO? selectedMeasure;
  List<MeasureDTO>? measures;

  Food({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
    this.createdAt,
  });

  factory Food.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Food(
      id: data?['id'] ?? snapshot.id,
      name: data?['name'],
      amount: data?['amount'],
      type: MealType.values[data?['type']],
      createdAt: data?["createdAt"],
    )..selectedMeasure = data?['selectedMeasure'] != null
        ? MeasureDTO.fromJson(data?['selectedMeasure'])
        : null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "name": name,
      "amount": amount,
      "type": type.index,
      "createdAt": createdAt ?? Timestamp.now(),
      if (selectedMeasure != null) "selectedMeasure": selectedMeasure!.toJson(),
    };
  }

  Food copyWith(
      {String? id,
      String? name,
      int? amount,
      MealType? type,
      Timestamp? createdAt,
      MeasureDTO? selectedMeasure}) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    )..measures = measures
    ..selectedMeasure = selectedMeasure ?? this.selectedMeasure;
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, amount: $amount, type: $type, createdAt: $createdAt, image: $image, selectedMeasure: $selectedMeasure, measures: $measures}';
  }
}

enum MealType {
  breakfast,
  lunch,
  snack,
  dinner,
}
