import 'package:flutter/material.dart';
import 'package:goald/painters/line_painter.dart';

class AddMilestoneTile extends StatefulWidget {
  final bool single;
  final Function(BuildContext) onClick;

  const AddMilestoneTile(
      {key, this.single = true, this.onClick})
      : super(key: key);

  @override
  _AddMilestoneTileState createState() => _AddMilestoneTileState();
}

class _AddMilestoneTileState extends State<AddMilestoneTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomPaint(
            painter: LinePainter(
              lineColor: Theme.of(context).primaryColor,
              single: widget.single,
            ),
          ),
          GestureDetector(
            child: Icon(Icons.add_circle),
            onTap: () {
              widget.onClick(context);
            }
          ),
        ],
      ),
    );
  }
}