// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:goald/home/home.dart';
import 'package:goald/service-locator.dart';

void main() {
  setupServiceLocator();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal\'d',
      routes: <String, WidgetBuilder>{},
      home: Home(),
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
