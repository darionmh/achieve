import 'package:flutter/material.dart';
import 'package:goald/add/milestone_tile.dart';
import 'package:goald/add/reorderable_milestone_tile.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/styles.dart';

class MilestoneList extends StatefulWidget {
  List<Milestone> milestoneList;
  Function(String, String) onUpdate;
  Function(String) delete;

  MilestoneList({this.milestoneList, this.onUpdate, this.delete});

  @override
  _MilestoneListState createState() => _MilestoneListState();
}

class _MilestoneListState extends State<MilestoneList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  List<Widget> _buildMilestoneRows() {
    List<Widget> rows = <Widget>[];

    for (var i = 0; i < widget.milestoneList.length; i++) {
      Milestone e = widget.milestoneList[i];

      rows.add(
        MilestoneTile(
          key: Key(e.id),
          milestone: e,
          onUpdate: (val) => widget.onUpdate(e.id, val),
          delete: () {
            widget.delete(e.id);
          },
        ),
      );

      rows.add(
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
          child: Divider(
            color: primaryColor,
            height: 4,
          ),
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildMilestoneRows(),
    );
  }
}
