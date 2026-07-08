import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// The living scene of each festival. [t] loops 0..1 forever; every
/// motion in here is a phase of that one breath, so nothing ever
/// jumps when the loop wraps.
class ScenePainter extends CustomPainter {
  ScenePainter({required this.id, required this.t});

  final String id;
  final double t;

  double get _phase => t * 2 * math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final ground = Paint()..color = Jatra.marigold;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.06, size.height * 0.88,
          size.width * 0.88, 3),
      ground,
    );

    switch (id) {
      case 'machhindranath':
        _chariot(canvas, size);
      case 'bisket':
        _pole(canvas, size);
      case 'indra':
        _lakhey(canvas, size);
      case 'mhapuja':
        _lamps(canvas, size);
      case 'yomari':
        _steam(canvas, size);
      case 'sithi':
        _hiti(canvas, size);
    }
  }

  /// Patan: the six-storey spire sways as it is pulled; the wheels turn.
  void _chariot(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final base = Offset(w / 2, h * 0.88);
    final sway = math.sin(_phase) * 0.035;

    // Wheels roll with the pull.
    final wheel = Paint()
      ..color = Jatra.marigold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (final dx in [-w * 0.13, w * 0.13]) {
      final c = base + Offset(dx, -h * 0.05);
      canvas.drawCircle(c, h * 0.05, wheel);
      for (var i = 0; i < 4; i++) {
        final a = _phase * 0.5 + i * math.pi / 2;
        canvas.drawLine(
          c,
          c + Offset(math.cos(a), math.sin(a)) * (h * 0.045),
          wheel,
        );
      }
    }

    // The tower leans from its base, storey by storey.
    canvas.save();
    canvas.translate(base.dx, base.dy - h * 0.10);
    canvas.rotate(sway);
    final body = Paint()..color = Jatra.vermilion;
    final trim = Paint()..color = Jatra.marigold;
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(0, -h * 0.06), width: w * 0.34, height: h * 0.12),
      body,
    );
    for (var i = 0; i < 5; i++) {
      final width = w * (0.26 - i * 0.045);
      final y = -h * (0.16 + i * 0.115);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(0, y), width: width, height: h * 0.085),
        i.isEven ? trim : body,
      );
    }
    canvas.drawPath(
      Path()
        ..moveTo(0, -h * 0.80)
        ..lineTo(w * 0.035, -h * 0.70)
        ..lineTo(-w * 0.035, -h * 0.70)
        ..close(),
      trim,
    );
    canvas.restore();
  }

  /// Bhaktapur: the yosin pole rocks as the two towns pull.
  void _pole(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final foot = Offset(w / 2, h * 0.88);
    final lean = math.sin(_phase) * 0.10;

    canvas.save();
    canvas.translate(foot.dx, foot.dy);
    canvas.rotate(lean);
    canvas.drawRect(
      Rect.fromLTWH(-w * 0.012, -h * 0.74, w * 0.024, h * 0.74),
      Paint()..color = Jatra.marigold,
    );
    // The banner streams opposite the lean.
    canvas.drawPath(
      Path()
        ..moveTo(0, -h * 0.72)
        ..lineTo(-w * 0.16 * (lean > 0 ? 1 : -1), -h * 0.66)
        ..lineTo(0, -h * 0.60)
        ..close(),
      Paint()..color = Jatra.vermilion,
    );
    canvas.restore();

    // The two ropes, taut on the pulling side, slack on the other.
    final rope = Paint()
      ..color = Jatra.cream
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final top = foot + Offset(math.sin(lean) * -h * 0.7, -h * 0.70);
    for (final side in [-1, 1]) {
      final anchor = Offset(w * (0.5 + side * 0.38), h * 0.88);
      final pull = (side < 0) == (lean < 0);
      final sag = pull ? 0.0 : h * 0.06;
      final mid = Offset((top.dx + anchor.dx) / 2, (top.dy + anchor.dy) / 2 + sag);
      canvas.drawPath(
        Path()
          ..moveTo(top.dx, top.dy)
          ..quadraticBezierTo(mid.dx, mid.dy, anchor.dx, anchor.dy),
        rope,
      );
    }
  }

  /// Kathmandu: the Lakhey bobs to drums only he can hear.
  void _lakhey(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bob = math.sin(_phase * 2) * h * 0.03;
    final tilt = math.sin(_phase) * 0.06;
    final c = Offset(w / 2, h * 0.46 + bob);

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(tilt);

    // Mane: petals that shiver at their own tempo.
    for (var i = 0; i < 9; i++) {
      final a = math.pi * (0.65 + i * 0.0875);
      final shiver = math.sin(_phase * 2 + i) * h * 0.012;
      canvas.drawCircle(
        Offset(math.cos(a), math.sin(a)) * (h * 0.30 + shiver),
        h * 0.055,
        Paint()..color = Jatra.marigold,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: h * 0.40, height: h * 0.48),
        Radius.circular(h * 0.10),
      ),
      Paint()..color = Jatra.vermilion,
    );
    final eye = Paint()..color = Jatra.cream;
    canvas.drawCircle(Offset(-h * 0.09, -h * 0.07), h * 0.05, eye);
    canvas.drawCircle(Offset(h * 0.09, -h * 0.07), h * 0.05, eye);
    final pupil = Paint()..color = Jatra.soot;
    final look = Offset(math.sin(_phase) * h * 0.015, 0);
    canvas.drawCircle(Offset(-h * 0.09, -h * 0.07) + look, h * 0.02, pupil);
    canvas.drawCircle(Offset(h * 0.09, -h * 0.07) + look, h * 0.02, pupil);
    canvas.drawPath(
      Path()
        ..moveTo(-h * 0.10, h * 0.10)
        ..lineTo(-h * 0.05, h * 0.20)
        ..lineTo(0, h * 0.10)
        ..lineTo(h * 0.05, h * 0.20)
        ..lineTo(h * 0.10, h * 0.10)
        ..close(),
      eye,
    );
    canvas.restore();
  }

  /// A family floor: one lamp per person, each flame keeping its own time.
  void _lamps(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    for (var i = 0; i < 3; i++) {
      final x = w * (0.25 + i * 0.25);
      final base = Offset(x, h * 0.72);
      final flick = math.sin(_phase * 3 + i * 2.1);

      canvas.drawCircle(
        base + Offset(0, h * 0.05),
        h * 0.16,
        Paint()
          ..color = Jatra.marigold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawPath(
        Path()
          ..moveTo(base.dx - w * 0.055, base.dy)
          ..lineTo(base.dx + w * 0.055, base.dy)
          ..lineTo(base.dx + w * 0.03, base.dy + h * 0.05)
          ..lineTo(base.dx - w * 0.03, base.dy + h * 0.05)
          ..close(),
        Paint()..color = Jatra.vermilion,
      );

      // The flame: height and lean both breathe.
      final tipY = base.dy - h * (0.16 + 0.02 * flick);
      final lean = w * 0.008 * math.sin(_phase * 2 + i);
      canvas.drawPath(
        Path()
          ..moveTo(base.dx + lean, tipY)
          ..quadraticBezierTo(base.dx + w * 0.03, base.dy - h * 0.05,
              base.dx, base.dy - h * 0.005)
          ..quadraticBezierTo(base.dx - w * 0.03, base.dy - h * 0.05,
              base.dx + lean, tipY)
          ..close(),
        Paint()..color = Jatra.marigold,
      );
    }
  }

  /// The December full moon, and steam off the season's first yomari.
  void _steam(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(
      Offset(w * 0.76, h * 0.24),
      h * 0.14,
      Paint()..color = Jatra.cream,
    );

    // The yomari on its plate.
    final c = Offset(w * 0.38, h * 0.62);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy - h * 0.26)
        ..quadraticBezierTo(c.dx + w * 0.10, c.dy - h * 0.04,
            c.dx + w * 0.09, c.dy + h * 0.10)
        ..quadraticBezierTo(c.dx, c.dy + h * 0.20, c.dx - w * 0.09, c.dy + h * 0.10)
        ..quadraticBezierTo(c.dx - w * 0.10, c.dy - h * 0.04, c.dx, c.dy - h * 0.26)
        ..close(),
      Paint()..color = Jatra.cream,
    );
    canvas.drawRect(
      Rect.fromCenter(
          center: c + Offset(0, h * 0.22), width: w * 0.26, height: 3.5),
      Paint()..color = Jatra.vermilion,
    );

    // Three wisps, each a phase apart, rising and thinning.
    for (var i = 0; i < 3; i++) {
      final progress = (t + i / 3) % 1.0;
      final rise = progress * h * 0.34;
      final alpha = (1 - progress) * 0.8;
      final x = c.dx + (i - 1) * w * 0.05;
      final y0 = c.dy - h * 0.28 - rise;
      canvas.drawPath(
        Path()
          ..moveTo(x, y0 + h * 0.10)
          ..quadraticBezierTo(x + w * 0.03 * math.sin(_phase + i), y0 + h * 0.05,
              x, y0),
        Paint()
          ..color = Jatra.faded.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  /// The stone spout runs and the pond ripples, ready for monsoon.
  void _hiti(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mouth = Offset(w * 0.40, h * 0.34);

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.10, h * 0.22)
        ..lineTo(mouth.dx, h * 0.22)
        ..lineTo(mouth.dx + w * 0.07, mouth.dy)
        ..lineTo(w * 0.10, mouth.dy)
        ..close(),
      Paint()..color = Jatra.marigold,
    );

    // Falling water: beads on a cycle, faster than the pond below.
    final drop = Paint()..color = Jatra.cream;
    final spout = mouth + Offset(w * 0.055, 0);
    final fallH = h * 0.44;
    for (var i = 0; i < 4; i++) {
      final p = (t * 2 + i / 4) % 1.0;
      canvas.drawCircle(
        spout + Offset(0, fallH * p),
        w * 0.012 * (1 + p * 0.5),
        drop,
      );
    }

    // Ripples widen where the water lands, then let go.
    final landing = spout + Offset(0, fallH + h * 0.04);
    for (var i = 0; i < 3; i++) {
      final p = (t + i / 3) % 1.0;
      canvas.drawOval(
        Rect.fromCenter(
          center: landing,
          width: w * 0.30 * p,
          height: h * 0.055 * p,
        ),
        Paint()
          ..color = Jatra.cream.withValues(alpha: (1 - p) * 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(ScenePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.id != id;
}
