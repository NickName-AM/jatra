import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The palette of a jatra at dusk: soot of torch smoke, sindoor
/// vermilion, marigold garlands, and the cream of rice-flour
/// offerings. Flat color only; light is drawn, never faded.
abstract final class Jatra {
  static const soot = Color(0xFF171009);
  static const surface = Color(0xFF261811);
  static const vermilion = Color(0xFFC7401F);
  static const marigold = Color(0xFFD9A441);
  static const cream = Color(0xFFF2E3C2);
  static const faded = Color(0xFF97806A);
}

/// Display type. Yatra One carries both the Latin and the Devanagari,
/// so जात्रा and JATRA are cut from the same wood.
TextStyle display({
  double size = 22,
  Color color = Jatra.cream,
  double height = 1.1,
}) =>
    GoogleFonts.yatraOne(fontSize: size, color: color, height: height);

/// Body type for the stories.
TextStyle body({
  double size = 15,
  Color color = Jatra.cream,
  double height = 1.55,
}) =>
    GoogleFonts.alegreya(
      fontSize: size,
      color: color,
      height: height,
      fontWeight: FontWeight.w400,
    );

/// Small caps for labels, dates, and places.
TextStyle label({
  double size = 11,
  Color color = Jatra.marigold,
  double letterSpacing = 2.0,
}) =>
    GoogleFonts.alegreyaSansSc(
      fontSize: size,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: FontWeight.w500,
    );

/// Devanagari numerals for the countdowns.
String devanagari(int n) {
  const digits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  return n.toString().split('').map((c) {
    final d = int.tryParse(c);
    return d == null ? c : digits[d];
  }).join();
}
