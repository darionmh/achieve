import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/painters/line_painter.dart';

class RemoveMilestoneTile extends StatefulWidget {
  final Milestone data;
  final bool single;
  final Function triggerDelete;

  const RemoveMilestoneTile({key, @required this.data, this.single = true, this.triggerDelete})
      : super(key: key);

  @override
  _RemoveMilestoneTileState createState() => _RemoveMilestoneTileState();
}

class _RemoveMilestoneTileState extends State<RemoveMilestoneTile> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomPaint(
            painter: LinePainter(
                lineColor: Theme.of(context).primaryColor,
                single: widget.single,
                isLast: false),
          ),
          GestureDetector(
            child: Icon(Icons.remove_circle_outline),
            onTap: () => widget.triggerDelete(widget.data),
          ),
          Flexible(
            child: Container(
              height: 48,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: TextFormField(
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.menu),
                    // onTap: () => setState(() => widget.data.done = !widget.data.done),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
