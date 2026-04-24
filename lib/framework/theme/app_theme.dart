import 'package:flutter/material.dart';

class AppTheme {
  static const Color colorOcean = Color(0xFF0097A7);
  static const Color colorOceanDeep = Color(0xFF006978);
  static const Color colorSunset = Color(0xFFFF7043);
  static const Color colorGold = Color(0xFFFFD54F);
  static const Color colorSand = Color(0xFFFAF7F2);
  static const Color colorSlate = Color(0xFF2C3E50);
  static const Color colorSlateLight = Color(0xFF5A6B7C);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorCloud = Color(0xFFE8ECEF);

  static const String fontDisplay = 'Fraunces';
  static const String fontBody = 'Inter';

  static TextStyle heading({Color? color}) => TextStyle(
    fontFamily: fontDisplay,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: color ?? colorSlate,
    height: 1.15,
  );

  static TextStyle title({Color? color}) => TextStyle(
    fontFamily: fontBody,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: color ?? colorSlate,
  );

  static TextStyle paragraph({Color? color, FontWeight? weight}) => TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: weight ?? FontWeight.w400,
    color: color ?? colorSlateLight,
    height: 1.45,
  );

  static TextStyle caption({Color? color}) => TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: color ?? colorSlateLight,
  );

  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 600);
}
