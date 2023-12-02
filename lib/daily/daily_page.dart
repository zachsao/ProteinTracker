import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/daily/food_edit.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/models/food.dart';
import 'package:protein_tracker/widgets/update_goal_dialog.dart';
import '../widgets/amount_progress.dart';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DailyPage extends StatefulWidget {
  final FoodRepository repository;
  const DailyPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();
}

class DailyState extends State<DailyPage> {
  void logEvent() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: "Daily page");
  }

  @override
  void initState() {
    logEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.repository.getFoods(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(Strings.errorGeneric),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var foods = snapshot.data!.docs
            .map((e) => (e.data()! as Food).setId(e.id))
            .toList();

        var total = foods.map((e) => e.amount).sum;
        var meals = foods.groupListsBy((element) => element.type);
        var orderedMeals = Map.fromEntries(meals.entries.toList()
          ..sort((a, b) => a.key.index.compareTo(b.key.index)));

        return Column(
          children: [
            Text(
              Strings.homePrompt,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 32),
            AmountProgress(
              total: total,
              goal: widget.repository.getDailyGoal(),
            ),
            UpdateGoalDialog(
              updateGoal: widget.repository.updateDailyGoal,
            ),
            const SizedBox(height: 32),
            buildSectionsList(orderedMeals)
          ],
        );
      },
    );
  }

  Widget buildSectionsList(Map<MealType, List<Food>> meals) {
    return Expanded(
        child: ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              MealType type = meals.keys.toList()[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [buildSection(meals[type] ?? [], type.name, context)],
              );
            }));
  }

  Widget buildSection(List<Food> foods, String header, BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Theme.of(context).colorScheme.background,
      header: Text(
        header,
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      children: foods.map((food) => buildItem(food)).toList(),
    );
  }

  Widget buildItem(Food food) {
    return Dismissible(
      key: Key(food.id!),
      onDismissed: (direction) {
        widget.repository.delete(food);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: CupertinoListTile.notched(
        title: Text(
          food.name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        additionalInfo: Text(
          "${food.amount}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundColorActivated: Theme.of(context).colorScheme.primary,
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: FoodEdit(
                    food: food, updateEntry: (food, updatedFood) async {
                      await widget.repository.updateFood(food, updatedFood);
                      if(context.mounted) Navigator.pop(context);
                    }),
              ));
        },
      ),
    );
  }
}
