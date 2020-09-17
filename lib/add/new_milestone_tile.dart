import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/painters/line_painter.dart';

class NewMilestoneTile extends StatefulWidget {
  final Milestone data;
  final bool single;
  final Function triggerDelete;
  final Function(String) onUpdate;

  const NewMilestoneTile({key, @required this.data, this.single = true, this.triggerDelete, this.onUpdate})
      : super(key: key);

  @override
  _NewMilestoneTileState createState() => _NewMilestoneTileState();
}

class _NewMilestoneTileState extends State<NewMilestoneTile> {
  FocusNode f = FocusNode();

  @override
  void initState() {
    f.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

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
                focusNode: f,
                onChanged: (val) => widget.onUpdate(val),
              ),
              // child: Text(widget.data.milestone),
            ),
          ),
        ],
      ),
    );
  }
}
