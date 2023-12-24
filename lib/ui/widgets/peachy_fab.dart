import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/data/models/date_model.dart';
import 'package:protein_tracker/ui/widgets/add_food.dart';
import 'package:provider/provider.dart';

import '../../data/models/food.dart';

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

  void goToAddFood(BuildContext context) {
    Timestamp createdAt =
        Provider.of<DateModel>(context, listen: false).timestamp;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFood(
          addFood: (food) async {
            await addFood(food.copyWith(createdAt: createdAt));
            if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        fullscreenDialog: true,
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
          onPressed: () => goToAddFood(context),
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
