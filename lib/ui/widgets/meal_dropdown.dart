import 'package:flutter/material.dart';
import 'package:protein_tracker/data/models/food.dart';

class MealDropDown extends StatelessWidget {
  final MealType? initialValue;
  final void Function(MealType?) onSelected;
  final double? width;

  const MealDropDown(
      {super.key, required this.onSelected, this.width, this.initialValue});

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
