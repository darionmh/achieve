import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/styles.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final AbstractAuthService _authService = locator<AbstractAuthService>();

  var _passwordError;
  var _password = TextEditingController();
  var _confirmPasswordError;
  var _confirmPassword = TextEditingController();

  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);

    super.initState();
  }

  _showToast(message, length) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: accent_text_white,
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  void updatePassword() {
    setState(() {
      _passwordError = null;
      _confirmPasswordError = null;

      if (_password.text == '') {
        _passwordError = 'Cannot be blank.';
      }

      if (_confirmPassword.text == '') {
        _confirmPasswordError = 'Cannot be blank.';
      }

      // passwords must match
      if (_password.text != '' && _password.text != _confirmPassword.text) {
        _passwordError = 'Must be equal.';
        _confirmPasswordError = 'Must be equal.';
      }

      if (_passwordError == null && _confirmPasswordError == null) {
        _authService.changePassword(_password.text).then((res) {
          setState(() {
            print(res);
            switch (res) {
              case 'weak-password':
                _passwordError = 'Should be 6+ characters.';
                return;
              case 'requires-recent-login':
                Navigator.of(context).pop();
                _authService.signOut();
                _showToast('Please sign back in to make changes.', 10);
                return;
            }

            if(_passwordError == null) {
              Navigator.of(context).pop();
              _showToast('password updated', 3);
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change password',
        style: subheading,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _password,
              decoration: InputDecoration(
                errorText: _passwordError,
                labelText: 'password',
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                suffixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
//                  onChanged: (val) => _password = val,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            TextField(
              controller: _confirmPassword,
              decoration: InputDecoration(
                errorText: _confirmPasswordError,
                labelText: 'confirm password',
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                suffixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
//                  onChanged: (val) => _confirmPassword = val,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'cancel',
            style: accent_text,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            color: primaryColor,
            child: Text(
              'change',
              style: accent_text_white,
            ),
            onPressed: () => updatePassword()
        ),
      ],
    );
  }
}
