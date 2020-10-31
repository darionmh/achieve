// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goald/home/home.dart';
import 'package:goald/onboarding/sign_in.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:provider/provider.dart';

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
    const primaryColor = Color.fromARGB(255, 44, 62, 80);

    var userState = Provider.of<User>(context);

    return MaterialApp(
      title: 'Goal\'d',
      routes: <String, WidgetBuilder>{},
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // status bar color
          brightness: Brightness.dark, // status bar brightness
          toolbarHeight: 0,
        ),
        body: Container(
          child: userState == null
              ? SignIn()
              : StreamProvider<User>(
                  create: (_) => FirebaseAuth.instance.userChanges(),
                  child: Home(),
                ),
        ),
      ),
      theme: ThemeData(
        primaryColor: primaryColor,
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        cardTheme: CardTheme(
          color: primaryColor,
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
        )
      ],
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return MaterialApp(
                  home: Scaffold(
                body: Center(child: Text('Oops!')),
              ));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return MyApp();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return MaterialApp(
                home: Scaffold(body: Center(child: Text('loading...'))));
          }),
    );
  }
}
