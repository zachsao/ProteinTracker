import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:protein_tracker/firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCredential = await _firebaseAuth.signInWithCredential(credential);
    saveUserToFirestore();

    return userCredential;
  }

  Future<void> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    if (kIsWeb) {
      // Once signed in, return the UserCredential
      await _firebaseAuth.signInWithPopup(appleProvider);
    } else {
      await _firebaseAuth.signInWithProvider(appleProvider);
    }
    saveUserToFirestore();
  }

  Future<void> saveUserToFirestore() async {
    var user = <String, dynamic>{
      "email": currentUser?.email
    };
    await FirestoreService().saveUser(user);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
