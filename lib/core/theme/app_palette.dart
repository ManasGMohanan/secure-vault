import 'package:flutter/material.dart';

abstract final class AppPalette {
  // --- LIGHT MODE PALETTE ---
  // Whites & Off-whites
  static const Color lightWhite = Color(0xFFFFFFFF);
  static const Color lightNeutral = Color(0xFFF5F5F5); // scaffold background
  static const Color lightWhite3 = Color(0xFFEEEEEE); // surfaceSecondary
  static const Color lightWhite4 = Color(0xFFE0E0E0); // surfaceMuted / borders
  static const Color lightWhite5 = Color(0xFFEEEEEE); // backgroundSecondary
  static const Color lightWhite6 = Color(0xFFBDBDBD); // divider

  // True Neutral Blacks & Greys (no blue tint)
  static const Color lightBlack1 = Color(0xFF111111); // textPrimary
  static const Color lightBlack2 = Color(0xFF212121); // textSecondary
  static const Color lightGrey1 = Color(0xFF424242); // textMuted
  static const Color lightGrey2 = Color(0xFF616161); // textMuted alt
  static const Color lightGrey3 = Color(0xFF757575); // textMuted
  static const Color lightGrey4 = Color(0xFF9E9E9E); // textDisabled
  static const Color lightGrey5 = Color(0xFFBDBDBD); // borderSubtle
  static const Color lightGrey6 = Color(0xFFE0E0E0); // borderDefault
  static const Color lightGrey7 = Color(0xFFEEEEEE); // divider
  static const Color lightGrey8 = Color(0xFFF5F5F5); // surface muted
  static const Color lightGrey9 = Color(0xFFE8E8E8);
  static const Color lightGrey10 = Color(0xFFE0E0E0);
  static const Color lightGrey11 = Color(0xFFD6D6D6);

  // Legacy Brand Blues (kept for reference, not used in semantic system)
  static const Color lightBlue1 = Color(0xFF111111); // remapped: primary action → near-black
  static const Color lightBlue2 = Color(0xFF111111); // remapped: textPrimary → near-black
  static const Color lightBlue3 = Color(0xFF212121);
  static const Color lightBlue4 = Color(0xFF212121);
  static const Color lightBlue5 = Color(0xFF424242);
  static const Color lightBlue6 = Color(0xFF9E9E9E);

  // Success Semantics
  static const Color lightSuccess1 = Color(0xFF136317);
  static const Color lightSuccess2 = Color(0xFF9EEAA7);
  static const Color lightSuccess3 = Color(0xFFAAE4B1);

  // Error Semantics
  static const Color lightError1 = Color(0xFFD32F2F);
  static const Color lightError2 = Color(0xFFFFEBEE);
  static const Color lightError3 = Color(0xFFE53935);


  // --- DARK MODE PALETTE ---
  // Whites
  static const Color darkWhite = Color(0xFFFFFFFF);
  static const Color darkNeutral = Color(0xFFCFD3E1); // textSecondary
  static const Color darkF5 = Color(0xFFF5F5F5); // textPrimary

  // Brand Blues
  static const Color darkBlue1 = Color(0xFF062A65); // brandDark
  static const Color darkBlue2 = Color(0xFF303030); // surfaceSecondary
  static const Color darkBlue3 = Color(0xFF5C99FF); // brandPrimary
  static const Color darkBlue4 = Color(0xFF191E3C);
  static const Color darkBlue5 = Color(0xFF0F3D87); // brandAccent
  static const Color darkBlue6 = Color(0xFF82B0FF); // brandSecondary
  static const Color darkBlue7 = Color(0xFF0F254B);

  // Neutral Blacks & Greys
  static const Color darkBlack1 = Color(0xFF1F1F1F); // surfacePrimary
  static const Color darkBlack2 = Color(0xFF1F1F1F); // backgroundSecondary
  static const Color darkBlack3 = Color(0xFF0D0D0D); // backgroundPrimary
  static const Color darkGrey1 = Color(0xFF4A4A4A); // borderDefault / surfaceMuted
  static const Color darkGrey2 = Color(0xFF3B3B3E); // surfaceElevated
  static const Color darkGrey3 = Color(0xFF6E6E6E); // textDisabled
  static const Color darkGrey4 = Color(0xFFA1A1A1); // textMuted
  static const Color darkGrey5 = Color(0xFF545875); // borderSubtle / divider
  static const Color darkFAB = Color(0xFF2C2C2C); // FAB: charcoal elevated action

  // Success Semantics
  static const Color darkSuccess1 = Color(0xFF003B07); // successBackground
  static const Color darkSuccess2 = Color(0xFF8DF099); // success
  static const Color darkSuccess3 = Color(0xFF9EEAA7); // successForeground

  // Error Semantics
  static const Color darkError1 = Color(0xFFEF5350); // error
  static const Color darkError2 = Color(0xFF4A1919); // errorBackground
  static const Color darkError3 = Color(0xFFE57373); // errorForeground
}
