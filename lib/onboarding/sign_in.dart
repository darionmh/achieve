import 'package:flutter/material.dart';
import 'package:goald/onboarding/sign_up.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AbstractAuthService _authService = locator<AbstractAuthService>();

  var _email = '';
  var _password = '';

  void _signIn() async {
    _authService.signInWithEmail(_email, _password).then((status) {
      print(status);
      switch (status) {
        case SignInStatus.user_not_found:
          break;
        case SignInStatus.wrong_password:
          break;
        case SignInStatus.failed:
          break;
        case SignInStatus.success:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'email'),
            onChanged: (val) => _email = val,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            obscureText: true,
            onChanged: (val) => _password = val,
          ),
          ButtonBar(
            children: [
              RaisedButton(
                child: Text('Register'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                ),
                color: Colors.white,
                textColor: Colors.purple[900],
              ),
              RaisedButton(
                child: Text('Sign In'),
                onPressed: () => _signIn(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
