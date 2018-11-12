import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import '../tabs/tabs_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() => _HomePageState(analytics, observer);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

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
    setMessage('logEvent succeeded');
  }

  Future<void> _testSetUserId() async {
    await analytics.setUserId('some-user');
    setMessage('setUserId succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await analytics.android?.setAnalyticsCollectionEnabled(false);
    await analytics.android?.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> _testSetMinimumSessionDuration() async {
    await analytics.android?.setMinimumSessionDuration(20000);
    setMessage('setMinimumSessionDuration succeeded');
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await analytics.android?.setSessionTimeoutDuration(2000000);
    setMessage('setSessionTimeoutDuration succeeded');
  }

  Future<void> _testSetUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
    setMessage('setUserProperty succeeded');
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
            Navigator.of(context).push(MaterialPageRoute<TabsPage>(
                settings: const RouteSettings(name: TabsPage.routeName),
                builder: (BuildContext context) {
                  return TabsPage(observer, analytics);
                }));
          }),
    );
  }
}