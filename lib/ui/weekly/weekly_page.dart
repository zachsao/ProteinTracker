import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/data/models/date_model.dart';
import 'package:protein_tracker/data/models/weekly_stats.dart';
import 'package:protein_tracker/ui/weekly/intake_tile.dart';
import 'package:protein_tracker/ui/weekly/tile.dart';
import 'package:protein_tracker/ui/weekly/weekly_chart.dart';
import '../../data/food_repository.dart';
import '../../data/auth.dart';
import '../../data/models/food.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    logEvent();
    repository.getStreak().then((value) => streak = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DateModel>(
      builder: (context, dateModel, _) {
        return FutureBuilder(
          builder: (_, AsyncSnapshot<QuerySnapshot<Food>> snapshot) {
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

            var foods = snapshot.data!.docs.map((e) => e.data()).toList();
            WeeklyStats stats = WeeklyStats(foods);

            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your weekly intake",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(height: 250, child: WeeklyChart(foods: foods)),
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
                          dinnerAvg: "${stats.avgPerMeal[MealType.dinner] ?? 0}g"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                  child: OutlinedButton(onPressed: () => Auth.get().signOut(), child: const Text("Sign out",),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OutlinedButton(onPressed: () => Auth.get().deleteUser(), child: Text("Delete account", style: TextStyle(color: Theme.of(context).colorScheme.error),),),
                ),
                const SizedBox(height: 32,)
              ],
            );
          },
          future: repository.getWeeklyData(dateModel.date),
        );
      }
    );
  }
}
