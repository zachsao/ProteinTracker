import 'dart:core';

import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final void Function() backwardPressed;
  final void Function() forwardPressed;
  final String formattedDate;
  final bool isForwardVisible;

  const DateSelector({
    super.key,
    required this.formattedDate,
    required this.backwardPressed,
    required this.forwardPressed,
    required this.isForwardVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: backwardPressed,
        ),
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: isForwardVisible,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: forwardPressed,
          ),
        ),
      ],
    );
  }
}
