import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String topText;
  final String midText;
  final String bottomText;

  const Tile(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      required this.topText,
      required this.midText,
      required this.bottomText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topText,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor, fontWeight: FontWeight.w300),
              ),
              Text(midText, style: Theme.of(context).textTheme.displayMedium!.copyWith(color: textColor, fontWeight: FontWeight.w300)),
              Text(bottomText, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor, fontWeight: FontWeight.w300))
            ],
          ),
        ),
      ),
    );
  }
}
