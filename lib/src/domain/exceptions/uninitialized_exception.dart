class UninitializedException implements Exception {
  final String cause;

  UninitializedException(this.cause);

  @override
  String toString() {
    return "UninitializedException: $cause";
  }
}
