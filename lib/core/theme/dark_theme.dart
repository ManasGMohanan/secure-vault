import 'package:flutter/material.dart';
import 'app_palette.dart';
import 'app_colors_extension.dart';

ThemeData getDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Helvetica',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.darkBlack3,
      brightness: Brightness.dark,
      primary: AppPalette.darkF5,
      surface: AppPalette.darkBlack3,
      onPrimary: AppPalette.darkBlack3,
      onSurface: AppPalette.darkF5,
      error: AppPalette.darkError1,
    ),
    scaffoldBackgroundColor: AppPalette.darkBlack3,
    cardTheme: CardThemeData(
      color: AppPalette.darkBlue2, // surfaceSecondary (#303030) as per hierarchy
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.darkGrey1, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBlack3,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppPalette.darkWhite),
      titleTextStyle: TextStyle(
        fontFamily: 'Helvetica Rounded LT Std',
        color: AppPalette.darkWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
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
        borderSide: const BorderSide(color: AppPalette.darkGrey4, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.darkGrey2, // charcoal elevated surface
        foregroundColor: AppPalette.darkF5,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        textPrimary: AppPalette.darkF5,
        textSecondary: AppPalette.darkNeutral,
        textMuted: AppPalette.darkGrey4,
        textDisabled: AppPalette.darkGrey3,
        textOnBrand: AppPalette.darkBlack3,
        brandPrimary: AppPalette.darkF5,       // off-white — primary interactive highlight
        brandSecondary: AppPalette.darkGrey4,  // muted grey — secondary signals
        brandAccent: AppPalette.darkGrey2,     // charcoal — subtle surface tints
        borderDefault: AppPalette.darkGrey1,
        borderSubtle: AppPalette.darkGrey5,
        divider: AppPalette.darkGrey5,
        success: AppPalette.darkSuccess2,
        successBackground: AppPalette.darkSuccess1,
        successForeground: AppPalette.darkSuccess3,
        error: AppPalette.darkError1,
        errorBackground: AppPalette.darkError2,
        errorForeground: AppPalette.darkError3,
      ),
    ],
  );
}
