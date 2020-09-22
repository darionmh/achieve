import 'package:flutter/material.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AbstractAuthService _authService = locator<AbstractAuthService>();

  var _displayName = '';
  var _email = '';
  var _password = '';

  void _signUp() async {
    _authService.registerWithEmail(_email, _password, _displayName).then((status) {
      print(status);
      switch (status) {
        case RegisterStatus.email_already_in_use:
          break;
        case RegisterStatus.weak_password:
          break;
        case RegisterStatus.failed:
          break;
        case RegisterStatus.success:
          Navigator.of(context).pop();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'display name'),
            onChanged: (val) => _displayName = val,
          ),
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
                onPressed: () => _signUp(),
                color: Colors.white,
                textColor: Colors.purple[900],
              ),
            ],
          ),
        ],
      ),
    ),);
  }
}
