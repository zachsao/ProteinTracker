import 'package:flutter/material.dart';
import 'package:protein_tracker/data/auth.dart';
import 'package:protein_tracker/home/home_page.dart';
import 'package:protein_tracker/login/login_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      });
  }
}