import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/data/models/date_model.dart';
import 'package:protein_tracker/data/models/weekly_stats.dart';
import 'package:protein_tracker/ui/weekly/intake_tile.dart';
import 'package:protein_tracker/ui/weekly/tile.dart';
import 'package:protein_tracker/ui/weekly/weekly_chart.dart';
import 'package:provider/provider.dart';

import '../../data/auth.dart';
import '../../data/food_repository.dart';
import '../../data/models/food.dart';
import '../widgets/date_selector.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeeklyState();
}

class WeeklyState extends State<WeeklyPage> {
  final repository = GetIt.I.get<FoodRepository>();
  int streak = 0;

  void logEvent() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: "Login page");
  }

  Future<void> attemptDelete(
      Function onDeleteSuccessful, Function(String) onDeleteFailed) {
    return Auth.get().deleteUser().then((value) {
      if (value.isEmpty) {
        onDeleteSuccessful();
      } else {
        onDeleteFailed(value);
      }
    });
  }

  Future confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.deleteAccountPromptTitle),
          content: const Text(Strings.deleteAccountPromptContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                attemptDelete(() {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Account deleted"),
                    ),
                  );
                }, (String message) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 5),
                      content: Text(message),
                      action: SnackBarAction(
                          label: "Re-authenticate",
                          onPressed: () {
                            Auth.get().authenticateThenDelete((){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Account deleted"),
                                ),
                              );
                            });
                          }),
                    ),
                  );
                });
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    logEvent();
    repository.getStreak().then((value) => streak = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DateModel>(builder: (context, dateModel, _) {
      return FutureBuilder(
        builder: (_, AsyncSnapshot<WeeklyStats> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          WeeklyStats stats = snapshot.data!;

          return ListView(
            children: [
              DateSelector(
                formattedDate: dateModel.formattedWeek,
                backwardPressed: () => dateModel
                    .setDate(dateModel.date.subtract(const Duration(days: 7))),
                forwardPressed: () => dateModel
                    .setDate(dateModel.date.add(const Duration(days: 7))),
                isForwardVisible: dateModel.isBeforeThisWeek(),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                  height: 250,
                  child: WeeklyChart(
                    groupedTotals: stats.groupedTotals,
                  )),
              const SizedBox(
                height: 32,
              ),
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: Tile(
                        backgroundColor: const Color(0xFFD6FFA1),
                        textColor: const Color(0xFF6AAE5F),
                        topText: "Avg.",
                        midText: "${stats.dailyAvg}g",
                        bottomText: "per day"),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: Tile(
                        backgroundColor: const Color(0xFFA1FFB6),
                        textColor: const Color(0xFF5FAE67),
                        topText: "Streak",
                        midText: "$streak",
                        bottomText:
                            Intl.plural(streak, other: "days", one: "day")),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: IntakeTile(
                        backgroundColor: const Color(0xFF19D083),
                        textColor: const Color(0xFF367845),
                        breakfastAvg:
                            "${stats.avgPerMeal[MealType.breakfast] ?? 0}g",
                        lunchAvg: "${stats.avgPerMeal[MealType.lunch] ?? 0}g",
                        dinnerAvg:
                            "${stats.avgPerMeal[MealType.dinner] ?? 0}g"),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: OutlinedButton(
                  onPressed: () => Auth.get().signOut(),
                  child: const Text(Strings.signOut),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () => confirmDelete(),
                  child: Text(
                    Strings.deleteAccount,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
              const SizedBox(height: 32)
            ],
          );
        },
        future: repository.getWeeklyData(dateModel.date),
      );
    });
  }
}
