// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goald/home/home.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';

void main() {
  setupServiceLocator();
  runApp(new App());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AbstractAuthService _authService = locator<AbstractAuthService>();

  @override
  void dispose() {
    // _authService.signOut();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal\'d',
      routes: <String, WidgetBuilder>{},
      home: Scaffold(
        body: Container(
          child: _authService.getSignInState(),
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.purple[900],
        buttonColor: Colors.purple[900],
        iconTheme: IconThemeData(
          color: Colors.purple[900],
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple[900],
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.purple[900],
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: Center(child: Text('Oops!')));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(home: Center(child: Text('loading...')));
        });
  }
}
