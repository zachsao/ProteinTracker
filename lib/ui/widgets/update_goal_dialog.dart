import 'package:flutter/material.dart';
import 'package:protein_tracker/constants/strings.dart';

class UpdateGoalDialog extends StatefulWidget {
  final Function updateGoal;
  const UpdateGoalDialog({Key? key, required this.updateGoal})
      : super(key: key);

  @override
  State<UpdateGoalDialog> createState() => _UpdateGoalDialogState();
}

class _UpdateGoalDialogState extends State<UpdateGoalDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.updateGoal),
      content: TextField(
        autofocus: true,
        controller: _textController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          labelText: Strings.dailyGoalHint,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(Strings.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(Strings.saveButton),
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              widget.updateGoal(int.parse(_textController.text));
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
