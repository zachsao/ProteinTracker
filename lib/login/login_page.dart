
import 'package:flutter/material.dart';
import 'package:protein_tracker/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: ElevatedButton(onPressed: () => _handleSignIn(), child: const Text("Sign in with Google")),);
  }
  
  void _handleSignIn() {
    setState(() {
      Auth().signInWithGoogle();
    });
  }

}