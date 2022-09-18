import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/firestore.dart';
import 'package:protein_tracker/weekly/weekly_chart.dart';
import '../models/meal.dart';

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
            SizedBox(height: 250, child: WeeklyChart(foods: foods))
          ],
        );
      },
      future: FirestoreService().getWeeklyData(),
    );
  }
}
