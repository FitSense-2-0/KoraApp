
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color background = Color(0xFFF7F4EB);
  static const Color primary = Color(0xFFD9F95F);
  static const Color secondary = Color(0xFF769477);
  static const Color dark = Color(0xFF112E24);

  // Surfaces
  static const Color white = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF1EFE6);
  static const Color border = Color(0xFFE9E6DC);

  // Text
  static const Color textPrimary = dark;
  static const Color textSecondary = secondary;
  static const Color textDisabled = Color(0xFFA7ADA2);

  // Feedback
  static const Color success = Color(0xFF3E7651);
  static const Color warning = Color(0xFFE5A93D);
  static const Color error = Color(0xFFB84040);
  static const Color info = Color(0xFF477A91);

  // Brand variations
  static const Color primarySoft = Color(0xFFF0F8D2);
  static const Color primaryDark = Color(0xFFB9D94C);
  static const Color secondarySoft = Color(0xFFE5ECE3);

  // Overlays
  static const Color darkOverlay = Color(0x99112E24);
  static const Color lightOverlay = Color(0x66FFFFFF);
  static const Color shadow = Color(0x14000000);
}