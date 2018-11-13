import 'package:flutter/material.dart';
import '../../ui/base/base_page.dart';

class NavigationService {
  static final _instance = NavigationService._internal();

  BuildContext context;

  factory NavigationService(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  NavigationService._internal();

  void navigate(BasePage page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          name: page.getRouteDescriptor(),
        ),
      ),
    );
  }
}
