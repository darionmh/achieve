import 'package:flutter/material.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/components/toggle.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';

class FullGoalList extends StatefulWidget {
  @override
  _FullGoalListState createState() => _FullGoalListState();
}

class _FullGoalListState extends State<FullGoalList> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  bool filterComplete = true;
  bool filterInProgress = true;

  List<String> sortFields = ['End Date', 'Date Completed', 'Completion'];
  List<String> sortOrders = ['Ascending', 'Descending'];

  var sortField;
  var sortOrder;

  List<Goal> goals = [];

  @override
  void initState() {
    sortField = sortFields[0];
    sortOrder = sortOrders[0];

    goals = _goalService.getAllGoals();

    super.initState();
  }

  void _toggleFilterComplete() {
    setState(() => filterComplete = !filterComplete);
  }

  void _toggleFilterInProgress() {
    setState(() => filterInProgress = !filterInProgress);
  }

  void _setSort(field, order) {
    setState(() {
      sortField = field;
      sortOrder = order;
    });
  }

  List<Widget> _buildCards(List<Goal> goals) {
    if (goals == null) return <Widget>[Text('Loading...')];

    var temp = goals.toList();

    temp = temp.where((element) => filterInProgress && !element.complete || filterComplete && element.complete).toList();

    temp.sort((a, b) {
      if (sortField == 'End Date') {
        return a.endDate.compareTo(b.endDate);
      }

      if (sortField == 'Date Completed') {
        return a.dateCompleted.compareTo(b.dateCompleted);
      }

      if (sortField == 'Completion') {
        return a.complete ? -1 : b.complete ? 1 : 0;
      }

      return 0;
    });

    if (sortOrder == 'Descending') {
      return temp.reversed.map((e) => GoalCard(goal: e)).toList();
    }

    return temp.map((e) => GoalCard(goal: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // var goals = Provider.of<List<Goal>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 25, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'All goals',
              //   style: heading,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    Text(
                      'Filter',
                      style: small_heading,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Toggle(
                        text: 'Complete',
                        active: filterComplete,
                        onTap: _toggleFilterComplete,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Toggle(
                        text: 'In progress',
                        active: filterInProgress,
                        onTap: _toggleFilterInProgress,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Sort',
                    style: small_heading,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      style: accent_text_primary,
                      items: sortFields.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: accent_text_primary,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => _setSort(val, sortOrder),
                      value: sortField,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      style: accent_text_primary,
                      items: sortOrders.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: accent_text_primary,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => _setSort(sortField, val),
                      value: sortOrder,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: _buildCards(goals),
          ),
        ),
      ],
    );
  }
}
