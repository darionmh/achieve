import 'package:flutter/material.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  Widget _buildStatCard(
      title, goalsComplete, goalsTotal, milestonesComplete, milestonesTotal) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(title, style: card_heading),
              margin: EdgeInsets.only(bottom: 20),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed Goals',
                    style: card_body,
                  ),
                  Text(
                    '$goalsComplete / $goalsTotal',
                    style: card_body,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Milestones',
                  style: card_body,
                ),
                Text(
                  '$milestonesComplete / $milestonesTotal',
                  style: card_body,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              'Dashboard',
              style: subheading,
            ),
          ),
          _buildStatCard('Last 30 days', 0, 0, 0, 0),
          _buildStatCard('Last 12 months', 0, 0, 0, 0),
        ],
      ),
    );
  }
}
