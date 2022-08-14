import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protein_tracker/firestore.dart';
import 'package:protein_tracker/models/meal.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DailyState();

}

class DailyState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().getFoods(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'),);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Food data = document.data()! as Food;
                return ListTile(
                  title: Text(data.name),
                  subtitle: Text(data.amount.toString()),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}