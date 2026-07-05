import 'package:flutter/material.dart';

/// Paints a filled tooltip pointer triangle.
class SpotlightArrowPainter extends CustomPainter {
  SpotlightArrowPainter({
    required this.color,
    required this.isUpArrow,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  final Color color;
  final bool isUpArrow;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (isUpArrow) {
      path
        ..moveTo(0, size.height)
        ..lineTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..close();
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close();
    }
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant SpotlightArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isUpArrow != isUpArrow;
  }
}
