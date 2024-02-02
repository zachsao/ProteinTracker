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

  const FoodDetailsScreen({Key? key, required this.food, required this.addFood})
      : super(key: key);

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late Future<FoodDetails> futureNutrients;
  final TextEditingController controller = TextEditingController();
  final TextEditingController measureController = TextEditingController();
  late num proteinPerGram;
  late List<MeasureDTO> measures;
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
      type: selectedMealType,
      selectedMeasure: selectedMeasure,
    );
    widget.addFood(food);
  }

  @override
  void initState() {
    futureNutrients = (widget.food.measures == null
            ? GetIt.I.get<FoodRepository>().getMeasures(widget.food.id!)
            : Future.sync(() => widget.food.measures!))
        .then((value) {
      measures = value;
      return GetIt.I
          .get<FoodRepository>()
          .getNutrients(widget.food.id!, value[0].weight);
    }).then((FoodDetails value) {
      if (widget.food.selectedMeasure != null) {
        selectedMeasure = widget.food.selectedMeasure;
        controller.text =
            "${(widget.food.amount / selectedMeasure!.weight / (value as Nutrients).proteins).round()}";
        proteinAmount = widget.food.amount;
        selectedMealType = widget.food.type;
      }
      return value;
    });
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
            onPressed: (selectedMeasure == null || controller.text.isEmpty)
                ? null
                : saveFood,
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
                  children: [
                    Text(
                      widget.food.name,
                      style: Theme.of(context).textTheme.headlineSmall,
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
                            label: const Text("Measure"),
                            initialSelection: widget.food.selectedMeasure,
                            controller: measureController,
                            dropdownMenuEntries:
                                measures.map((MeasureDTO measure) {
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
