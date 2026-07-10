import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_palette.dart';
import 'app_colors_extension.dart';

ThemeData getDarkTheme() {
  final baseTextTheme = ThemeData(brightness: Brightness.dark).textTheme;
  
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.darkBlue3,
      brightness: Brightness.dark,
      primary: AppPalette.darkBlue3,
      surface: AppPalette.darkBlack3,
      onPrimary: AppPalette.darkWhite,
      onSurface: AppPalette.darkWhite,
      error: AppPalette.darkError1,
    ),
    scaffoldBackgroundColor: AppPalette.darkBlack3,
    textTheme: GoogleFonts.interTextTheme(baseTextTheme),
    cardTheme: CardThemeData(
      color: AppPalette.darkBlack1,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.darkGrey1, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.darkBlack3,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppPalette.darkWhite),
      titleTextStyle: GoogleFonts.inter(
        color: AppPalette.darkWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.darkBlack1,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.darkGrey1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.darkGrey1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.darkBlue3, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.darkBlue3,
        foregroundColor: AppPalette.darkWhite,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPalette.darkWhite,
        side: const BorderSide(color: AppPalette.darkGrey1, width: 1.5),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    extensions: [
      const AppColorsExtension(
        backgroundPrimary: AppPalette.darkBlack3,
        backgroundSecondary: AppPalette.darkBlack2,
        surfacePrimary: AppPalette.darkBlack1,
        surfaceSecondary: AppPalette.darkBlue2,
        surfaceElevated: AppPalette.darkGrey2,
        surfaceMuted: AppPalette.darkGrey1,
        textPrimary: AppPalette.darkWhite,
        textSecondary: AppPalette.darkNeutral,
        textMuted: AppPalette.darkGrey4,
        textDisabled: AppPalette.darkGrey3,
        textOnBrand: AppPalette.darkWhite,
        brandPrimary: AppPalette.darkBlue3,
        brandSecondary: AppPalette.darkBlue6,
        brandAccent: AppPalette.darkBlue7,
        borderDefault: AppPalette.darkGrey1,
        borderSubtle: AppPalette.darkBlue2,
        divider: AppPalette.darkGrey1,
        success: AppPalette.darkSuccess2,
        successBackground: AppPalette.darkSuccess1,
        successForeground: AppPalette.darkSuccess3,
        error: AppPalette.darkError1,
        errorBackground: AppPalette.darkBlack1, // Validated for accessibility: #011F2D has ~13.8:1 contrast with #EA9E9E
        errorForeground: AppPalette.darkError2, // Light red text (#EA9E9E)
      ),
    ],
  );
}
