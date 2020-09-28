import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final EdgeInsets margin;
  final text;
  final VoidCallback onClick;

  const ClickableText(
      {Key key, @required this.text, @required this.onClick, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        child: Text(text),
        onTap: () => onClick(),
      ),
    );
  }
}
