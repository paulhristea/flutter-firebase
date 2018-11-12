import '../config/environment/environment.dart';
import 'package:sentry/sentry.dart';

class SentryService {
  static final _instance = SentryService._internal();

  final SentryClient _client;

  factory SentryService() {
    return _instance;
  }

  SentryService._internal()
      : _client = SentryClient(dsn: Environment().sentryDns);

  captureException(exception, stackTrace) async {
    await _client.captureException(
        exception: exception, stackTrace: stackTrace);
  }
}
