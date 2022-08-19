import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class AmountProgress extends StatelessWidget {
  final int total;
  final int goal;
  const AmountProgress({Key? key, required this.total, required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GradientCircularProgressIndicator(
          value: (total/goal)*100,
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondaryContainer, Theme.of(context).colorScheme.primary]),
        ),
        Column(
          children: [
            Text(
              "$total",
              style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer),
            ),
            Text("of ${goal}g")
          ],
        )
      ],
    );
  }
}
