import 'package:flutter/material.dart';
import 'package:goald/add/reorderable_milestone_tile.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/styles.dart';

class ReorderableMilestoneList extends StatefulWidget {
  var milestoneList;
  Function(Milestone, int) onReorder;
  Function(int, String) onUpdate;
  Function(int) delete;

  ReorderableMilestoneList({this.milestoneList, this.onReorder, this.onUpdate, this.delete});

  @override
  _ReorderableMilestoneListState createState() =>
      _ReorderableMilestoneListState();
}

class _ReorderableMilestoneListState extends State<ReorderableMilestoneList> {

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

    for(var i =0;i<widget.milestoneList.length;i++) {
      var e = widget.milestoneList[i];

      rows.add(
        ReorderableMilestoneTile(
          key: Key(e.id),
          milestone: e,
          onReorder: (item, dir) => widget.onReorder(item, dir),
          onUpdate: (val) => widget.onUpdate(i, val),
          delete: () => widget.delete(i),
          isFirst: i == 0,
          isLast: i == widget.milestoneList.length - 1
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
