// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  // ─── Colors ───
  static const Color colorOcean = Color(0xFF0097A7);
  static const Color colorOceanDeep = Color(0xFF006978);
  static const Color colorSunset = Color(0xFFFF7043);
  static const Color colorGold = Color(0xFFFFD54F);
  static const Color colorSand = Color(0xFFFAF7F2);
  static const Color colorSlate = Color(0xFF2C3E50);
  static const Color colorSlateLight = Color(0xFF5A6B7C);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorCloud = Color(0xFFE8ECEF);

  // ─── Typography ───
  static TextStyle heading({Color? color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? colorSlate,
        height: 1.2,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? colorSlate,
      );

  static TextStyle paragraph({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? colorSlateLight,
        height: 1.4,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color ?? colorSlateLight,
      );

  // ─── Durations ───
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 600);
}
