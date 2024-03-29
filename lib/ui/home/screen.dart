import 'package:flutter/material.dart';
import 'package:protein_tracker/ui/daily/daily_page.dart';
import 'package:protein_tracker/ui/weekly/weekly_page.dart';

class Screen {
  final IconData icon;
  final String label;
  final Widget content;

  Screen({required this.icon, required this.label, required this.content});

  static List<Screen> screens() {
      return [
        Screen(icon: Icons.home_outlined, label: "Daily", content: DailyPage()),
        Screen(icon: Icons.list_alt, label: "Weekly", content: WeeklyPage())
      ];
  }
}