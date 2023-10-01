import 'package:flutter/material.dart';
import 'package:protein_tracker/models/food.dart';

class MealDropDown extends StatelessWidget {
  final MealType initialValue;
  final void Function(MealType?) onSelected;

  const MealDropDown(
      {super.key, required this.initialValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<MealType>(
        width: MediaQuery.of(context).size.width - 32,
        initialSelection: initialValue,
        dropdownMenuEntries: MealType.values.map((MealType type) {
          return DropdownMenuEntry<MealType>(value: type, label: type.name);
        }).toList(),
        onSelected: onSelected);
  }
}
