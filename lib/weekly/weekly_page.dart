import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/firestore.dart';
import 'package:protein_tracker/weekly/intake_tile.dart';
import 'package:protein_tracker/weekly/tile.dart';
import 'package:protein_tracker/weekly/weekly_chart.dart';
import '../models/meal.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({Key? key}) : super(key: key);

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

        return Column(
          children: [
            Text(
              "This past week",
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
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      topText: "Avg.",
                      midText: "40g",
                      bottomText: "per meal"),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Tile(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      topText: "Streak",
                      midText: "13",
                      bottomText: "days"),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: IntakeTile(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      breakfastAvg: "40g",
                      lunchAvg: "33g",
                      dinnerAvg: "30g"),
                ),
              ],
            )
          ],
        );
      },
      future: FirestoreService().getWeeklyData(),
    );
  }
}
