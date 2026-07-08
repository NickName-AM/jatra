import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// One carved mark per festival: the wheel, the mask, the lamp, the
/// pole, the spout, the dumpling. Flat shapes, two inks, no more.
class GlyphPainter extends CustomPainter {
  GlyphPainter(this.id);

  final String id;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    final vermilion = Paint()..color = Jatra.vermilion;
    final marigold = Paint()..color = Jatra.marigold;
    final cream = Paint()..color = Jatra.cream;
    final marigoldStroke = Paint()
      ..color = Jatra.marigold
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.06;

    switch (id) {
      case 'indra': // The Lakhey mask.
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: c, width: s * 0.62, height: s * 0.74),
            Radius.circular(s * 0.18),
          ),
          vermilion,
        );
        // Mane arcs.
        for (var i = 0; i < 5; i++) {
          final a = math.pi * (0.75 + i * 0.125);
          canvas.drawCircle(
            c + Offset(math.cos(a), math.sin(a)) * (s * 0.42),
            s * 0.07,
            marigold,
          );
        }
        // Eyes and fangs.
        canvas.drawCircle(c + Offset(-s * 0.13, -s * 0.10), s * 0.07, cream);
        canvas.drawCircle(c + Offset(s * 0.13, -s * 0.10), s * 0.07, cream);
        final fangs = Path()
          ..moveTo(c.dx - s * 0.14, c.dy + s * 0.16)
          ..lineTo(c.dx - s * 0.08, c.dy + s * 0.30)
          ..lineTo(c.dx - s * 0.02, c.dy + s * 0.16)
          ..moveTo(c.dx + s * 0.02, c.dy + s * 0.16)
          ..lineTo(c.dx + s * 0.08, c.dy + s * 0.30)
          ..lineTo(c.dx + s * 0.14, c.dy + s * 0.16);
        canvas.drawPath(fangs..close(), cream);

      case 'mhapuja': // The diyo lamp on its mandala.
        canvas.drawCircle(c + Offset(0, s * 0.22), s * 0.30, marigoldStroke);
        canvas.drawPath(
          Path()
            ..moveTo(c.dx - s * 0.22, c.dy + s * 0.10)
            ..lineTo(c.dx + s * 0.22, c.dy + s * 0.10)
            ..lineTo(c.dx + s * 0.12, c.dy + s * 0.26)
            ..lineTo(c.dx - s * 0.12, c.dy + s * 0.26)
            ..close(),
          vermilion,
        );
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - s * 0.34)
            ..quadraticBezierTo(
                c.dx + s * 0.14, c.dy - s * 0.06, c.dx, c.dy + s * 0.08)
            ..quadraticBezierTo(
                c.dx - s * 0.14, c.dy - s * 0.06, c.dx, c.dy - s * 0.34)
            ..close(),
          marigold,
        );

      case 'yomari': // The long-tailed dumpling.
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - s * 0.42)
            ..quadraticBezierTo(c.dx + s * 0.06, c.dy - s * 0.18,
                c.dx + s * 0.22, c.dy - s * 0.02)
            ..quadraticBezierTo(
                c.dx + s * 0.40, c.dy + s * 0.16, c.dx + s * 0.20,
                c.dy + s * 0.32)
            ..quadraticBezierTo(
                c.dx, c.dy + s * 0.44, c.dx - s * 0.20, c.dy + s * 0.32)
            ..quadraticBezierTo(c.dx - s * 0.40, c.dy + s * 0.16,
                c.dx - s * 0.22, c.dy - s * 0.02)
            ..quadraticBezierTo(
                c.dx - s * 0.06, c.dy - s * 0.18, c.dx, c.dy - s * 0.42)
            ..close(),
          cream,
        );
        canvas.drawCircle(c + Offset(0, s * 0.14), s * 0.10, vermilion);

      case 'bisket': // The yosin pole and its two ropes.
        canvas.drawRect(
          Rect.fromCenter(
              center: c, width: s * 0.08, height: s * 0.80),
          marigold,
        );
        canvas.drawLine(c + Offset(0, -s * 0.38),
            c + Offset(-s * 0.34, s * 0.40), marigoldStroke);
        canvas.drawLine(c + Offset(0, -s * 0.38),
            c + Offset(s * 0.34, s * 0.40), marigoldStroke);
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - s * 0.44)
            ..lineTo(c.dx + s * 0.26, c.dy - s * 0.32)
            ..lineTo(c.dx, c.dy - s * 0.24)
            ..close(),
          vermilion,
        );

      case 'machhindranath': // The chariot wheel.
        canvas.drawCircle(c, s * 0.40, marigoldStroke);
        for (var i = 0; i < 8; i++) {
          final a = i * math.pi / 4;
          canvas.drawLine(
            c,
            c + Offset(math.cos(a), math.sin(a)) * (s * 0.38),
            marigoldStroke,
          );
        }
        canvas.drawCircle(c, s * 0.10, vermilion);

      case 'sithi': // The stone hiti spout and its water.
        canvas.drawPath(
          Path()
            ..moveTo(c.dx - s * 0.34, c.dy - s * 0.30)
            ..lineTo(c.dx + s * 0.10, c.dy - s * 0.30)
            ..lineTo(c.dx + s * 0.26, c.dy - s * 0.14)
            ..lineTo(c.dx - s * 0.34, c.dy - s * 0.14)
            ..close(),
          marigold,
        );
        for (var i = 0; i < 3; i++) {
          canvas.drawCircle(
            c + Offset(s * 0.16, s * (0.02 + i * 0.16)),
            s * 0.05,
            cream,
          );
        }
        canvas.drawRect(
          Rect.fromCenter(
              center: c + Offset(0, s * 0.40), width: s * 0.72, height: s * 0.06),
          vermilion,
        );
    }
  }

  @override
  bool shouldRepaint(GlyphPainter oldDelegate) => oldDelegate.id != id;
}
