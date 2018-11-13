import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';

class AuthenticationManager {
  static final _instance = AuthenticationManager._internal();

  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  User loggedInUser;

  factory AuthenticationManager() {
    return _instance;
  }

  AuthenticationManager._internal();

  void signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    loggedInUser = new User()
      ..id = user.uid
      ..email = user.email;
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  bool isAuthenticated() {
    return loggedInUser != null;
  }
}
