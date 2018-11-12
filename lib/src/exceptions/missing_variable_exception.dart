class MissingVariableException implements Exception {
  final String cause;

  MissingVariableException(variableName)
      : cause = 'An environment variable is missing: $variableName';

  @override
  String toString() {
    return "MissingVariableException: $cause";
  }
}
