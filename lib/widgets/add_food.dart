import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/models/food.dart';
import 'package:protein_tracker/widgets/meal_dropdown.dart';

class AddFood extends StatefulWidget {
  final Function addFood;
  const AddFood({super.key, required this.addFood});

  @override
  State<StatefulWidget> createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late MealType dropdownValue;

  bool isValid() {
    if (int.tryParse(amountController.text) == null) return false;
    return nameController.text.isNotEmpty && amountController.text.isNotEmpty;
  }

  void sendFood() async {
    Food newFood = Food(
        name: nameController.text,
        amount: int.parse(amountController.text),
        type: dropdownValue);
    widget.addFood(newFood);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    amountController = TextEditingController();
    dropdownValue = MealType.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.addFood,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          buildTextEdit(nameController, Strings.nameLabel),
          const SizedBox(height: 16),
          buildTextEdit(amountController, Strings.amountLabel,
              textInputType: TextInputType.number, maxLength: 4),
          const SizedBox(height: 16),
          MealDropDown(
            initialValue: dropdownValue,
            width: MediaQuery.of(context).size.width - 32,
            onSelected: (value) => setState(() {
              dropdownValue = value!;
            }),
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
              onPressed: isValid() ? sendFood : null,
              child: const Text(Strings.saveButton)),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  TextField buildTextEdit(TextEditingController controller, String label,
      {TextInputType? textInputType, int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      maxLength: maxLength,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          counterText: "",
          labelText: label),
    );
  }
}
