import 'package:flutter/material.dart';
import 'package:protein_tracker/widgets/food_dialog_content.dart';

import '../models/food.dart';

class PeachyFab extends StatefulWidget {
  final Function addFood;
  const PeachyFab({
    Key? key,
    required this.addFood,
  }) : super(key: key);

  @override
  State<PeachyFab> createState() => _PeachyFabState();
}

class _PeachyFabState extends State<PeachyFab> {

  void addFood(Food newFood, Food? oldFood) {
    widget.addFood(newFood);
  }

  Future<void> _showMyDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return FoodDialogContent(upsertFood: addFood, food: null,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () => _showMyDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Image(
            image: AssetImage("images/peach.png"),
          ),
        ),
      ),
    );
  }
}
