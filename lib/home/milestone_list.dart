import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:goald/milestone_divider.dart';
import 'package:goald/milestone_tile.dart';
import 'package:goald/models/milestone.dart';

class MilestoneList extends StatefulWidget {
  final List<Milestone> milestones;

  const MilestoneList({Key key, this.milestones}) : super(key: key);

  @override
  _MilestoneListState createState() => _MilestoneListState();
}

class _MilestoneListState extends State<MilestoneList> {

  void initState() {
    super.initState();

    print(widget.milestones);
  }
  
  Widget _buildColumn() {
    final children = <Widget>[];

    for (int i = 0; i < widget.milestones.length; i++) {
      final milestone = widget.milestones[i];
      final isLast = i >= widget.milestones.length - 1;

      children.add(MilestoneTile(
        data: milestone,
        isLast: isLast,
        single: widget.milestones.length == 1,
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
