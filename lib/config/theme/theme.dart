import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.5),
    borderRadius: BorderRadius.circular(12),
  );

  static TextTheme _textTheme(Color textColor) =>
      GoogleFonts.interTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      );

  static BoxDecoration lightCardDecoration = BoxDecoration(
    color: Pallete.surfaceLight,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Pallete.borderLight, width: 1),
    boxShadow: const [
      BoxShadow(
        color: Pallete.shadowLight,
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration darkCardDecoration = BoxDecoration(
    color: Pallete.surfaceDark,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Pallete.borderDark, width: 1),
    boxShadow: const [
      BoxShadow(
        color: Pallete.shadowDark,
        blurRadius: 20,
        offset: Offset(0, 4),
      ),
    ],
  );

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundDark,
    textTheme: _textTheme(Pallete.textPrimaryDark),

    colorScheme: const ColorScheme.dark(
      primary: Pallete.primaryColor,
      secondary: Pallete.primaryLightColor,
      surface: Pallete.surfaceDark,
      error: Pallete.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Pallete.textPrimaryDark,
      onError: Colors.white,
      outline: Pallete.borderDark,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Pallete.backgroundDark,
      foregroundColor: Pallete.textPrimaryDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Pallete.textPrimaryDark,
      ),
    ),

    cardTheme: CardThemeData(
      color: Pallete.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.borderDark, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Pallete.surfaceDark,
      border: _border(Pallete.borderDark),
      enabledBorder: _border(Pallete.borderDark),
      focusedBorder: _border(Pallete.primaryColor),
      errorBorder: _border(Pallete.errorColor),
      focusedErrorBorder: _border(Pallete.errorColor),
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        color: Pallete.textSecondaryDark,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.primaryColor,
      foregroundColor: Colors.white,
    ),

    dividerColor: Pallete.borderDark,
  );

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundLight,
    textTheme: _textTheme(Pallete.textPrimaryLight),

    colorScheme: const ColorScheme.light(
      primary: Pallete.primaryColor,
      secondary: Pallete.primaryLightColor,
      surface: Pallete.surfaceLight,
      error: Pallete.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Pallete.textPrimaryLight,
      onError: Colors.white,
      outline: Pallete.borderLight,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Pallete.backgroundLight,
      foregroundColor: Pallete.textPrimaryLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Pallete.textPrimaryLight,
      ),
    ),

    cardTheme: CardThemeData(
      color: Pallete.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.borderLight, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Pallete.surfaceLight,
      border: _border(Pallete.borderLight),
      enabledBorder: _border(Pallete.borderLight),
      focusedBorder: _border(Pallete.primaryColor),
      errorBorder: _border(Pallete.errorColor),
      focusedErrorBorder: _border(Pallete.errorColor),
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        color: Pallete.textSecondaryLight,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.primaryColor,
      foregroundColor: Colors.white,
    ),

    dividerColor: Pallete.borderLight,
  );
}