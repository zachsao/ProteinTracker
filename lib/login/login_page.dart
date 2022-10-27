import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:protein_tracker/auth.dart';
import 'package:protein_tracker/widgets/floating_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
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
                SignInButton(Buttons.AppleDark, onPressed: () => _signInWithApple()),
                SignInButton(Buttons.Google, onPressed: () => _handleSignIn()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    setState(() {
      Auth().signInWithGoogle();
    });
  }

  void _signInWithApple() {
    Auth().signInWithApple();
  }
}
