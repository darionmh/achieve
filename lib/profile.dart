import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goald/components/change_password_dialog.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/styles.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AbstractAuthService _authService = locator<AbstractAuthService>();

  var displayNameController = new TextEditingController();
  var emailController = new TextEditingController();

  var initialDisplayName;
  var initialEmail;

  var displayNameError;
  var emailError;

  var displayNameChanged = false;
  var emailChanged = false;

  var saving = false;

  FToast fToast;

  @override
  void initState() {
    displayNameController.text = _authService.getUser().displayName.trim();
    emailController.text = _authService.getUser().email.trim();

    initialDisplayName = displayNameController.text;
    initialEmail = emailController.text;

    super.initState();
    fToast = FToast();
    fToast.init(context);

    super.initState();
  }

  void _saveChanges() async {
    displayNameError = null;
    emailError = null;

    if (displayNameController.text == '') {
      setState(() {
        displayNameError = 'Display name cannot be blank';
      });
    } else {
      setState(() {
        saving = true;
      });
      var res = await _authService.updateProfile(
          displayNameController.text, emailController.text);

      setState(() {
        saving = false;

        switch (res) {
          case 'invalid-email':
            emailError = 'Can you double check that email?';
            break;
          case 'email-already-in-use':
            emailError = 'That email is being used by another profile.';
            break;
          case 'requires-recent-login':
            _authService.signOut();
            _showToast('Please sign back in to make changes.', 10);
            return;
        }

        displayNameController.text = _authService.getUser().displayName.trim();
        initialDisplayName = displayNameController.text;

        if (emailError == null) {
          emailController.text = _authService.getUser().email.trim();
          initialEmail = emailController.text;
          emailChanged = false;
        }

        if (displayNameError == null) {
          displayNameChanged = false;
        }

        if (displayNameError == null && emailError == null) {
          _showToast('Saved!', 3);
        }
      });
    }
  }

  void _changePassword() async {
    await _showChangePasswordDialog();
  }

  void _signOut() async {
    await _authService.signOut();
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

  Future<void> _showChangePasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ChangePasswordDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: Text(
            'Profile',
            style: heading,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              errorText: displayNameError,
              labelText: 'display name',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor)),
            ),
            onChanged: (val) {
              setState(() {
                displayNameError = null;
                displayNameChanged =
                    displayNameController.text != initialDisplayName;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12, bottom: 5),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              errorText: emailError,
              labelText: 'email',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor)),
            ),
            onChanged: (val) {
              setState(() {
                emailChanged = emailController.text != initialEmail;
              });
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text(saving ? 'saving...' : 'save changes'),
            onPressed: (emailChanged || displayNameChanged) && !saving
                ? () => _saveChanges()
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text('change password'),
              onPressed: () => _changePassword(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text('sign out'),
              onPressed: () => _signOut(),
            ),
          ),
        )
      ],
    );
  }
}
