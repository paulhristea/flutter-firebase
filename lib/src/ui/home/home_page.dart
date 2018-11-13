import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import '../../domain/navigation/navigation_service.dart';
import '../base/base_page.dart';
import '../tabs/tabs_page.dart';
import '../../config/constants.dart' as Constants;

class HomePage extends BasePage {
  HomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State createState() => _HomePageState(analytics, observer);

  @override
  String getRouteDescriptor() {
    return Constants.homePageRoute;
  }
}

class _HomePageState extends BasePageState<HomePage> {
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;
  String _message = '';

  _HomePageState(this.analytics, this.observer);

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
  }

  Future<void> _testSetUserId() async {
    await analytics.setUserId('some-user');
  }

  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await analytics.android?.setAnalyticsCollectionEnabled(false);
    await analytics.android?.setAnalyticsCollectionEnabled(true);
  }

  Future<void> _testSetMinimumSessionDuration() async {
    await analytics.android?.setMinimumSessionDuration(20000);
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await analytics.android?.setSessionTimeoutDuration(2000000);
  }

  Future<void> _testSetUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          MaterialButton(
            child: const Text('Test logEvent'),
            onPressed: _sendAnalyticsEvent,
          ),
          MaterialButton(
            child: const Text('Test setUserId'),
            onPressed: _testSetUserId,
          ),
          MaterialButton(
            child: const Text('Test setCurrentScreen'),
            onPressed: _testSetCurrentScreen,
          ),
          MaterialButton(
            child: const Text('Test setAnalyticsCollectionEnabled'),
            onPressed: _testSetAnalyticsCollectionEnabled,
          ),
          MaterialButton(
            child: const Text('Test setMinimumSessionDuration'),
            onPressed: _testSetMinimumSessionDuration,
          ),
          MaterialButton(
            child: const Text('Test setSessionTimeoutDuration'),
            onPressed: _testSetSessionTimeoutDuration,
          ),
          MaterialButton(
            child: const Text('Test setUserProperty'),
            onPressed: _testSetUserProperty,
          ),
          Text(_message,
              style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.tab),
          onPressed: () {
            NavigationService(context).navigate(TabsPage(observer));
          }),
    );
  }
}
