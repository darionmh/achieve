import 'package:flutter/material.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/styles.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  final DateFormat formatter = DateFormat('MMM dd, yyyy');
  Goal goal;

  GoalCard({this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatter.format(goal.endDate), style: card_body),
                  Text(goal.complete ? 'Complete' : 'In progress',
                      style: card_body),
                ],
              ),
            ),
            Container(
              child: Text(goal.title, style: card_heading),
            ),
            goal.description == null || goal.description == ''
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      goal.description,
                      style: card_body,
                    )),
            goal.milestones == null || goal.milestones.length == 0
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Milestones completed', style: card_body),
                        Text(
                            '${goal.milestones.where((element) => element.done).length} / ${goal.milestones.length}',
                            style: card_body),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
