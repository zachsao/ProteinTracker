import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateModel extends ChangeNotifier {
  DateTime date;
  DateTime get today => DateUtils.dateOnly(DateTime.now());

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

  Timestamp get timestamp => Timestamp.fromDate(date);
}