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
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showUpdateDialog(context),
      child: const Text(Strings.editGoalButton),
    );
  }

  Future<void> showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update daily goal"),
            content: TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                labelText: "Daily goal (g)",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    widget.updateGoal(int.parse(_textController.text));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
