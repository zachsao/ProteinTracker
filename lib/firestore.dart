import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(Map<String, dynamic> user, String? uid) async {
    _firestore.collection("users").doc(uid).set(user);
  }
}