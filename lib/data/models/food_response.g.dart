// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseDTO _$ResponseDTOFromJson(Map<String, dynamic> json) => ResponseDTO(
      hints: (json['hints'] as List<dynamic>)
          .map((e) => HintDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseDTOToJson(ResponseDTO instance) =>
    <String, dynamic>{
      'hints': instance.hints,
    };

HintDTO _$HintDTOFromJson(Map<String, dynamic> json) => HintDTO(
      food: FoodDTO.fromJson(json['food'] as Map<String, dynamic>),
      measures: (json['measures'] as List<dynamic>)
          .map((e) => MeasureDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HintDTOToJson(HintDTO instance) => <String, dynamic>{
      'food': instance.food,
      'measures': instance.measures,
    };

FoodDTO _$FoodDTOFromJson(Map<String, dynamic> json) => FoodDTO(
      foodId: json['foodId'] as String,
      label: json['label'] as String,
    )
      ..image = json['image'] as String?
      ..brand = json['brand'] as String?;

Map<String, dynamic> _$FoodDTOToJson(FoodDTO instance) => <String, dynamic>{
      'foodId': instance.foodId,
      'label': instance.label,
      'image': instance.image,
      'brand': instance.brand,
    };

MeasureDTO _$MeasureDTOFromJson(Map<String, dynamic> json) => MeasureDTO(
      label: json['label'] as String?,
      weight: json['weight'] as num,
    );

Map<String, dynamic> _$MeasureDTOToJson(MeasureDTO instance) =>
    <String, dynamic>{
      'label': instance.label,
      'weight': instance.weight,
    };
