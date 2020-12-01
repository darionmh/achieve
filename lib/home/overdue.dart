import 'package:flutter/material.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/event_emitter.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';

class Overdue extends StatefulWidget {
  EventEmitter collapseGoalsEvent;
  Function(BuildContext) scrollToContext;

  Overdue(
      {this.collapseGoalsEvent, this.scrollToContext});

  @override
  _OverdueState createState() => _OverdueState();
}

class _OverdueState extends State<Overdue> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  var goals = <Goal>[];

  var _unsub;

  @override
  void initState() {
    goals = _goalService.getOverdueGoals();
    _unsub = _goalService.getStoreUpdateEvent().subscribe(() => setState(() => goals = _goalService.getOverdueGoals()));

    super.initState();
  }

  void dispose() {
    _unsub();
    super.dispose();
  }

  List _buildOverdueGoals(List<Goal> goals) {
    if (goals == null || goals.length == 0) return [];

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
    if (goals == null || goals.isEmpty) return Container();

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
                  'Overdue',
                  style: subheading,
                ),
              ],
            ),
          ),
          ..._buildOverdueGoals(goals)
        ],
      ),
    );
  }
}
