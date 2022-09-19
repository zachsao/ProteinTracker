import 'package:flutter/material.dart';

class IntakeTile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String breakfastAvg;
  final String lunchAvg;
  final String dinnerAvg;

  const IntakeTile(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      required this.breakfastAvg,
      required this.lunchAvg,
      required this.dinnerAvg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Highest average intake:",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: textColor)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Breakfast",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: textColor)),
                Text(
                  breakfastAvg,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lunch",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: textColor)),
                Text(
                  lunchAvg,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dinner",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: textColor)),
                Text(
                  dinnerAvg,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
