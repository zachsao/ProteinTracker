import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/data/models/food.dart';
import 'package:protein_tracker/ui/food_details/food_details_screen.dart';
import 'package:protein_tracker/ui/widgets/meal_dropdown.dart';
import 'package:protein_tracker/ui/widgets/search_food.dart';

class AddFood extends StatefulWidget {
  final Function addFood;
  const AddFood({super.key, required this.addFood});

  @override
  State<StatefulWidget> createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  MealType? dropdownValue;
  late List<Food> history = [];
  String? amountErrorText;

  bool isValid() {
    if (int.tryParse(amountController.text) == null) return false;
    return nameController.text.isNotEmpty &&
        int.parse(amountController.text) >= 0 &&
        dropdownValue != null;
  }

  void sendFood() async {
    Food newFood = Food(
        name: nameController.text.trim(),
        amount: int.parse(amountController.text),
        type: dropdownValue!);
    widget.addFood(newFood);
  }

  Future<void> fetchHistory() async {
    var cache = (await GetIt.I.get<FoodRepository>().foodHistory());
    setState(() {
      history = cache;
    });
  }

  @override
  void initState() {
    fetchHistory();
    super.initState();
    nameController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        title: const Text(Strings.addFood),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextEdit(nameController, Strings.nameLabel),
              const SizedBox(height: 16),
              buildTextEdit(amountController, Strings.amountLabel,
                  textInputType: TextInputType.number,
                  maxLength: 4,
                  errorText: amountErrorText),
              const SizedBox(height: 16),
              MealDropDown(
                initialValue: dropdownValue,
                width: MediaQuery.of(context).size.width - 32,
                onSelected: (value) => setState(() {
                  dropdownValue = value!;
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SearchFood(onTap: (food) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FoodDetailsScreen(food: food, addFood: widget.addFood,)
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isValid() ? sendFood : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      child: const Text(Strings.saveButton),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "History",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primaryContainer),
                        child: ListTile(
                          title: Text(history[index].name),
                          subtitle: Text("${history[index].amount}g"),
                          trailing: IconButton.filled(
                            onPressed: () {
                              setState(() {
                                nameController.text = history[index].name;
                                amountController.text = "${history[index].amount}";
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextEdit(TextEditingController controller, String label,
      {TextInputType? textInputType, int? maxLength, String? errorText}) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      maxLength: maxLength,
      onChanged: (value) {
        setState(() {
          if (amountController.text.isEmpty) {
            amountErrorText = null;
            return;
          }
          if (int.tryParse(amountController.text) == null) {
            amountErrorText = Strings.errorAmountNotInteger;
            return;
          }
          if (int.parse(amountController.text) < 0) {
            amountErrorText = Strings.errorAmountNegative;
          } else {
            amountErrorText = null;
          }
        });
      },
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          counterText: "",
          labelText: label,
          errorText: errorText),
    );
  }
}
