// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'src/flutter_firebase_app.dart';
import 'src/sentry/sentry_service.dart';
import 'src/config/environment/environment_loader.dart';
import 'src/config/constants.dart' as Constants;

void main() async {
  await init();
  runApp(FlutterFirebaseApp());
}

init() async {
  await EnvironmentLoader(Constants.environmentFile).load();
  final developmentErrorHandler = FlutterError.onError;
  final productionErrorHandler = (FlutterErrorDetails errorDetails) {
    final exception = errorDetails.exception;
    final stackTrace = errorDetails.stack.toString();
    SentryService().captureException(exception, stackTrace);
  };
  // Set crashlytics-enabled error handler.
  FlutterError.onError = productionErrorHandler;
  assert(() {
    // Use default handler instead if app is in development mode.
    FlutterError.onError = developmentErrorHandler;
    return true;
  }());
}