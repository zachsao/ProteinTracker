import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:protein_tracker/firebase_options.dart';
import 'package:protein_tracker/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PeachyApp());
}

class PeachyApp extends StatelessWidget {
  const PeachyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: WidgetTree(),),
    );
  }
}
