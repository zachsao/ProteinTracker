import 'package:flutter/material.dart';
import 'package:protein_tracker/auth.dart';
import 'package:protein_tracker/login/login_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Center(child: Text("This is the home page"),);
        } else {
          return const LoginPage();
        }
      });
  }
}