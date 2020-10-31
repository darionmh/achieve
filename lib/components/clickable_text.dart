import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final EdgeInsets margin;
  final text;
  final VoidCallback onClick;
  final TextStyle style;
  final bool centered;

  const ClickableText(
      {Key key, @required this.text, @required this.onClick, this.margin, this.style, this.centered = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        child: Text(text, style: style, textAlign: centered ? TextAlign.center : TextAlign.left,),
        onTap: () => onClick(),
      ),
    );
  }
}
