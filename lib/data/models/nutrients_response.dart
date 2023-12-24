
import 'package:json_annotation/json_annotation.dart';

part 'nutrients_response.g.dart';

@JsonSerializable()
class NutrientsResponse {
  final TotalNutrients totalNutrients;

  NutrientsResponse({required this.totalNutrients});

  factory NutrientsResponse.fromJson(Map<String, dynamic> json) => _$NutrientsResponseFromJson(json);
}

@JsonSerializable()
class TotalNutrients {
  @JsonKey(name: "PROCNT")
  final Nutrient proteins;

  TotalNutrients({required this.proteins});

  factory TotalNutrients.fromJson(Map<String, dynamic> json) => _$TotalNutrientsFromJson(json);
}

@JsonSerializable()
class Nutrient {
  final num quantity;

  Nutrient({
    required this.quantity,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) => _$NutrientFromJson(json);
}