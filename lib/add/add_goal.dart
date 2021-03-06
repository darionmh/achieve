import 'package:flutter/material.dart';
import 'package:goald/add/add_milestone_list.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';

class AddGoal extends StatefulWidget {
  final Goal data;

  const AddGoal({Key key, this.data}) : super(key: key);

  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  var _title = '';
  var _goal = '';
  var _endDate =
      '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
  var _milestoneList = <Milestone>[];

  @override
  void initState() {
    if (widget.data != null) {
      _title = widget.data.title;
      _goal = widget.data.goal;
      _endDate = widget.data.endDate;
      _milestoneList = widget.data.milestones;
    }

    super.initState();
  }

  void _save(context) {
    setState(() {
      if (widget.data == null) {
        _goalService.add(Goal(
            title: _title,
            goal: _goal,
            endDate: _endDate,
            milestones: _milestoneList));
      } else {
        widget.data.title = _title;
        widget.data.goal = _goal;
        widget.data.endDate = _endDate;
        widget.data.milestones = _milestoneList;

        _goalService.update(widget.data);
      }

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
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Column(
              children: [
                Container(
                  child: Text('Create New Goal'),
                  margin: EdgeInsets.only(top: 15),
                ),
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
