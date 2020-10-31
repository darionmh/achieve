import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/services/profanity_filter.dart';
import 'package:goald/styles.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AbstractAuthService _authService = locator<AbstractAuthService>();

  var _email = '';

  var _emailError;

  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);

    super.initState();
  }

  _requestPasswordReset() {
    setState(() {
      _emailError = null;
    });
    if (_email == null || _email == '') {
      setState(() {
        _emailError = 'Cannot be blank.';
      });
    } else if (_email != '' && !RegExp(r'\w+@(\w|.)+\.\w+').hasMatch(_email)) {
      setState(() {
        _emailError = 'Can you double check that email?';
      });
    } else {
      _authService.sendPasswordResetEmail(_email);

      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: primaryColor,
        ),
        child: Text(
          'Email sent! If there is an account with that email, your should receive an email with further instructions.',
          style: accent_text_white,
        ),
      );

      Navigator.pop(context);

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 10),
      );
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                'Reset Password',
                style: subheading,
              ),
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
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Send reset email'),
                onPressed: () => _requestPasswordReset(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
