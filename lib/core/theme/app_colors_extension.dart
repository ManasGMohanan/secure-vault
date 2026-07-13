import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color textOnBrand;
  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandAccent;
  final Color borderDefault;
  final Color borderSubtle;
  final Color divider;
  final Color success;
  final Color successBackground;
  final Color successForeground;
  final Color error;
  final Color errorBackground;
  final Color errorForeground;

  const AppColorsExtension({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.textOnBrand,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandAccent,
    required this.borderDefault,
    required this.borderSubtle,
    required this.divider,
    required this.success,
    required this.successBackground,
    required this.successForeground,
    required this.error,
    required this.errorBackground,
    required this.errorForeground,
  });

  @override
  AppColorsExtension copyWith({
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? textOnBrand,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandAccent,
    Color? borderDefault,
    Color? borderSubtle,
    Color? divider,
    Color? success,
    Color? successBackground,
    Color? successForeground,
    Color? error,
    Color? errorBackground,
    Color? errorForeground,
  }) {
    return AppColorsExtension(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandAccent: brandAccent ?? this.brandAccent,
      borderDefault: borderDefault ?? this.borderDefault,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      successBackground: successBackground ?? this.successBackground,
      successForeground: successForeground ?? this.successForeground,
      error: error ?? this.error,
      errorBackground: errorBackground ?? this.errorBackground,
      errorForeground: errorForeground ?? this.errorForeground,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBackground: Color.lerp(
        successBackground,
        other.successBackground,
        t,
      )!,
      successForeground: Color.lerp(
        successForeground,
        other.successForeground,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
      errorForeground: Color.lerp(errorForeground, other.errorForeground, t)!,
    );
  }
}
