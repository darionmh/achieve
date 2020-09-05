import 'package:flutter/material.dart';
import 'package:goald/home/goal_tile.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, i) {
        if(i.isOdd) {
          return Divider();
        }
        
        return GoalTile();
      },
    );
  }
}
