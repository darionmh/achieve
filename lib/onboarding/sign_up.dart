import 'package:flutter/material.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/services/profanity_filter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AbstractAuthService _authService = locator<AbstractAuthService>();
  final filter = ProfanityFilter();

  var _displayName = '';
  var _email = '';
  var _password = '';
  var _confirmPassword = '';

  var _displayNameError;
  var _emailError;
  var _passwordError;
  var _confirmPasswordError;

  void _signUp() async {
    setState(() {
      _displayNameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;

      // check empty fields
      if (_displayName == '') {
        _displayNameError = 'Cannot be blank.';
      }

      if (_email == '') {
        _emailError = 'Cannot be blank.';
      }

      if (_password == '') {
        _passwordError = 'Cannot be blank.';
      }

      if (_confirmPassword == '') {
        _confirmPasswordError = 'Cannot be blank.';
      }

      // patterns
      // if(filter.isProfane(_displayName)) {
      //   _displayNameError = 'That name doesn\'t meet our standards.';
      // }

      if(_email != '' && !RegExp(r'\w+@(\w|.)+\.\w+').hasMatch(_email)) {
        _emailError = 'Can you double check that email?';
      }


      // passwords must match
      if (_password != '' && _password != _confirmPassword) {
        _passwordError = 'Must be equal.';
        _confirmPasswordError = 'Must be equal.';
      }

      if (_displayNameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null) {
        _authService
            .registerWithEmail(_email, _password, _displayName)
            .then((status) {
          setState(() {
            print(status);
            switch (status) {
              case RegisterStatus.email_already_in_use:
                _emailError = 'The email address is already in use.';
                break;
              case RegisterStatus.weak_password:
                _passwordError = 'Password should be at least 6 characters.';
                break;
              case RegisterStatus.failed:
                break;
              case RegisterStatus.success:
                Navigator.of(context).pop();
                break;
            }
          });
        });
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
            TextField(
              decoration: InputDecoration(
                errorText: _displayNameError,
                labelText: 'display name',
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                suffixIcon: Icon(Icons.person_outline),
              ),
              onChanged: (val) => _displayName = val,
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                  errorText: _emailError,
                  labelText: 'email',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  suffixIcon: Icon(Icons.alternate_email),
                ),
                onChanged: (val) => _email = val,
              ),
              margin: EdgeInsets.only(
                  top: _displayNameError == null ? 30 : 8,
                  bottom: _emailError == null ? 30 : 8),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                  errorText: _passwordError,
                  labelText: 'password',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  suffixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                onChanged: (val) => _password = val,
              ),
              margin: EdgeInsets.only(bottom: _passwordError == null ? 30 : 8),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                  errorText: _confirmPasswordError,
                  labelText: 'confirm password',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  suffixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                onChanged: (val) => _confirmPassword = val,
              ),
              margin: EdgeInsets.only(
                  bottom: _confirmPasswordError == null ? 30 : 8),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Register'),
                onPressed: () => _signUp(),
              ),
            ),
            ClickableText(
              margin: EdgeInsets.only(top: 10),
              text: 'Cancel',
              onClick: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }
}
