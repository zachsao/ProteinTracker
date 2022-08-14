import 'package:flutter/material.dart';
import 'package:protein_tracker/models/meal.dart';

class PeachyFab extends StatefulWidget {
  const PeachyFab({
    Key? key,
  }) : super(key: key);

  @override
  State<PeachyFab> createState() => _PeachyFabState();
}

class _PeachyFabState extends State<PeachyFab> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  String dropdownValue = MealType.values.first.name;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void onTypeChanged(String? value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add an item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: "Name",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: "Protein amount (g)",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                StatefulBuilder(builder: (context, dropdownState) {
                  return DropdownButtonFormField(
                      isExpanded: true,
                      value: dropdownValue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      ),
                      items: MealType.values.map((MealType type) {
                        return DropdownMenuItem(
                          value: type.name,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        dropdownState(() {
                          dropdownValue = value!;
                        });
                      });
                })
              ],
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () => _showMyDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Image(
            image: AssetImage("images/peach.png"),
          ),
        ),
      ),
    );
  }
}
