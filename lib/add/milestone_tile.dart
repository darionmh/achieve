import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';

class MilestoneTile extends StatefulWidget {

  Milestone milestone;
  Function(String) onUpdate;
  VoidCallback delete;

  MilestoneTile({key, this.milestone, this.onUpdate, this.delete}) : super(key: key);

  @override
  _MilestoneTileState createState() =>
      _MilestoneTileState();
}

class _MilestoneTileState extends State<MilestoneTile> {

  var _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.milestone.description;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 16, bottom: 0, right: 0, left: 0),
            suffixIcon: GestureDetector(
              child: Icon(Icons.close),
              onTap: widget.delete,
            )
        ),
        onChanged: (val) => widget.onUpdate(val),
      ),
    );
  }
}
