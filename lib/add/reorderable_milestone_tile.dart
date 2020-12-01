import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';

class ReorderableMilestoneTile extends StatefulWidget {
  bool isFirst;
  bool isLast;
  Milestone milestone;
  Function(Milestone, int) onReorder;
  Function(String) onUpdate;
  VoidCallback delete;

  ReorderableMilestoneTile(
      {key,
      this.milestone,
      this.onReorder,
      this.onUpdate,
      this.delete,
      this.isFirst,
      this.isLast})
      : super(key: key);

  @override
  _ReorderableMilestoneTileState createState() =>
      _ReorderableMilestoneTileState();
}

class _ReorderableMilestoneTileState extends State<ReorderableMilestoneTile> {
  var globalPosition;
  var counter = 0;
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
    if (oldWidget.milestone.id != widget.milestone.id)
      _controller.text = widget.milestone.description;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: 16, bottom: 0, right: 0, left: 0),
              prefixIcon: GestureDetector(
                child: Icon(Icons.menu),
                onVerticalDragUpdate: (details) {
                  var lowerLimit = counter * 50;
                  var upperLimit = lowerLimit + 50;
                  print(
                      '$counter - $lowerLimit : ${details.localPosition.dy} : $upperLimit');
                  var dir = globalPosition.dy - details.globalPosition.dy < 0
                      ? 1
                      : -1;
                  globalPosition = details.globalPosition;
                  if ((details.localPosition.dy < lowerLimit && dir == -1) ||
                      (details.localPosition.dy > upperLimit && dir == 1)) {
                    if (dir == -1 && !widget.isFirst) {
                      counter += dir;
                      widget.onReorder(widget.milestone, dir);
                    } else if (dir == 1 && !widget.isLast) {
                      counter += dir;
                      widget.onReorder(widget.milestone, dir);
                    }
                  }
                },
                onVerticalDragStart: (details) => setState(() {
                  counter = 0;
                  globalPosition = details.globalPosition;
                }),
              ),
              suffixIcon: GestureDetector(
                child: Icon(Icons.close),
                onTap: widget.delete,
              )),
//        focusNode: f,
          onChanged: (val) =>
              setState(() => widget.milestone.description = val),
        ),
      ),
    );
  }
}
