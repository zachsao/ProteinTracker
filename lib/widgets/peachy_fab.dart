import 'package:flutter/material.dart';
import 'package:protein_tracker/models/meal.dart';

class PeachyFab extends StatefulWidget {
  final Function addFood;
  const PeachyFab({
    Key? key, required this.addFood,
  }) : super(key: key);

  @override
  State<PeachyFab> createState() => _PeachyFabState();
}

class _PeachyFabState extends State<PeachyFab> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  MealType dropdownValue = MealType.values.first;

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

  void onTypeChanged(MealType? value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  void addFood() async {
    Food food = Food(name: _nameController.text, amount: int.parse(_amountController.text), type: dropdownValue);
    widget.addFood(food);
    _nameController.clear();
    _amountController.clear();
    dropdownValue = MealType.values.first;
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add an item', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: "Protein amount (g)",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                StatefulBuilder(builder: (context, dropdownState) {
                  return DropdownButtonFormField<MealType>(
                      isExpanded: true,
                      value: dropdownValue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      ),
                      items: MealType.values.map((MealType type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (MealType? value) {
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
                addFood();
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
