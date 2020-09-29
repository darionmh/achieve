import 'package:flutter/material.dart';
import 'package:goald/styles.dart';

class Toggle extends StatelessWidget {
  var text;
  var active;
  var onTap;

  Toggle({this.text, this.active, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: active ? primaryColor : Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(width: 1, color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(text, style: active ? accent_text_white : accent_text_primary),
        ),
      ),
    );
  }
}
