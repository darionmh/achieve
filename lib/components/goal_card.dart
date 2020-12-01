import 'package:flutter/material.dart';
import 'package:goald/add/add_goal.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/edit/edit_goal.dart';
import 'package:goald/event_emitter.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatefulWidget {
  Goal goal;
  EventEmitter collapseEvent;
  Function(BuildContext) onTap;

  GoalCard({this.goal, this.collapseEvent, this.onTap});

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  final DateFormat formatter = DateFormat('MMM dd, yyyy');
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  bool isOpen = false;
  var _unsub;

  void initState() {
    _unsub = widget.collapseEvent?.subscribe(() => setState(() => isOpen = false));

    super.initState();
  }

  void dispose() {
    if(_unsub != null)
      _unsub();

    super.dispose();
  }

  _openEditDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: EditGoal(goal: widget.goal),
          ),
        ),
      ),
    );
  }

  _toggleGoalComplete() {
    setState(() {
      isOpen = false;
      widget.goal.complete = !widget.goal.complete;

      if(widget.goal.complete) {
        widget.goal.dateCompleted = DateTime.now();
      }

      _goalService.update(widget.goal);
    });
  }

  _toggleMilestoneComplete(Milestone milestone) {
    setState(() {
      var i = widget.goal.milestones.indexOf(milestone);
      milestone.done = !milestone.done;
      widget.goal.milestones[i] = milestone;

      _goalService.update(widget.goal);
    });
  }

  Widget _milestonesSection() {
    if (widget.goal.milestones == null || widget.goal.milestones.length == 0) {
      return Container();
    }

    if (isOpen) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: widget.goal.milestones
              .map(
                (e) => Row(
                  key: Key(e.id),
                  children: [
                    GestureDetector(
                      onTap: () => _toggleMilestoneComplete(e),
                      child: Icon(
                        e.done == true ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(e.description, style: card_body),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Milestones completed', style: card_body),
            Text(
                '${widget.goal.milestones.where((element) => element.done == true).length} / ${widget.goal.milestones.length}',
                style: card_body),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if(!isOpen) {
          widget.collapseEvent?.emit();
          if(widget.onTap != null)
            widget.onTap(context);
        }

        isOpen = !isOpen;
      }),
      child: Card(
        color: widget.goal.theme,
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
                    Text(formatter.format(widget.goal.endDate),
                        style: card_body),
                    Text(widget.goal.complete ? 'Complete' : 'In progress',
                        style: card_body),
                  ],
                ),
              ),
              Container(
                child: Text(widget.goal.title, style: card_heading),
              ),
              widget.goal.description == null || widget.goal.description == ''
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(widget.goal.description, style: card_body)),
              _milestonesSection(),
              if (isOpen)
                ClickableText(
                  text: 'Edit Goal',
                  onClick: () => _openEditDialog(),
                  style: card_body,
                  margin: EdgeInsets.only(top: 10),
                  centered: true,
                ),
              if (isOpen)
                ClickableText(
                  text: widget.goal.complete ? 'Mark In Progress' : 'Mark Complete',
                  onClick: () => _toggleGoalComplete(),
                  style: card_body,
                  margin: EdgeInsets.only(top: 10),
                  centered: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
