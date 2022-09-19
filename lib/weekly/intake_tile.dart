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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Highest average intake:",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: textColor)),
            const SizedBox(height: 16),
            MealRow(title: "Breakfast", textColor: textColor, avg: breakfastAvg),
            const SizedBox(height: 8),
            MealRow(title: "Lunch", textColor: textColor, avg: lunchAvg),
            const SizedBox(height: 8),
            MealRow(title: "Dinner", textColor: textColor, avg: dinnerAvg),
          ],
        ),
      ),
    );
  }
}

class MealRow extends StatelessWidget {
  const MealRow({
    Key? key,
    required this.title,
    required this.textColor,
    required this.avg,
  }) : super(key: key);

  final String title;
  final Color textColor;
  final String avg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: textColor)),
        Text(
          avg,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: textColor),
        ),
      ],
    );
  }
}
