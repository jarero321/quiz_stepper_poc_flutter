// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  // ─── Colors ───
  static const Color COLOR_OCEAN = Color(0xFF0097A7);
  static const Color COLOR_OCEAN_DEEP = Color(0xFF006978);
  static const Color COLOR_SUNSET = Color(0xFFFF7043);
  static const Color COLOR_GOLD = Color(0xFFFFD54F);
  static const Color COLOR_SAND = Color(0xFFFAF7F2);
  static const Color COLOR_SLATE = Color(0xFF2C3E50);
  static const Color COLOR_SLATE_LIGHT = Color(0xFF5A6B7C);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const Color COLOR_CLOUD = Color(0xFFE8ECEF);

  // ─── Typography ───
  static TextStyle heading({Color? color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? COLOR_SLATE,
        height: 1.2,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? COLOR_SLATE,
      );

  static TextStyle paragraph({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? COLOR_SLATE_LIGHT,
        height: 1.4,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color ?? COLOR_SLATE_LIGHT,
      );

  // ─── Durations ───
  static const Duration DURATION_FAST = Duration(milliseconds: 200);
  static const Duration DURATION_NORMAL = Duration(milliseconds: 350);
  static const Duration DURATION_SLOW = Duration(milliseconds: 600);
}
