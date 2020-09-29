import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {

  Function(int) onTap;
  List<NavigationItem> items;
  int currentIndex;

  NavigationBar({this.onTap, this.items, this.currentIndex});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  List<Widget> _buildRow() {
    var items = <Widget>[];
    for(var i=0;i<widget.items.length;i++) {
      var item = widget.items[i];
      items.add(IconButton(
        onPressed: () => widget.onTap(i),
        icon: item.icon,
        iconSize: 28,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildRow(),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class NavigationItem {
  Widget icon;

  NavigationItem({this.icon});
}