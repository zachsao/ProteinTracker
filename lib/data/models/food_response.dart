import 'package:json_annotation/json_annotation.dart';
import 'package:protein_tracker/data/models/food.dart';

part 'food_response.g.dart';

@JsonSerializable()
class ResponseDTO {
  final List<HintDTO> hints;

  ResponseDTO({
    required this.hints,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseDTOFromJson(json);
}

@JsonSerializable()
class HintDTO {
  final FoodDTO food;
  final List<MeasureDTO> measures;

  HintDTO({
    required this.food,
    required this.measures,
  });

  factory HintDTO.fromJson(Map<String, dynamic> json) =>
      _$HintDTOFromJson(json);

  Food toFoodModel() => Food(
        id: food.foodId,
        name: food.brand != null ? "${food.label} - ${food.brand}" : food.label,
        amount: 0,
        type: MealType.breakfast,
      )
      ..image = food.image
      ..measures = measures;
}

@JsonSerializable()
class FoodDTO {
  final String foodId;
  final String label;
  String? image;
  String? brand;

  FoodDTO({
    required this.foodId,
    required this.label,
  });

  factory FoodDTO.fromJson(Map<String, dynamic> json) =>
      _$FoodDTOFromJson(json);
}

@JsonSerializable()
class MeasureDTO {
  final String? label;
  final num weight;

  MeasureDTO({
    required this.label,
    required this.weight,
  });

  factory MeasureDTO.fromJson(Map<String, dynamic> json) =>
      _$MeasureDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MeasureDTOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeasureDTO &&
        other.weight == weight &&
        other.label == label;
  }

  @override
  int get hashCode => weight.hashCode ^ label.hashCode;
}
