import 'package:flutter/material.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';

class RecentlyCompleted extends StatefulWidget {
  @override
  _RecentlyCompletedState createState() => _RecentlyCompletedState();
}

class _RecentlyCompletedState extends State<RecentlyCompleted> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  var recentGoals = <Goal>[];

  List<Widget> _buildRecentGoals() {
    return recentGoals.map((e) => GoalCard(goal: e)).toList();
  }
  
  @override
  Widget build(BuildContext context) {
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
          ..._buildRecentGoals()
        ],
      ),
    );
  }
}
