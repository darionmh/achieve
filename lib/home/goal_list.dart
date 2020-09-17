import 'package:flutter/material.dart';
import 'package:goald/home/goal_tile.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  GoalService _goalService = locator<AbstractGoalService>();
  List<Goal> _goals;

  @override
  void initState() {
    super.initState();
    _goalService.getGoals().then((value) => setState(() {
          _goals = value;
        }));
    _goalService.goalChangedEvent.subscribe((args) => setState(() {
          _goals = args.changedValue;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (_goals != null && _goals.length > 0) {
      return ListView.builder(
        itemCount: _goals.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;
          return GoalTile(
            goal: _goals[index],
          );
        },
      );
    }
    return Center(
      child: Text('Click the + below to add a goal and get started!'),
    );
  }
}
