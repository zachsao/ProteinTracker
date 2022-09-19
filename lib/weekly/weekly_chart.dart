import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import '../models/meal.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatelessWidget {
  final List<Food> foods;

  const WeeklyChart({super.key, required this.foods});

  List<charts.Series<DailyTotal, String>> _createChartData(BuildContext context) {
    Map<String, int> days = { for (var e in ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']) e : 0 };

    List<DailyTotal> dailyTotals = [];
    Map<String, int> groupedTotals = foods
        .groupListsBy((element) => dayFromTimestamp(element.createdAt!))
        .map((timestamp, foods) =>
            MapEntry(timestamp, foods.map((e) => e.amount).toList().sum));

    days.addAll(groupedTotals);
    days.forEach((key, value) {dailyTotals.add(DailyTotal(key, value)); });
    

    return [
      charts.Series<DailyTotal, String>(
        id: 'Totals',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).colorScheme.primary),
        domainFn: (DailyTotal totals, _) => totals.day,
        measureFn: (DailyTotal totals, _) => totals.total,
        data: dailyTotals,
      )
    ];
  }

  String dayFromTimestamp(Timestamp timestamp) {
    return DateFormat('EEE').format(timestamp.toDate()).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createChartData(context),
      animate: true,
    );
  }
}

class DailyTotal {
  final String day;
  final int total;

  DailyTotal(this.day, this.total);
}
