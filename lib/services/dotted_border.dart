import 'package:flutter/material.dart';

/// Paints a dashed border around the given canvas with the specified size.
///
/// The border is drawn using the provided [canvas] and the [size] of the canvas.
/// Dashes are drawn with a width of [dashWidth] and a space between each dash of [dashSpace].
/// The border is drawn with a black color and a stroke width of 2.

class DottedBorderPainter extends CustomPainter {
  final double dashWidth; // Width of each dash
  final double dashSpace; // Space between each dash
  final Color color;

  DottedBorderPainter({super.repaint, this.dashWidth = 5, this.dashSpace = 5, this.color = Colors.black});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw left border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
