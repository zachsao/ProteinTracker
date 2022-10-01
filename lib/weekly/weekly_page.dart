import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/models/weekly_stats.dart';
import 'package:protein_tracker/weekly/intake_tile.dart';
import 'package:protein_tracker/weekly/tile.dart';
import 'package:protein_tracker/weekly/weekly_chart.dart';
import '../FoodRepository.dart';
import '../models/meal.dart';
import 'package:collection/collection.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WeeklyPage extends StatefulWidget {
  final FoodRepository repository;
  const WeeklyPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeeklyState();
}

class WeeklyState extends State<WeeklyPage> {
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

        return Column(
          children: [
            Text(
              "Your weekly intake",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 250, child: WeeklyChart(foods: foods)),
            const SizedBox(
              height: 20,
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
                      backgroundColor: Color(0xFFD6FFA1),
                      textColor: Color(0xFF6AAE5F),
                      topText: "Avg.",
                      midText: "${stats.globalAvg}g",
                      bottomText: "per meal"),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Tile(
                      backgroundColor: Color(0xFFA1FFB6),
                      textColor: Color(0xFF5FAE67),
                      topText: "Streak",
                      midText: "0",
                      bottomText: "days"),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: IntakeTile(
                      backgroundColor: Color(0xFF19D083),
                      textColor: Color(0xFF367845),
                      breakfastAvg: "${stats.avgPerMeal[MealType.breakfast] ?? 0}g",
                      lunchAvg: "${stats.avgPerMeal[MealType.lunch] ?? 0}g",
                      dinnerAvg: "${stats.avgPerMeal[MealType.dinner] ?? 0}g"),
                ),
              ],
            )
          ],
        );
      },
      future: widget.repository.getWeeklyData(),
    );
  }
}
