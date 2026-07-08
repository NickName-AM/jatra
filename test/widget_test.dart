import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jatra/data/festivals.dart';
import 'package:jatra/main.dart';
import 'package:jatra/screens/detail.dart';

void main() {
  group('the almanac', () {
    // The mandala and the scenes loop forever, so these tests pump
    // fixed durations; pumpAndSettle would wait for a festival that
    // never ends.
    testWidgets('lists all six jatras', (tester) async {
      await tester.pumpWidget(const JatraApp());
      await tester.pump(const Duration(milliseconds: 1200));

      expect(find.text('JATRA'), findsOneWidget);
      // The list is lazy, so scroll each card into the viewport.
      for (final festival in festivals) {
        await tester.scrollUntilVisible(
          find.text(festival.name),
          160,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(festival.name), findsOneWidget,
            reason: '${festival.name} should be on the shelf');
      }
    });

    testWidgets('opens a festival and walks back', (tester) async {
      await tester.pumpWidget(const JatraApp());
      await tester.pump(const Duration(milliseconds: 1200));

      await tester.tap(find.text('Indra Jatra'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 1400));

      expect(find.byType(DetailScreen), findsOneWidget);
      expect(
        find.textContaining('borrows a god of rain'),
        findsOneWidget,
      );

      await tester.tap(find.text('THE ALMANAC'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(DetailScreen), findsNothing);
    });
  });

  group('the calendar arithmetic', () {
    test('counts the days to a festival', () {
      final f = festivals.firstWhere((f) => f.id == 'indra');
      expect(f.daysUntil(DateTime(2026, 9, 20)), 5);
      expect(f.daysUntil(DateTime(2026, 9, 25)), 0);
    });

    test('a festival already passed floors at zero', () {
      final f = festivals.firstWhere((f) => f.id == 'indra');
      expect(f.daysUntil(DateTime(2026, 10, 1)), 0);
    });

    test('ignores the hour of day', () {
      final f = festivals.firstWhere((f) => f.id == 'yomari');
      expect(
        f.daysUntil(DateTime(2026, 12, 22, 23, 59)),
        1,
      );
    });
  });
}
