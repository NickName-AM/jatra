import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// The mandala under everything. Eightfold, like the Ashta Matrika
/// shrines that ring the old cities. It idles slowly, spins under a
/// finger, and coasts on real friction when flung.
class MandalaPainter extends CustomPainter {
  MandalaPainter({required this.rotation, this.dim = false});

  final double rotation;
  final bool dim;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    final marigold = Paint()
      ..color = dim ? Jatra.marigold.withValues(alpha: 0.35) : Jatra.marigold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final vermilion = Paint()
      ..color = dim ? Jatra.vermilion.withValues(alpha: 0.35) : Jatra.vermilion
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final marigoldFill = Paint()
      ..color = dim ? Jatra.marigold.withValues(alpha: 0.35) : Jatra.marigold;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // Outer rim and its sixteen beads.
    canvas.drawCircle(Offset.zero, r * 0.98, marigold);
    for (var i = 0; i < 16; i++) {
      final a = i * math.pi / 8;
      canvas.drawCircle(
        Offset(math.cos(a), math.sin(a)) * (r * 0.90),
        r * 0.018,
        marigoldFill,
      );
    }

    // Eight petals, drawn as paired arcs meeting in a point.
    final petal = Path();
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final tip = Offset(math.cos(a), math.sin(a)) * (r * 0.82);
      final base1 =
          Offset(math.cos(a - 0.28), math.sin(a - 0.28)) * (r * 0.44);
      final base2 =
          Offset(math.cos(a + 0.28), math.sin(a + 0.28)) * (r * 0.44);
      final mid1 =
          Offset(math.cos(a - 0.22), math.sin(a - 0.22)) * (r * 0.68);
      final mid2 =
          Offset(math.cos(a + 0.22), math.sin(a + 0.22)) * (r * 0.68);
      petal
        ..moveTo(base1.dx, base1.dy)
        ..quadraticBezierTo(mid1.dx, mid1.dy, tip.dx, tip.dy)
        ..quadraticBezierTo(mid2.dx, mid2.dy, base2.dx, base2.dy);
    }
    canvas.drawPath(petal, vermilion);

    // Inner ring, eight spokes, and the still center.
    canvas.drawCircle(Offset.zero, r * 0.44, marigold);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4 + math.pi / 8;
      canvas.drawLine(
        Offset(math.cos(a), math.sin(a)) * (r * 0.16),
        Offset(math.cos(a), math.sin(a)) * (r * 0.42),
        vermilion,
      );
    }
    canvas.drawCircle(Offset.zero, r * 0.16, marigold);
    canvas.drawCircle(Offset.zero, r * 0.05, marigoldFill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MandalaPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.dim != dim;
}
