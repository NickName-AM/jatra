import 'package:flutter/material.dart';

import '../data/festivals.dart';
import '../painters/glyphs.dart';
import '../painters/scenes.dart';
import '../theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.festival});

  final Festival festival;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  /// One breath of the scene, four seconds, looping seamlessly.
  late final AnimationController _scene = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  /// The page reveals itself section by section.
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..forward();

  @override
  void dispose() {
    _scene.dispose();
    _reveal.dispose();
    super.dispose();
  }

  /// Fade-and-rise for the [index]th section of the page.
  Widget _section({required int index, required Widget child}) {
    final slot = CurvedAnimation(
      parent: _reveal,
      curve: Interval(
        (index * 0.12).clamp(0.0, 0.7),
        (0.45 + index * 0.12).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return FadeTransition(
      opacity: slot,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.10), end: Offset.zero)
            .animate(slot),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final festival = widget.festival;
    final days = festival.daysUntil(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
          children: [
            _section(
              index: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Jatra.faded,
                    padding: EdgeInsets.zero,
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: Text('THE ALMANAC', style: label(size: 10)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _section(
              index: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'glyph-${festival.id}',
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: CustomPaint(painter: GlyphPainter(festival.id)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(festival.name, style: display(size: 30)),
                        Text(festival.newari,
                            style:
                                display(size: 18, color: Jatra.vermilion)),
                        const SizedBox(height: 6),
                        Text(
                          '${festival.place}\n${festival.season}'
                              .toUpperCase(),
                          style: label(
                              size: 10,
                              color: Jatra.faded,
                              letterSpacing: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _section(
              index: 2,
              child: Text(
                festival.tagline,
                style: body(size: 19, color: Jatra.marigold, height: 1.35),
              ),
            ),
            const SizedBox(height: 20),
            _section(
              index: 3,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Jatra.surface,
                  border: Border.all(color: Jatra.marigold, width: 1.5),
                ),
                // The scene repaints sixty times a second; keep its
                // layer to itself so the text never repaints with it.
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _scene,
                    builder: (_, _) => CustomPaint(
                      size: Size.infinite,
                      painter:
                          ScenePainter(id: festival.id, t: _scene.value),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _section(
              index: 4,
              child: Row(
                children: [
                  SizedBox(
                    width: 92,
                    height: 92,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: (1 - days / 366).clamp(0.0, 1.0),
                      ),
                      duration: const Duration(milliseconds: 1100),
                      curve: Curves.easeOutCubic,
                      builder: (_, sweep, _) => CustomPaint(
                        painter: _CountdownArc(sweep: sweep),
                        child: Center(
                          child: Text(devanagari(days),
                              style: display(
                                  size: 24, color: Jatra.marigold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DAYS TO GO', style: label(size: 11)),
                        const SizedBox(height: 4),
                        Text(
                          'The wheel fills as the festival nears. '
                          'Dates follow the moon; this one is close, '
                          'not carved.',
                          style: body(size: 13, color: Jatra.faded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            for (final (i, paragraph) in festival.story.indexed)
              _section(
                index: 5 + i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(paragraph, style: body(size: 15.5)),
                ),
              ),
            const SizedBox(height: 8),
            _section(
              index: 5 + festival.story.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WHAT TO WATCH FOR', style: label(size: 11)),
                  const SizedBox(height: 10),
                  for (final ritual in festival.rituals)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 7),
                            color: Jatra.vermilion,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(ritual, style: body(size: 14.5)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The countdown drawn as a filling prayer wheel: a full ring is a
/// festival at the door.
class _CountdownArc extends CustomPainter {
  _CountdownArc({required this.sweep});

  final double sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..color = Jatra.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final fill = Paint()
      ..color = Jatra.marigold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(4), 0, 2 * 3.1415926, false, track);
    canvas.drawArc(
      rect.deflate(4),
      -3.1415926 / 2,
      2 * 3.1415926 * sweep,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(_CountdownArc oldDelegate) =>
      oldDelegate.sweep != sweep;
}
