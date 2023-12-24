import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/data/models/food.dart';
import 'package:protein_tracker/data/models/food_response.dart';
import 'package:protein_tracker/ui/food_details/food_details.dart';
import 'package:protein_tracker/ui/widgets/meal_dropdown.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Food food;
  final Function addFood;

  const FoodDetailsScreen({Key? key, required this.food, required this.addFood}) : super(key: key);

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late Future<FoodDetails> futureNutrients;
  late TextEditingController controller;
  late num proteinPerGram;
  MealType selectedMealType = MealType.breakfast;
  MeasureDTO? selectedMeasure;
  int proteinAmount = 0;

  void updateAmount() {
    num quantity = num.tryParse(controller.text) ?? 0;
    proteinAmount = selectedMeasure != null
        ? (quantity * selectedMeasure!.weight * proteinPerGram).toInt()
        : 0;
  }

  void saveFood() async {
    Food food = widget.food.copyWith(
      amount: proteinAmount,
      type: selectedMealType
    );
    widget.addFood(food);
  }

  @override
  void initState() {
    controller = TextEditingController();
    futureNutrients = GetIt.I.get<FoodRepository>().getNutrients(
          widget.food.id!,
          widget.food.measures![0].weight,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: (selectedMeasure == null || controller.text.isEmpty) ? null : saveFood,
            child: const Text(Strings.saveButton),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureNutrients,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data is Error) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("images/network_error.png",
                        width: 100, height: 100),
                    const Text(Strings.errorGeneric),
                  ],
                );
              }

              Nutrients nutrients = snapshot.data as Nutrients;
              proteinPerGram = nutrients.proteins;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.food.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            maxLength: 4,
                            onChanged: (value) {
                              setState(() {
                                updateAmount();
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                              labelText: "Quantity",
                              errorText: null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownMenu<MeasureDTO>(
                            hintText: "Measure",
                            dropdownMenuEntries:
                                widget.food.measures!.map((MeasureDTO measure) {
                              return DropdownMenuEntry<MeasureDTO>(
                                value: measure,
                                label: measure.label!,
                              );
                            }).toList(),
                            onSelected: (choice) {
                              setState(() {
                                selectedMeasure = choice;
                                updateAmount();
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Meal",
                            style: Theme.of(context).textTheme.titleLarge),
                        MealDropDown(
                            initialValue: selectedMealType,
                            onSelected: (value) {
                              setState(() {
                                selectedMealType = value!;
                              });
                            }),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Protein: ",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text("${proteinAmount}g",
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
