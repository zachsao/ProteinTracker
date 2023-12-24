
import 'package:json_annotation/json_annotation.dart';

part 'nutrients_request.g.dart';

@JsonSerializable()
class NutrientsRequest {
    final List<Ingredients> ingredients;

    NutrientsRequest({required this.ingredients});

    Map<String, dynamic> toJson() => _$NutrientsRequestToJson(this);
}

@JsonSerializable()
class Ingredients {
    int quantity = 1;
    String measureURI = "http://www.edamam.com/ontologies/edamam.owl#Measure_gram";
    final String foodId;

    Ingredients({
        required this.foodId,
    });

    factory Ingredients.fromJson(Map<String, dynamic> json) => _$IngredientsFromJson(json);

    Map<String, dynamic> toJson() => _$IngredientsToJson(this);
}