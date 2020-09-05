import 'package:flutter/material.dart';
import 'package:goald/home/milestone_list.dart';

class GoalTile extends StatefulWidget {
  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              child: Icon(_isComplete
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked),
              padding: EdgeInsets.all(16),
            ),
            onTap: () => setState(() {
              _isComplete = !_isComplete;
            }),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title'),
                  Text('Subtitle'),
                  MilestoneList(),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 12),
            child: Text('10/10/2020'),
          ),
        ],
      ),
    );
  }
}
