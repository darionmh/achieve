import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:goald/add/add_milestone_tile.dart';
import 'package:goald/add/remove_milestone_tile.dart';
import 'package:goald/milestone_divider.dart';
import 'package:goald/milestone_tile.dart';
import 'package:goald/models/milestone.dart';

class AddMilestoneList extends StatefulWidget {
  @override
  _AddMilestoneListState createState() => _AddMilestoneListState();
}

class _AddMilestoneListState extends State<AddMilestoneList> {
  final _milestones = <Milestone>[];

  Widget _buildColumn() {
    final children = <Widget>[];

    _milestones.forEach((milestone) {
      children.add(RemoveMilestoneTile(
        data: milestone,
        single: false,
        triggerDelete: (milestone) => setState(() => _milestones.remove(milestone)),
      ));
    });

    children.add(
      AddMilestoneTile(
        single: children.length == 0,
        onClick: () => {
          setState(() {
            this._milestones.add(Milestone(done: false, milestone: ''));
          })
        },
      ),
    );

    return ColumnSuper(
      children: children,
      alignment: Alignment.centerLeft,
      innerDistance: -4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: SizedBox(
        child: _buildColumn(),
      ),
    );
  }
}
