import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AmountProgress extends StatelessWidget {
  final int total;
  final StreamingSharedPreferences prefs;

  const AmountProgress({Key? key, required this.total, required this.prefs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<int>(
      builder: (_, int goal) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GradientCircularProgressIndicator(
              radius: 300,
              value: (total / goal) * 100,
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.secondaryContainer,
                Theme.of(context).colorScheme.primary
              ]),
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
      },
      preference: prefs.getInt('daily_goal', defaultValue: 150),
    );
  }
}
