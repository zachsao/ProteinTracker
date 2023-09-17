import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/models/weekly_stats.dart';
import 'package:protein_tracker/weekly/intake_tile.dart';
import 'package:protein_tracker/weekly/tile.dart';
import 'package:protein_tracker/weekly/weekly_chart.dart';
import '../data/food_repository.dart';
import '../data/auth.dart';
import '../models/food.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WeeklyPage extends StatefulWidget {
  final FoodRepository repository;
  const WeeklyPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeeklyState();
}

class WeeklyState extends State<WeeklyPage> {
  int streak = 0;

  void logEvent() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: "Login page");
  }

  @override
  void initState() {
    logEvent();
    widget.repository.getStreak().then((value) => streak = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: OutlinedButton(onPressed: () => Auth().signOut(), child: const Text("Sign out",),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: OutlinedButton(onPressed: () => Auth().deleteUser(), child: Text("Delete account", style: TextStyle(color: Theme.of(context).colorScheme.error),),),
            ),
            const SizedBox(height: 32,)
          ],
        );
      },
      future: widget.repository.getWeeklyData(),
    );
  }
}
