import 'package:flutter/material.dart';

/// Cuts a rounded rectangular hole out of a full-screen overlay path.
class InvertedSpotlightClipper extends CustomClipper<Path> {
  InvertedSpotlightClipper({
    required this.spotlightRect,
    required this.borderRadius,
  });

  final Rect spotlightRect;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          spotlightRect,
          Radius.circular(borderRadius),
        ),
      );
    return Path.combine(PathOperation.difference, outer, hole);
  }

  @override
  bool shouldReclip(covariant InvertedSpotlightClipper oldClipper) {
    return oldClipper.spotlightRect != spotlightRect ||
        oldClipper.borderRadius != borderRadius;
  }
}
