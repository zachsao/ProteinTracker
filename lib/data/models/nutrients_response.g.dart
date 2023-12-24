// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrients_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutrientsResponse _$NutrientsResponseFromJson(Map<String, dynamic> json) =>
    NutrientsResponse(
      totalNutrients: TotalNutrients.fromJson(
          json['totalNutrients'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NutrientsResponseToJson(NutrientsResponse instance) =>
    <String, dynamic>{
      'totalNutrients': instance.totalNutrients,
    };

TotalNutrients _$TotalNutrientsFromJson(Map<String, dynamic> json) =>
    TotalNutrients(
      proteins: Nutrient.fromJson(json['PROCNT'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TotalNutrientsToJson(TotalNutrients instance) =>
    <String, dynamic>{
      'PROCNT': instance.proteins,
    };

Nutrient _$NutrientFromJson(Map<String, dynamic> json) => Nutrient(
      quantity: json['quantity'] as num,
    );

Map<String, dynamic> _$NutrientToJson(Nutrient instance) => <String, dynamic>{
      'quantity': instance.quantity,
    };
