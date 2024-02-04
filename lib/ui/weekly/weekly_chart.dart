import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyChart extends StatelessWidget {
  final Map<String, int> groupedTotals;

  const WeeklyChart({super.key, required this.groupedTotals});

  List<ColumnSeries<DailyTotal, String>> createChartData(BuildContext context) {
    Map<String, int> days = {
      for (var e in ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']) e: 0
    };

    List<DailyTotal> dailyTotals = [];

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
