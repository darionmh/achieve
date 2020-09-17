import 'package:flutter/material.dart';
import 'package:goald/add/add_milestone_list.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';

class AddGoal extends StatefulWidget {
  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  GoalService _goalService = locator<AbstractGoalService>();

  var _title = '';
  var _goal = '';
  var _endDate = '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
  var _milestoneList = <Milestone>[];

  void _save(context) {
    setState(() {
      _goalService.add(Goal(
          title: _title,
          goal: _goal,
          endDate: _endDate,
          milestones: _milestoneList));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Column(
              children: [
                Text('Create New Goal'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (val) => _title = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Goal'),
                  onChanged: (val) => _goal = val,
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('End Date'),
                ),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365 * 100)),
                  lastDate: DateTime.now().add(Duration(days: 365 * 100)),
                  onDateChanged: (date) =>
                      _endDate = '${date.month}/${date.day}/${date.year}',
                ),
                Divider(
                  height: 32,
                  thickness: 2,
                ),
                Text('Milestones'),
                AddMilestoneList(
                  onUpdate: (val) => _milestoneList = val,
                ),
                ButtonBar(
                  children: [
                    RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.white,
                      textColor: Colors.purple[900],
                    ),
                    RaisedButton(
                      child: Text('Save'),
                      onPressed: () => _save(context),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
