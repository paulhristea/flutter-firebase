import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'environment.dart';

class EnvironmentLoader {
  bool _isLoaded = false;
  final String _environmentFile;

  EnvironmentLoader(this._environmentFile);

  Future<Environment> load() {
    if (_isLoaded) {
      throw new Exception('Environment has already been loaded');
    }
    return rootBundle.loadStructuredData<Environment>(this._environmentFile,
        (jsonStr) async {
      Environment(json.decode(jsonStr));
      _isLoaded = true;
    });
  }
}
