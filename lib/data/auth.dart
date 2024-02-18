import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:protein_tracker/data/firestore.dart';

class Auth {
  static Auth get() => GetIt.I<Auth>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<OAuthCredential> authenticateWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // return a new credential
    return GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }

  Future<void> signInWithGoogle() async {
    // Create a new credential
    final credential = await authenticateWithGoogle();

    // Once signed in, return the UserCredential
    await _firebaseAuth.signInWithCredential(credential);
    saveUserToFirestore();
  }

  Future<void> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    await _firebaseAuth.signInWithProvider(appleProvider);

    saveUserToFirestore();
  }

  Future<void> saveUserToFirestore() async {
    var user = <String, dynamic>{"email": currentUser?.email};
    await FirestoreService.get().saveUser(user);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> authenticateThenDelete(Function onUserDeleted) async {
    if (currentUser!.providerData.firstOrNull?.providerId == "google.com") {
      authenticateWithGoogle().then((value) => currentUser!
          .reauthenticateWithCredential(value)
          .then((value) => currentUser!.delete())
          .then((_) => onUserDeleted()));
    } else {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      currentUser!
          .reauthenticateWithProvider(appleProvider)
          .then((value) => currentUser!.delete())
          .then((_) => onUserDeleted());
    }
  }

  Future<String> deleteUser() async {
    var result = "";
    try {
      await FirestoreService.get().deleteUser();
      await currentUser!.delete();
    } catch (e) {
      if (e is FirebaseAuthException && e.code == "requires-recent-login") {
        result = e.message!;
      } else {
        result = "An error occurred";
      }
    }

    return result;
  }
}
