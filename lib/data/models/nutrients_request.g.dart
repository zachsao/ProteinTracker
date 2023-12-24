// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrients_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutrientsRequest _$NutrientsRequestFromJson(Map<String, dynamic> json) =>
    NutrientsRequest(
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredients.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NutrientsRequestToJson(NutrientsRequest instance) =>
    <String, dynamic>{
      'ingredients': instance.ingredients,
    };

Ingredients _$IngredientsFromJson(Map<String, dynamic> json) => Ingredients(
      foodId: json['foodId'] as String,
    )
      ..quantity = json['quantity'] as int
      ..measureURI = json['measureURI'] as String;

Map<String, dynamic> _$IngredientsToJson(Ingredients instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'measureURI': instance.measureURI,
      'foodId': instance.foodId,
    };
