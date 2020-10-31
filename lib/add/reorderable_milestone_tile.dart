import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';

class ReorderableMilestoneTile extends StatefulWidget {

  Milestone milestone;
  Function(Milestone, int) onReorder;
  Function(String) onUpdate;
  VoidCallback delete;

  ReorderableMilestoneTile({this.milestone, this.onReorder, this.onUpdate, this.delete});

  @override
  _ReorderableMilestoneTileState createState() =>
      _ReorderableMilestoneTileState();
}

class _ReorderableMilestoneTileState extends State<ReorderableMilestoneTile> {

  var globalPosition;
  var _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.milestone.description;
    _controller.addListener(() {
      widget.onUpdate(_controller.text);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(ReorderableMilestoneTile oldWidget) {
    if(oldWidget.milestone.id != widget.milestone.id)
      _controller.text = widget.milestone.description;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 0),
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 16, bottom: 0, right: 0, left: 0),
//            prefixIcon: GestureDetector(
//              child: Icon(Icons.menu),
//              onVerticalDragUpdate: (details) {
//                if((globalPosition.dy - details.globalPosition.dy).abs() >= 18) {
//                  var dir = globalPosition.dy - details.globalPosition.dy < 0 ? 1 : -1;
//                  print('move $dir ${widget.milestone.toString()??'null'}');
//                  widget.onReorder(widget.milestone, dir);
//                }
//              },
//              onVerticalDragStart: (details) => globalPosition = details.globalPosition,
//            ),
            suffixIcon: GestureDetector(
              child: Icon(Icons.close),
              onTap: widget.delete,
            )
          ),
//        focusNode: f,
          onChanged: (val) => setState(() => widget.milestone.description = val),
        ),
      ),
    );
  }
}
