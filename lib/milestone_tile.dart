import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/painters/line_painter.dart';

class MilestoneTile extends StatefulWidget {
  final Milestone data;
  final bool isLast;
  final bool single;

  const MilestoneTile(
      {key, @required this.data, this.isLast = false, this.single = true})
      : super(key: key);

  @override
  _MilestoneTileState createState() => _MilestoneTileState();
}

class _MilestoneTileState extends State<MilestoneTile> {
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
              isLast: widget.isLast,
              single: widget.single,
            ),
          ),
          GestureDetector(
            child: Icon(widget.data.done
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
            onTap: () => setState(() => widget.data.done = !widget.data.done),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Text(
                widget.data.milestone,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}