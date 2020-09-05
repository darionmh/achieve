import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:goald/milestone_divider.dart';
import 'package:goald/milestone_tile.dart';
import 'package:goald/models/milestone.dart';

class MilestoneList extends StatefulWidget {
  @override
  _MilestoneListState createState() => _MilestoneListState();
}

class _MilestoneListState extends State<MilestoneList> {
  bool _collapse = false;
  final _milestones = <Milestone>[];

  void initState() {
    final count = Random().nextInt(10);

    for (int i = 0; i < count; i++) {
      _milestones.add(Milestone(done: true, milestone: 'do the thing $i'));
    }

    _milestones.add(Milestone(
        done: false,
        milestone:
            'this is super long this this is super long this this is super long this this is super long this this is super long this '));
  }

  List<Widget> _buildToggle() {
    if (_collapse) {
      return [
        Text('Show Milestones'),
        Icon(Icons.arrow_drop_up),
      ];
    }

    return [
      Text('Hide Milestones'),
      Icon(Icons.arrow_drop_down),
    ];
  }

  Widget _buildStack() {
    final children = <Widget>[];

    var topOffset = 0.0;
    for (int i = 0; i < _milestones.length; i++) {
      final milestone = _milestones[i];
      final isLast = i >= _milestones.length - 1;

      children.add(Positioned(
        child: MilestoneTile(
          data: milestone,
        ),
        top: topOffset,
        height: 24,
        right: 0,
        left: 0,
      ));

      topOffset += 18;

      if (!isLast) {
        children.add(Positioned(
          child: MilestoneDivider(),
          top: topOffset,
          height: 24,
        ));

        topOffset += 12;
      }
    }

    return Stack(children: children);
  }

  Widget _buildColumn() {
    final children = <Widget>[];

    for (int i = 0; i < _milestones.length; i++) {
      final milestone = _milestones[i];
      final isLast = i >= _milestones.length - 1;

      children.add(MilestoneTile(
        data: milestone,
        isLast: isLast,
        single: _milestones.length == 1,
      ));

      if (!isLast) {
        children.add(MilestoneDivider());
      }
    }

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
