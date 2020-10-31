import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/event_emitter.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/styles.dart';
import 'package:provider/provider.dart';

class Upcoming extends StatefulWidget {
  final VoidCallback onClick;
  EventEmitter collapseGoalsEvent;
  Function(BuildContext) scrollToContext;

  Upcoming(
      {@required this.onClick, this.collapseGoalsEvent, this.scrollToContext});

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  var upcomingGoals = <Goal>[];

  List _buildUpcomingGoals(List<Goal> goals) {
    if (goals == null || goals.length == 0) return [
      Text('Nothing found. Add some new goals!')
    ];
    return goals
        .map((e) => GoalCard(
              goal: e,
              collapseEvent: widget.collapseGoalsEvent,
              onTap: (context) => widget.scrollToContext(context),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var goals = Provider.of<List<Goal>>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Upcoming',
                  style: subheading,
                ),
                ClickableText(
                  text: 'view more',
                  style: accent_text,
                  onClick: widget.onClick,
                ),
              ],
            ),
          ),
          ..._buildUpcomingGoals(goals)
        ],
      ),
    );
  }
}
