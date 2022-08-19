import 'package:flutter/material.dart';

class AmountProgress extends StatelessWidget {
  final int total;
  final int goal;
  const AmountProgress({Key? key, required this.total, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox.square(
          dimension: 150.0,
          child: CircularProgressIndicator(value: total/goal.toDouble(), strokeWidth: 6,),
        ),
        Column(
          children: [
            Text(
              "$total",
              style: Theme.of(context).textTheme.headline2,
            ),
            Text("of ${goal}g")
          ],
        )
      ],
    );
  }
}
