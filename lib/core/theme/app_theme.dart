import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

abstract final class AppTheme {
  static ThemeData get light => getLightTheme();
  static ThemeData get dark => getDarkTheme();
}
