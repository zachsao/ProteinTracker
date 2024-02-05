import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateModel extends ChangeNotifier {
  DateTime date;
  DateTime get today => DateUtils.dateOnly(DateTime.now());
  Timestamp get timestamp => Timestamp.fromDate(date);

  DateModel(this.date);

  void setDate(DateTime date) {
    this.date = date;
    notifyListeners();
  }

  String get formattedDate {
    if (date == today) {
      return 'Today';
    } else {
      return DateFormat('EEEE, d MMM.').format(date);
    }
  }

  String get formattedWeek {
    DateTime start = date.subtract(Duration(days: date.weekday - 1));
    DateTime end = start.add(const Duration(days: 6));
    return '${DateFormat('d MMM.').format(start)} - ${DateFormat('d MMM.').format(end)}';
  }

  bool isBeforeThisWeek() {
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return date.isBefore(startOfWeek);
  }
}