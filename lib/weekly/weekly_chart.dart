import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/food.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatelessWidget {
  final List<Food> foods;

  const WeeklyChart({super.key, required this.foods});

  List<ColumnSeries<DailyTotal, String>> createChartData(BuildContext context) {
    Map<String, int> days = {
      for (var e in ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']) e: 0
    };

    List<DailyTotal> dailyTotals = [];
    Map<String, int> groupedTotals = foods
        .groupListsBy((element) => dayFromTimestamp(element.createdAt!))
        .map((timestamp, foods) =>
            MapEntry(timestamp, foods.map((e) => e.amount).toList().sum));

    days.addAll(groupedTotals);
    days.forEach((key, value) {
      dailyTotals.add(DailyTotal(key, value));
    });

    return [
      ColumnSeries<DailyTotal, String>(
          dataSource: dailyTotals,
          xValueMapper: (DailyTotal data, _) => data.day,
          yValueMapper: (DailyTotal data, _) => data.total,
          name: 'Gold',
          color: Theme.of(context).colorScheme.primary)
    ];
  }

  String dayFromTimestamp(Timestamp timestamp) {
    return DateFormat('EEE').format(timestamp.toDate()).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0),
        series: createChartData(context));
  }
}

class DailyTotal {
  final String day;
  final int total;

  DailyTotal(this.day, this.total);
}
