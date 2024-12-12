import 'package:flutter/material.dart';

class AppColorScheme {
  static const Color primaryColor = Color(0xFF074EA0);
  static const Color accentColor = Color(0xFF4CC9F0);

  static const Color onPrimaryColor = Colors.white;

  static const ColorScheme appColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: accentColor,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: onPrimaryColor,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}
