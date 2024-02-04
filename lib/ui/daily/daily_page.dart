import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class DailyPage extends StatefulWidget {
  final FoodRepository repository;
  const DailyPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();
}

class DailyState extends State<DailyPage> {
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
          stream: widget.repository.getFoods(dateModel.date),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        dateModel.setDate(
                            dateModel.date.subtract(const Duration(days: 1)));
                      },
                    ),
                    Text(
                      dateModel.formattedDate,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: dateModel.date.isBefore(dateModel.today),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          dateModel.setDate(
                              dateModel.date.add(const Duration(days: 1)));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AmountProgress(
                  total: total,
                  goal: widget.repository.getDailyGoal(),
                ),
                TextButton(
                  onPressed: () => showDialog(context: context, builder: (context){
                    return UpdateGoalDialog(
                      updateGoal: (goal) {
                        widget.repository.updateDailyGoal(goal);
                      },
                    );
                  }),
                  child: const Text(Strings.editGoalButton),
                ),
                const SizedBox(height: 32),
                buildSectionsList(orderedMeals)
              ],
            );
          },
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
          // if food is from API, show details screen
          if (food.apiId != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodDetailsScreen(
                  food: food,
                  addFood: (updatedFood) async {
                    await widget.repository.updateFood(updatedFood, food);
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
                            await widget.repository.updateFood(food, oldFood);
                            if (context.mounted) Navigator.pop(context);
                          }),
                    ));
          }
        },
      ),
    );
  }
}