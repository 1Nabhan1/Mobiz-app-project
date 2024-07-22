import 'dart:ui';

import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter({
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.reduce((a, b) => a + b);
    double startAngle = -90.0;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 360;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        radians(startAngle),
        radians(sweepAngle),
        true,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Draw black circle in the center
    final centerCircleRadius = size.width / 4;
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      centerCircleRadius,
      paint,
    );

    // Draw total value text in the center
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Total',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  double radians(double degrees) {
    return degrees * (3.1415926535897932 / 180.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
