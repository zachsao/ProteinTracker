import 'package:flutter/material.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeeklyState();

}

class WeeklyState extends State<WeeklyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("weekly page content"),);
  }
}