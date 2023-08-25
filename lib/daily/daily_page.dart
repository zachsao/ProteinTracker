import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/food_repository.dart';
import 'package:protein_tracker/models/meal.dart';
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
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var foods = snapshot.data!.docs.map((e) => (e.data()! as Food).setId(e.id)).toList();
        var total = foods.map((e) => e.amount).sum;
        var meals = foods.groupListsBy((element) => element.type);
        var orderedMeals = Map.fromEntries(meals.entries.toList()
          ..sort((a, b) => a.key.index.compareTo(b.key.index)));

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

  Widget buildSection(List<Food> foods, BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: foods
              .mapIndexed((index, food) => sectionItem(
                  context, food, index == foods.length - 1))
              .toList(),
        ),
      ),
    );
  }

  Widget sectionItem(
      BuildContext context, Food food, bool isLast) {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    var tapPosition;

    void _storePosition(TapDownDetails details) {
      tapPosition = details.globalPosition;
    }

    return Column(
      children: [
        GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () {
            showMenu(
                context: context,
                position: RelativeRect.fromRect(
                    tapPosition &
                        const Size(40, 40), // smaller rect, the touch area
                    Offset.zero &
                        overlay!.semanticBounds
                            .size // Bigger rect, the entire screen
                    ),
                items: [
                  PopupMenuItem(
                    textStyle:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    child: Row(
                      children: [
                        const Text("Delete"),
                        const Spacer(),
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        )
                      ],
                    ),
                    onTap: () => widget.repository.delete(food),
                  )
                ]);
          },
          child: Row(
            children: [
              Text(
                food.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              const Spacer(),
              Text(
                "${food.amount}g",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              )
            ],
          ),
        ),
        if (!isLast) const Divider()
      ],
    );
  }
}
