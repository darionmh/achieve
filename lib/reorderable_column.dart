import 'package:flutter/material.dart';

class ReorderableColumn extends StatefulWidget {
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderableColumn({key, this.children, @required this.onReorder})
      : super(key: key);

  @override
  _ReorderableColumnState createState() => _ReorderableColumnState();
}

class _ReorderableColumnState extends State<ReorderableColumn> {
  Widget _currentlyMoving;

  void _handleMove(LongPressMoveUpdateDetails details) {
    var index = widget.children.indexOf(_currentlyMoving);
    if (details.localOffsetFromOrigin.dy <= -50 && index > 0) {
      widget.onReorder(index, index - 1);
    } else if (details.localOffsetFromOrigin.dy >= 50 &&
        index < widget.children.length - 1) {
      widget.onReorder(index, index + 1);
    }
  }

  // TODO: make this reorderable
  List<Widget> _mapChildren() {
    return widget.children
        .map(
          (child) => GestureDetector(
            child: child,
            onLongPressMoveUpdate: (details) => setState(() {
              // _handleMove(details);
            }),
            onLongPressStart: (details) => setState(() {
              // if (_currentlyMoving == null) _currentlyMoving = child;
            }),
            onLongPressEnd: (details) => setState(() {
              // _currentlyMoving = null;
            }),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: new SliverChildListDelegate(_mapChildren()),
        )
      ],
    );
  }
}
