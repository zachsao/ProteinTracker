import 'package:flutter/material.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();

}

class DailyState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("daily page content"),);
  }
}