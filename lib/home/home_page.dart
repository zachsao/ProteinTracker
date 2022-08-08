import 'package:flutter/material.dart';
import 'package:protein_tracker/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Hello, ${Auth().currentUser?.displayName ?? Auth().currentUser?.email}"),
          ElevatedButton(
              onPressed: () => _handleSignOut(), child: const Text("Sign out")),
        ],
      ),
    );
  }

  void _handleSignOut() {
    setState(() {
      Auth().signOut();
    });
  }
}
