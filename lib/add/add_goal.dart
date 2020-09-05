import 'package:flutter/material.dart';
import 'package:goald/add/add_milestone_list.dart';

class AddGoal extends StatefulWidget {
  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
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
          children: [
            Column(
              children: [
                Text('Create New Goal'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Goal'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('End Date'),
                ),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365 * 100)),
                  lastDate: DateTime.now().add(Duration(days: 365 * 100)),
                  onDateChanged: (date) => print(date),
                ),
                Divider(
                  height: 32,
                  thickness: 2,
                ),
                Text('Milestones'),
                AddMilestoneList(),
                ButtonBar(
                  children: [
                    RaisedButton(
                      child: Text('Cancel'),
                    ),
                    RaisedButton(
                      child: Text('Save'),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
