import 'package:flutter/material.dart';
import 'package:goald/add/add_milestone_tile.dart';
import 'package:goald/add/new_milestone_tile.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/reorderable_column.dart';

class AddMilestoneList extends StatefulWidget {
  final Function(List<Milestone>) onUpdate;

  AddMilestoneList({this.onUpdate});

  @override
  _AddMilestoneListState createState() => _AddMilestoneListState();
}

class _AddMilestoneListState extends State<AddMilestoneList> {
  final _milestones = <Milestone>[];

  Widget _buildColumn() {
    final children = <Widget>[];

    _milestones.forEach((milestone) {
      children.add(NewMilestoneTile(
        data: milestone,
        single: false,
        triggerDelete: (milestone) => setState(() {
          _milestones.remove(milestone);
          widget.onUpdate(_milestones);
          FocusScope.of(context).unfocus();
        }),
        onUpdate: (val) => setState(() => milestone.milestone = val),
      ));
    });

    children.add(
      AddMilestoneTile(
        single: children.length == 0,
        onClick: (context) => {
          setState(() {
            if (_milestones.length == 0 || _milestones.last.milestone != '') {
              _milestones.add(Milestone(done: false, milestone: ''));
              widget.onUpdate(_milestones);
              Scrollable.ensureVisible(context);
            }
          })
        },
      ),
    );

    return ReorderableColumn(
      children: children,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          var c = children.removeAt(oldIndex);
          children.insert(newIndex, c);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(top: 12), child: _buildColumn());
  }
}
