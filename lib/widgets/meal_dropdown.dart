import 'package:flutter/material.dart';
import 'package:protein_tracker/models/food.dart';

class MealDropDown extends StatelessWidget {
  final MealType initialValue;
  final void Function(MealType?) onSelected;
  final double? width;

  const MealDropDown(
      {super.key, required this.initialValue, required this.onSelected, this.width});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<MealType>(
        width: width,
        initialSelection: initialValue,
        dropdownMenuEntries: MealType.values.map((MealType type) {
          return DropdownMenuEntry<MealType>(value: type, label: type.name);
        }).toList(),
        onSelected: onSelected);
  }
}
