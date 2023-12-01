import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:protein_tracker/data/auth.dart';
import 'package:protein_tracker/widgets/floating_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
void logEvent() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: "Login page");
  }

  @override
  void initState() {
    logEvent();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 42),
                Text(
                  "Track your protein",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                Text(
                  "Get\nPeachy.",
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(200),
                      fontSize: 85),
                ),
                const SizedBox(height: 20),
                const FloatingLogo(),
                const Spacer(),
                if (Platform.isIOS) SignInButton(Buttons.AppleDark, onPressed: () => signInWithApple()),
                SignInButton(Buttons.Google, onPressed: () => signInWithGoogle()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() {
    Auth.get().signInWithGoogle();
  }

  void signInWithApple() {
    Auth.get().signInWithApple();
  }
}
