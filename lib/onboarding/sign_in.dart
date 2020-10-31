import 'package:flutter/material.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/onboarding/forgot_password.dart';
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

  var emailError;
  var passwordError;

  void _signIn() async {
    _authService.signInWithEmail(_email, _password).then((status) {
      setState(() {
        emailError = null;
        passwordError = null;

        switch (status) {
          case SignInStatus.user_not_found:
            emailError = 'No account found with that email.';
            break;
          case SignInStatus.wrong_password:
            passwordError = 'No account found with that email and password.';
            break;
          case SignInStatus.failed:
            emailError = 'Can you double check that information?';
            break;
          case SignInStatus.success:
            break;
        }
      });
    });
  }

  void _forgot() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPassword(),
      ),
    );
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: FractionallySizedBox(
              child: Image.asset('images/success.png'),
              widthFactor: 0.80,
            ),
            padding: EdgeInsets.all(30),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'email',
              errorText: emailError,
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              suffixIcon: Icon(Icons.alternate_email),
            ),
            onChanged: (val) => _email = val,
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'password',
                errorText: passwordError,
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                suffixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              onChanged: (val) => _password = val,
            ),
            margin: EdgeInsets.only(top: 15, bottom: 10),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text('Sign In'),
              onPressed: () => _signIn(),
            ),
          ),
          ClickableText(
            margin: EdgeInsets.only(top: 10),
            onClick: _forgot,
            text: 'Forgot password',
          ),
          ClickableText(
            margin: EdgeInsets.only(top: 10),
            onClick: _signUp,
            text: 'Create an account',
          ),
        ],
      ),
    );
  }
}
