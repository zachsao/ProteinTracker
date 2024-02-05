import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/ui/daily/food_edit.dart';
import 'package:protein_tracker/data/models/date_model.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/data/models/food.dart';
import 'package:protein_tracker/ui/food_details/food_details_screen.dart';
import 'package:protein_tracker/ui/widgets/update_goal_dialog.dart';
import '../widgets/amount_progress.dart';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

import '../widgets/date_selector.dart';

class DailyPage extends StatefulWidget {

  const DailyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();
}

class DailyState extends State<DailyPage> {
  final repository = GetIt.I.get<FoodRepository>();
  late TextEditingController editGoalController;

  void logEvent() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: "Daily page");
  }

  @override
  void initState() {
    editGoalController = TextEditingController();
    logEvent();
    super.initState();
  }

  @override
  void dispose() {
    editGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DateModel>(
      builder: (context, dateModel, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: repository.getFoods(dateModel.date),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            var foods =
                snapshot.data!.docs.map((e) => e.data()! as Food).toList();

            var total = foods.map((e) => e.amount).sum;
            var meals = foods.groupListsBy((element) => element.type);
            var orderedMeals = Map.fromEntries(meals.entries.toList()
              ..sort((a, b) => a.key.index.compareTo(b.key.index)));

            return Column(
              children: [
                const SizedBox(height: 16),
                DateSelector(
                  formattedDate: dateModel.formattedDate,
                  backwardPressed: () => dateModel.setDate(
                      dateModel.date.subtract(const Duration(days: 1))),
                  forwardPressed: () => dateModel.setDate(
                      dateModel.date.add(const Duration(days: 1))),
                  isForwardVisible: dateModel.date.isBefore(dateModel.today),
                ),
                const SizedBox(height: 16),
                AmountProgress(
                  total: total,
                  goal: repository.getDailyGoal(),
                ),
                TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateGoalDialog(
                          updateGoal: (goal) {
                            repository.updateDailyGoal(goal);
                          },
                        );
                      }),
                  child: const Text(Strings.editGoalButton),
                ),
                const SizedBox(height: 32),
                buildSectionsList(orderedMeals, dateModel.date)
              ],
            );
          },
        );
      },
    );
  }

  Widget buildSectionsList(Map<MealType, List<Food>> meals, DateTime date) {
    return Expanded(
        child: ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              MealType type = meals.keys.toList()[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSection(meals[type] ?? [], type.name, context, date)
                ],
              );
            }));
  }

  Widget buildSection(
      List<Food> foods, String header, BuildContext context, DateTime date) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Theme.of(context).colorScheme.background,
      header: Text(
        header,
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      children: foods.map((food) => buildItem(food, date)).toList(),
    );
  }

  Widget buildItem(Food food, DateTime date) {
    return Dismissible(
      key: Key(food.id!),
      onDismissed: (direction) {
        repository.delete(food, date);
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
          // if food is from API, show details screen
          if (food.apiId != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodDetailsScreen(
                  food: food,
                  addFood: (updatedFood) async {
                    await repository.updateFood(updatedFood, food, date);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
            );
          } else {
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
                          food: food,
                          updateEntry: (food, oldFood) async {
                            await repository
                                .updateFood(food, oldFood, date);
                            if (context.mounted) Navigator.pop(context);
                          }),
                    ));
          }
        },
      ),
    );
  }
}
