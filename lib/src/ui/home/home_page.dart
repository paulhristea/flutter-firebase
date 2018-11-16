import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart' as Constants;
import '../../domain/auth/authentication_manager.dart';
import '../../domain/navigation/navigation_service.dart';
import '../base/base_page.dart';
import '../map/map_page.dart';
import '../tabs/tabs_page.dart';

class HomePage extends BasePage {
  HomePage(
      {Key key,
      this.title,
      @required this.analytics,
      @required this.observer,
      @required this.authenticationManager})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final AuthenticationManager authenticationManager;

  @override
  State createState() =>
      _HomePageState(analytics, observer, authenticationManager);

  @override
  String getRouteDescriptor() {
    return Constants.homePageRoute;
  }
}

class _HomePageState extends BasePageState<HomePage> {
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;
  AuthenticationManager authenticationManager;
  String _message = '';

  _HomePageState(this.analytics, this.observer, this.authenticationManager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.map),
            label: Text('Map Page'),
            onPressed: () {
              NavigationService(context).navigate(MapPage());
            },
          ),
          MaterialButton(
            child: Text('Logout'),
            onPressed: authenticationManager.signOut,
          ),
          Text(_message,
              style: TextStyle(color: Color.fromARGB(255, 0, 155, 0))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.tab),
          onPressed: () {
            NavigationService(context).navigate(TabsPage(observer));
          }),
    );
  }
}
