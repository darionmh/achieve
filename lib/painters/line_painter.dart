import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  Color lineColor;
  bool isLast;
  bool single;
  

  LinePainter({this.lineColor, this.isLast = true, this.single = true});

  @override
  void paint(Canvas canvas, Size size) {
    if (!single) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 2;

      if (!this.isLast) {
        final p1 = Offset(12, size.height / 2 + 8);
        final p2 = Offset(12, size.height + 12);

        canvas.drawLine(p1, p2, paint);
      } else {
        final p1 = Offset(12, size.height / 2 - 8);
        final p2 = Offset(12, 0);

        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}