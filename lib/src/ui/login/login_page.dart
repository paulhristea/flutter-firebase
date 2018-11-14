import 'package:flutter/material.dart';
import '../../domain/auth/authentication_manager.dart';
import '../base/base_page.dart';
import '../../config/constants.dart' as Constants;

class LoginPage extends BasePage {
  final AuthenticationManager authenticationManager;

  LoginPage(this.authenticationManager);

  @override
  State<StatefulWidget> createState() => _LoginPageState(authenticationManager);

  @override
  String getRouteDescriptor() {
    return Constants.loginPageRoute;
  }
}

class _LoginPageState extends BasePageState<LoginPage> {
  final AuthenticationManager authenticationManager;

  _LoginPageState(this.authenticationManager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.lock),
              label: Text('Login with Google'),
              onPressed: authenticationManager.signInWithGoogle,
            ),
            RaisedButton.icon(
              icon: Icon(Icons.lock),
              label: Text('Login with Facebook'),
              onPressed: () =>
                  authenticationManager.signInWithFacebook(context),
            ),
          ],
        ),
      ),
    );
  }
}
