import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/firestore.dart';
import 'package:protein_tracker/models/meal.dart';
import 'package:protein_tracker/widgets/update_goal_dialog.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../widgets/amount_progress.dart';
import 'package:collection/collection.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();
}

class DailyState extends State<DailyPage> {
  StreamingSharedPreferences? prefs;
  void updateDailyGoal(int newGoal) async {
    prefs?.setInt('daily_goal',newGoal);
  }

  void initPrefs() async {
    prefs = await StreamingSharedPreferences.instance;
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getFoods(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var foods = snapshot.data!.docs.map((e) => e.data()! as Food).toList();
          var total = foods.map((e) => e.amount).sum;
          var meals = foods.groupListsBy((element) => element.type);
    
          return Column(
            children: [
              Text(
                "What did you eat today ?",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 32),
              AmountProgress(total: total, prefs: prefs!,),
              UpdateGoalDialog(updateGoal: updateDailyGoal,),
              const SizedBox(height: 32),
              buildSectionsList(meals)
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  buildSection(meals[type] ?? [], context)
                ],
              ),
            );
          }),
    );
  }
}

Widget buildSection(List<Food> foods, BuildContext context) {
  return Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: foods
            .map((food) => Row(
                  children: [
                    Text(
                      food.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      "${food.amount}g",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    )
                  ],
                ))
            .toList(),
      ),
    ),
  );
}