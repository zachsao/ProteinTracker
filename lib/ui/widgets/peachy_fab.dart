import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/data/models/date_model.dart';
import 'package:protein_tracker/ui/widgets/add_food.dart';
import 'package:provider/provider.dart';

import '../../data/models/food.dart';

class PeachyFab extends StatefulWidget {
  const PeachyFab({
    Key? key,
  }) : super(key: key);

  @override
  State<PeachyFab> createState() => _PeachyFabState();
}

class _PeachyFabState extends State<PeachyFab> {

  void goToAddFood(BuildContext context) {
    DateModel dateModel = Provider.of<DateModel>(context, listen: false);
    Timestamp createdAt = dateModel.timestamp;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFood(
          addFood: (food) async {
            await GetIt.I.get<FoodRepository>().addFood(food.copyWith(createdAt: createdAt), dateModel.date);
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
