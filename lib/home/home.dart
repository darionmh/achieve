import 'package:flutter/material.dart';
import 'package:goald/add/add_goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/services/goal_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  AbstractAuthService _authService = locator<AbstractAuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${_authService.getUser().displayName}'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _authService.signOut(),
          )
        ],
      ),
      body: _goalService.getGoals(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddGoal(),
          ),
        ),
      ),
    );
  }
}
