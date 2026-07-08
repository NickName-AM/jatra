import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../data/festivals.dart';
import '../painters/glyphs.dart';
import '../painters/mandala.dart';
import '../theme.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  /// Finger-driven rotation, unbounded so a fling can coast forever.
  late final AnimationController _spin =
      AnimationController.unbounded(vsync: this);

  /// The mandala never fully rests: one slow turn every ninety seconds.
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 90),
  )..repeat();

  /// Entrance choreography for the festival cards.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    _spin.dispose();
    _idle.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _openFestival(Festival festival) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, animation, _) => DetailScreen(festival: festival),
        transitionsBuilder: (_, animation, _, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _MandalaHeader(
              spin: _spin,
              idle: _idle,
              topPadding: MediaQuery.of(context).padding.top,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'THE FESTIVAL YEAR',
                style: label(size: 12),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
            sliver: SliverList.separated(
              itemCount: festivals.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final festival = festivals[i];
                // Each card enters a beat after the one above it.
                final slot = CurvedAnimation(
                  parent: _entrance,
                  curve: Interval(
                    (i * 0.10).clamp(0.0, 0.6),
                    (0.4 + i * 0.10).clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic,
                  ),
                );
                return FadeTransition(
                  opacity: slot,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.18),
                      end: Offset.zero,
                    ).animate(slot),
                    child: _FestivalCard(
                      festival: festival,
                      days: festival.daysUntil(now),
                      onTap: () => _openFestival(festival),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 36),
              child: Text(
                'Dates follow the moon and the valley\'s own almanacs; '
                'the ones shown are close, not carved.',
                style: body(size: 13, color: Jatra.faded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The shrine at the top: a spinnable mandala that collapses into a
/// masthead as the almanac scrolls.
class _MandalaHeader extends SliverPersistentHeaderDelegate {
  _MandalaHeader({
    required this.spin,
    required this.idle,
    required this.topPadding,
  });

  final AnimationController spin;
  final AnimationController idle;
  final double topPadding;

  Offset _lastVector = Offset.zero;

  @override
  double get maxExtent => 330 + topPadding;

  @override
  double get minExtent => 86 + topPadding;

  void _onPanStart(DragStartDetails details, Offset center) {
    _lastVector = details.localPosition - center;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset center) {
    final vector = details.localPosition - center;
    if (vector.distance < 12 || _lastVector.distance < 12) return;
    final delta = math.atan2(vector.dy, vector.dx) -
        math.atan2(_lastVector.dy, _lastVector.dx);
    // Normalize the wrap so crossing pi does not whiplash.
    final wrapped = (delta + math.pi) % (2 * math.pi) - math.pi;
    spin.value += wrapped;
    _lastVector = vector;
  }

  void _onPanEnd(DragEndDetails details, Offset center) {
    final r = _lastVector;
    if (r.distance < 12) return;
    final v = details.velocity.pixelsPerSecond;
    // Angular velocity from the tangential component of the fling.
    final omega = (r.dx * v.dy - r.dy * v.dx) / r.distanceSquared;
    HapticFeedback.lightImpact();
    spin.animateWith(FrictionSimulation(0.18, spin.value, omega));
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress =
        (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final mandalaSize =
        (maxExtent - topPadding) * 0.72 * (1 - progress * 0.55);
    final fade = (1 - progress * 1.6).clamp(0.0, 1.0);

    return ColoredBox(
      color: Jatra.soot,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The mandala rises out of frame as the ledger takes over.
          Positioned(
            top: topPadding + 8 - shrinkOffset * 0.55,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: fade,
              child: Center(
                child: SizedBox(
                  width: mandalaSize,
                  height: mandalaSize,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final center = Offset(constraints.maxWidth / 2,
                        constraints.maxHeight / 2);
                    return GestureDetector(
                      onPanStart: (d) => _onPanStart(d, center),
                      onPanUpdate: (d) => _onPanUpdate(d, center),
                      onPanEnd: (d) => _onPanEnd(d, center),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([spin, idle]),
                        builder: (_, _) => CustomPaint(
                          size: Size.square(mandalaSize),
                          painter: MandalaPainter(
                            rotation:
                                spin.value + idle.value * 2 * math.pi,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          // The masthead, pinned at the foot of the header.
          Positioned(
            left: 18,
            right: 18,
            bottom: 14,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('JATRA', style: display(size: 30)),
                const SizedBox(width: 10),
                Text('जात्रा',
                    style: display(size: 20, color: Jatra.vermilion)),
                const Spacer(),
                Text('THE VALLEY\'S YEAR', style: label(size: 10)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(height: 2, color: Jatra.vermilion),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_MandalaHeader oldDelegate) =>
      oldDelegate.topPadding != topPadding;
}

class _FestivalCard extends StatelessWidget {
  const _FestivalCard({
    required this.festival,
    required this.days,
    required this.onTap,
  });

  final Festival festival;
  final int days;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Jatra.surface,
      child: InkWell(
        onTap: onTap,
        splashColor: Jatra.vermilion.withValues(alpha: 0.15),
        highlightColor: Jatra.vermilion.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Jatra.vermilion, width: 3),
            ),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'glyph-${festival.id}',
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: CustomPaint(painter: GlyphPainter(festival.id)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(festival.name,
                              style: display(size: 19),
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        Text(festival.newari,
                            style:
                                display(size: 13, color: Jatra.vermilion)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${festival.place} · ${festival.season}',
                      style: label(size: 10, color: Jatra.faded,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(devanagari(days),
                      style: display(size: 22, color: Jatra.marigold)),
                  Text('DAYS', style: label(size: 9, color: Jatra.faded)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
