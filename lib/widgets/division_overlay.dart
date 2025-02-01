import 'dart:math';

import 'package:flutter/material.dart';

class DivisionOverlay extends StatelessWidget {
  final int slices;


  const DivisionOverlay({super.key, required this.slices});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DivisionPainter(slices),
      child: Container(),
    );
  }
}

class DivisionPainter extends CustomPainter{
  final int slices;

  DivisionPainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 3;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY) * 0.8;

    for (int i = 0; i < slices; i++) {
      double angle = (2 * pi * i) / slices;
      double endX = centerX + radius * cos(angle);
      double endY = centerY + radius * sin(angle);
      canvas.drawLine(Offset(centerX, centerY), Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
