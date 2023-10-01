import 'package:flutter/material.dart';
import 'package:protein_tracker/widgets/add_food.dart';

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
  Future<void> addFood(Food newFood) async {
    widget.addFood(newFood);
  }

  Future<void> _showMyDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => AddFood(
        addFood: (food) async {
          await addFood(food);
          if (context.mounted) Navigator.pop(context);
        },
      ),
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
