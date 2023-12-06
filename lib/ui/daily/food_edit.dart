import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/data/models/food.dart';
import 'package:protein_tracker/ui/widgets/meal_dropdown.dart';

class FoodEdit extends StatefulWidget {
  final Food food;
  final Function updateEntry;

  const FoodEdit({
    super.key,
    required this.food,
    required this.updateEntry,
  });

  @override
  State<FoodEdit> createState() => _FoodEditState();
}

class _FoodEditState extends State<FoodEdit> {
  late MealType dropdownValue;
  late TextEditingController controller;

  void Function()? onPressed;

  bool hasChanged() {
    return dropdownValue != widget.food.type ||
        int.parse(controller.text) != widget.food.amount;
  }

  void sendFood() async {
    Food newFood = Food(
        name: widget.food.name,
        amount: int.parse(controller.text),
        type: dropdownValue,
        id: widget.food.id);
    widget.updateEntry(newFood, widget.food);
  }

  @override
  void initState() {
    dropdownValue = widget.food.type;
    controller = TextEditingController(text: widget.food.amount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.food.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            buildEditRow(
              context,
              Strings.mealLabel,
              MealDropDown(
                initialValue: dropdownValue,
                onSelected: (value) => setState(() {
                  dropdownValue = value!;
                  onPressed = hasChanged() ? sendFood : null;
                })
              ),
            ),
            const SizedBox(height: 16),
            buildEditRow(context, Strings.amountLabel, buildAmountTextEdit()),
            const SizedBox(height: 16),
            CupertinoButton.filled(
                onPressed: onPressed, child: const Text(Strings.saveButton)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Row buildEditRow(BuildContext context, String label, Widget content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        content
      ],
    );
  }

  Container buildAmountTextEdit() {
    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      child: IntrinsicWidth(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          onChanged: (value) {
            setState(() {
              onPressed = hasChanged() ? sendFood : null;
            });
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(), counterText: ""),
        ),
      ),
    );
  }
}
