
import 'package:flutter/material.dart';
import 'package:protein_tracker/models/meal.dart';

class FoodDialogContent extends StatefulWidget {
  final Function upsertFood;
  final Food? food;
  const FoodDialogContent({
    Key? key,
    required this.upsertFood,
    this.food,
  }) : super(key: key);

  @override
  State<FoodDialogContent> createState() => _FoodDialogContent();
}

class _FoodDialogContent extends State<FoodDialogContent> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  late MealType dropdownValue;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food?.name ?? "");
    _amountController = TextEditingController(text: widget.food?.amount.toString() ?? "");
    dropdownValue = widget.food?.type ?? MealType.values.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void onTypeChanged(MealType? value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  void sendFood() async {
    Food newFood = Food(
        name: _nameController.text,
        amount: int.parse(_amountController.text),
        type: dropdownValue,
        id: widget.food?.id);
    widget.upsertFood(newFood, widget.food);
    _nameController.clear();
    _amountController.clear();
    dropdownValue = MealType.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text('Add an item',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: "Name",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: "Protein amount (g)",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                StatefulBuilder(builder: (context, dropdownState) {
                  return DropdownButtonFormField<MealType>(
                      isExpanded: true,
                      value: dropdownValue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      items: MealType.values.map((MealType type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (MealType? value) {
                        dropdownState(() {
                          dropdownValue = value!;
                        });
                      });
                })
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                sendFood();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }
}
