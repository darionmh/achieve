import 'package:flutter/material.dart';
import 'package:goald/home/goal_tile.dart';
import 'package:goald/models/goal.dart';

class GoalList extends StatefulWidget {

  final List<Goal> goalList;

  const GoalList({Key key, this.goalList}) : super(key: key);
  
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {

  @override
  Widget build(BuildContext context) {
    if (widget.goalList != null && widget.goalList.length > 0) {
      return ListView.builder(
        // shrinkWrap: true,
        itemCount: widget.goalList.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;
          return GoalTile(
            goal: widget.goalList[index],
          );
        },
      );
    }

    return Center(
      child: Text('Click the + below to add a goal and get started!'),
    );
  }
}
