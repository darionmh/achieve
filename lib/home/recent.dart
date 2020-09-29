import 'package:flutter/material.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/styles.dart';
import 'package:provider/provider.dart';

class RecentlyCompleted extends StatefulWidget {
  @override
  _RecentlyCompletedState createState() => _RecentlyCompletedState();
}

class _RecentlyCompletedState extends State<RecentlyCompleted> {

  List _buildRecentGoals(goals) {
    if(goals == null) return [];

    return goals.map((e) => GoalCard(goal: e)).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    var goals = Provider.of<List<Goal>>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Recently Completed',
              style: subheading,
            ),
          ),
          ..._buildRecentGoals(goals)
        ],
      ),
    );
  }
}
