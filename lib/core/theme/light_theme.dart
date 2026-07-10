import 'package:flutter/material.dart';
import 'app_palette.dart';
import 'app_colors_extension.dart';

ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Helvetica',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.lightBlue1,
      brightness: Brightness.light,
      primary: AppPalette.lightBlue1,
      surface: AppPalette.lightNeutral,
      onPrimary: AppPalette.lightWhite,
      onSurface: AppPalette.lightBlue2,
      error: AppPalette.lightError1,
    ),
    scaffoldBackgroundColor: AppPalette.lightNeutral,
    cardTheme: CardThemeData(
      color: AppPalette.lightWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.lightGrey11, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightNeutral,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppPalette.lightBlue2),
      titleTextStyle: TextStyle(
        fontFamily: 'Helvetica Rounded LT Std',
        color: AppPalette.lightBlue2,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.lightWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.lightGrey11),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.lightGrey11),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.lightBlue1, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.lightBlue1,
        foregroundColor: AppPalette.lightWhite,
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
        foregroundColor: AppPalette.lightBlue1,
        side: const BorderSide(color: AppPalette.lightBlue1, width: 1.5),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    extensions: [
      const AppColorsExtension(
        backgroundPrimary: AppPalette.lightNeutral,
        backgroundSecondary: AppPalette.lightWhite5,
        surfacePrimary: AppPalette.lightWhite,
        surfaceSecondary: AppPalette.lightWhite3,
        surfaceElevated: AppPalette.lightWhite,
        surfaceMuted: AppPalette.lightWhite4,
        textPrimary: AppPalette.lightBlue2,
        textSecondary: AppPalette.lightBlue5,
        textMuted: AppPalette.lightGrey3,
        textDisabled: AppPalette.lightGrey4,
        textOnBrand: AppPalette.lightWhite,
        brandPrimary: AppPalette.lightBlue1,
        brandSecondary: AppPalette.lightBlue4,
        brandAccent: AppPalette.lightBlue6,
        borderDefault: AppPalette.lightGrey11,
        borderSubtle: AppPalette.lightGrey10,
        divider: AppPalette.lightGrey7,
        success: AppPalette.lightSuccess1,
        successBackground: AppPalette.lightSuccess2,
        successForeground: AppPalette.lightSuccess1,
        error: AppPalette.lightError1,
        errorBackground: AppPalette.lightError2,
        errorForeground: AppPalette.lightError1,
      ),
    ],
  );
}
