import 'package:flutter/material.dart';
import 'package:protein_tracker/home/screen.dart';
import '../FoodRepository.dart';
import '../widgets/peachy_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  int selectedIndex = 0;
  FoodRepository repository = FoodRepository();

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomBarItems =
        Screen.screens(repository).map((screen) {
      return BottomNavigationBarItem(icon: Icon(screen.icon), label: screen.label);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Screen.screens(repository)[selectedIndex].content,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const PeachyFab(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTap,
        currentIndex: selectedIndex,
        items: bottomBarItems,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
