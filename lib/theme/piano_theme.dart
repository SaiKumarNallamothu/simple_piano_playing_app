import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Luxury Grand Piano Design System constants & theme definitions
class PianoTheme {
  PianoTheme._();

  // Background & Surface Colors (Deep Charcoal / Obsidian / Midnight)
  static const Color background = Color(0xFF090A0F);
  static const Color surfaceDark = Color(0xFF11141C);
  static const Color surfaceElevated = Color(0xFF181C26);
  static const Color surfaceGlass = Color(0x331E2333);
  static const Color surfaceGlassBorder = Color(0x2AFFFFFF);

  // Piano Body Lacquer / Rim Frame Colors
  static const Color pianoBodyDark = Color(0xFF08090D);
  static const Color pianoBodyEdge = Color(0xFF1A1C24);
  static const Color pianoFeltRed = Color(0xFF8B1E2B); // Classic red velvet / felt strip above keys

  // Refined Accents (Champagne Gold)
  static const Color goldAccent = Color(0xFFE5C07B);
  static const Color goldLight = Color(0xFFF3DE9F);
  static const Color goldDeep = Color(0xFFB5893C);
  static const Color goldGlow = Color(0x66E5C07B);
  static const Color goldSubtle = Color(0x1FE5C07B);

  // Key Colors
  // White keys: Ivory gradient
  static const Color ivoryTop = Color(0xFFFCFDFE);
  static const Color ivoryMid = Color(0xFFF7F5F0);
  static const Color ivoryBottom = Color(0xFFEDE9DF);
  static const Color ivoryShadow = Color(0xFFD6CEBD);
  static const Color ivoryPressedTop = Color(0xFFE5DEC9);
  static const Color ivoryPressedBottom = Color(0xFFD8CFB5);

  // Black keys: Glossy ebony gradient
  static const Color ebonyHighlight = Color(0xFF323642);
  static const Color ebonyTop = Color(0xFF1C1E24);
  static const Color ebonyMid = Color(0xFF121418);
  static const Color ebonyBottom = Color(0xFF060709);
  static const Color ebonyPressed = Color(0xFF252936);

  // Typography
  static TextStyle get titleSerif => GoogleFonts.playfairDisplay(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Colors.white,
      );

  static TextStyle get brandTitle => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: goldLight,
      );

  static TextStyle get bodySans => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF94A3B8),
      );

  static TextStyle get labelSans => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get keyNoteLabel => GoogleFonts.cormorantGaramond(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      );

  // Radii
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 18.0;
  static const double radiusKeyBottom = 7.0;

  // Background Gradient
  static const RadialGradient backgroundGlow = RadialGradient(
    center: Alignment(0.0, -0.2),
    radius: 1.1,
    colors: [
      Color(0x24E5C07B), // Warm subtle champagne ambient
      Color(0x18181F33),
      Color(0xFF090A0F),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  // Piano Rim Gradient
  static const LinearGradient pianoRimGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF222530),
      Color(0xFF12141A),
      Color(0xFF0A0B0E),
    ],
  );

  // Overall ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: goldAccent,
        secondary: goldLight,
        surface: surfaceDark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
