import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../navigation/navigation_service.dart';
import '../model/user.dart';

class AuthenticationManager {
  static final _instance = AuthenticationManager._internal();

  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  final _facebookLogin = FacebookLogin();
  final _analytics = FirebaseAnalytics();

  User loggedInUser;

  factory AuthenticationManager() {
    return _instance;
  }

  AuthenticationManager._internal();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    onLoginSuccess(user);
  }

  void onLoginSuccess(FirebaseUser user) {
    _analytics.setUserId(user.uid);
    _analytics.logLogin();
    loggedInUser = User()
      ..id = user.uid
      ..email = user.email;
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    final result = await _facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        showAlert(context, 'Login failed', result.errorMessage);
        break;
      case FacebookLoginStatus.loggedIn:
        final accessToken = result.accessToken.token;
        try {
          final FirebaseUser user =
              await _firebaseAuth.signInWithFacebook(accessToken: accessToken);
          onLoginSuccess(user);
        } catch (e) {
          if ((e.code == 'exception' || e.code == 'sign_in_failed') &&
                  (e.message
                          ?.toString()
                          ?.contains('An account already exists') ??
                      false) ||
              e.message == 'FIRAuthErrorDomain') {
            showAlert(context, 'Account already exists',
                'Please link with your existing account to continue.',
                confirmButtonAction: () async {
              await signInWithGoogle();
              await _firebaseAuth.linkWithFacebookCredential(
                  accessToken: accessToken);
            });
          }
        }
        break;
    }
  }

  void showAlert(BuildContext context, String title, String message,
      {Future<void> confirmButtonAction()}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  NavigationService(context).pop();
                },
              ),
              confirmButtonAction != null
                  ? FlatButton(
                      child: Text('OK'),
                      onPressed: () async {
                        NavigationService(context).pop();
                        await confirmButtonAction();
                      },
                    )
                  : null,
            ],
          );
        });
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _facebookLogin.logOut();
    _analytics.setUserId(null);
  }

  bool isAuthenticated() {
    return loggedInUser != null;
  }
}
