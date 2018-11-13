import '../model/user.dart';

class AuthenticationManager {
  static final _instance = AuthenticationManager._internal();

  User loggedInUser;

  factory AuthenticationManager() {
    return _instance;
  }

  AuthenticationManager._internal();

  init() {
    // TODO: Launch API call to check for logged in user
    loggedInUser = new User()
      ..id = 1
      ..email = 'hristea@mail.com';
  }

  isAuthenticated() {
    return loggedInUser != null;
  }
}
