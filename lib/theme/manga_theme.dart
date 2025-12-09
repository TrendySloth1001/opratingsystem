import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MangaTheme {
  // Manga-inspired color palette
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color inkBlack = Color(0xFF0D0D0D);
  static const Color paperWhite = Color(0xFFFFFEF8);
  static const Color mangaRed = Color(0xFFE63946);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color speedlineBlue = Color(0xFF457B9D);
  static const Color panelGray = Color(0xFFE5E5E5);
  static const Color shadowGray = Color(0xFF6C757D);
  static const Color highlightYellow = Color(0xFFFFC857);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paperWhite,
      primaryColor: primaryBlack,
      colorScheme: const ColorScheme.light(
        primary: primaryBlack,
        secondary: mangaRed,
        tertiary: speedlineBlue,
        surface: paperWhite,
        onPrimary: paperWhite,
        onSecondary: paperWhite,
        onSurface: primaryBlack,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bangers(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.bangers(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.bangers(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
        ),
        headlineLarge: GoogleFonts.comicNeue(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
        ),
        headlineMedium: GoogleFonts.comicNeue(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
        ),
        headlineSmall: GoogleFonts.comicNeue(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primaryBlack,
        ),
        bodyLarge: GoogleFonts.comicNeue(
          fontSize: 16,
          color: primaryBlack,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.comicNeue(
          fontSize: 14,
          color: primaryBlack,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.comicNeue(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: paperWhite,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: inkBlack,
        foregroundColor: paperWhite,
        elevation: 0,
        titleTextStyle: GoogleFonts.bangers(
          fontSize: 28,
          color: paperWhite,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: primaryBlack, width: 3),
        ),
        color: paperWhite,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: paperWhite,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: primaryBlack, width: 3),
          ),
          textStyle: GoogleFonts.comicNeue(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // Custom decorations with sketched manga style
  static BoxDecoration mangaPanelDecoration({
    Color? backgroundColor,
    bool hasAction = false,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? paperWhite,
      border: Border.all(
        color: hasAction ? mangaRed : primaryBlack,
        width: 4,
      ),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        // Hard bold shadow
        BoxShadow(
          color: primaryBlack,
          offset: const Offset(6, 6),
          blurRadius: 0,
        ),
        // Accent shadow for depth
        BoxShadow(
          color: hasAction ? mangaRed.withOpacity(0.3) : primaryBlack.withOpacity(0.1),
          offset: const Offset(3, 3),
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration completedPanelDecoration() {
    return BoxDecoration(
      color: highlightYellow.withOpacity(0.25),
      border: Border.all(
        color: highlightYellow,
        width: 5,
      ),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        // Glowing effect
        BoxShadow(
          color: highlightYellow.withOpacity(0.6),
          offset: const Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 2,
        ),
        // Hard shadow
        BoxShadow(
          color: highlightYellow,
          offset: const Offset(6, 6),
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration actionPanelDecoration() {
    return BoxDecoration(
      color: mangaRed,
      border: Border.all(
        color: inkBlack,
        width: 4,
      ),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        // Bold black shadow
        BoxShadow(
          color: inkBlack,
          offset: const Offset(6, 6),
          blurRadius: 0,
        ),
        // Red glow
        BoxShadow(
          color: mangaRed.withOpacity(0.4),
          offset: const Offset(0, 0),
          blurRadius: 8,
        ),
      ],
    );
  }
}
