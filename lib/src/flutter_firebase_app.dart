import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'domain/auth/authentication_manager.dart';
import 'ui/home/home_page.dart';
import 'ui/login/login_page.dart';

class FlutterFirebaseApp extends StatelessWidget {
  static final analytics = FirebaseAnalytics();
  static final observer = FirebaseAnalyticsObserver(analytics: analytics);
  static final authenticationManager = AuthenticationManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // TODO: Manually send screens to Firebase Analytics instead of their observer?
      navigatorObservers: <NavigatorObserver>[observer],
      home: _assertStartingPage(),
    );
  }

  Widget _assertStartingPage() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text('please wait'),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return HomePage(
                title: 'Flutter Firebase',
                analytics: analytics,
                observer: observer,
                authenticationManager: authenticationManager,
              );
            }
            return LoginPage(authenticationManager);
          }
        });
  }
}
