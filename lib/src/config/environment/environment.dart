import '../../domain/exceptions/uninitialized_exception.dart';
import '../../domain/exceptions/missing_variable_exception.dart';
import '../constants.dart' as Constants;

class Environment {
  static Environment _instance;

  final String sentryDns;

  factory Environment([Map<String, dynamic> variables]) {
    if (_instance == null) {
      if (variables == null) {
        throw new UninitializedException(
            'Must provide parsed environment variables first');
      }
      _instance = Environment._singleton(variables);
    }
    return _instance;
  }

  Environment._singleton(Map<String, dynamic> variables)
      : sentryDns = variables[Constants.sentryDnsKey] ??
            throwMissingVariableException(Constants.sentryDnsKey);

  static throwMissingVariableException(String variableName) =>
      throw MissingVariableException(variableName);
}
