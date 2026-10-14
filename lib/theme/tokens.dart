import 'package:flutter/material.dart';

/// Colors taken from the Figma file (brand / text / status / surface tokens).
class VColors {
  static const primary = Color(0xFF084BA4);
  static const primaryHover = Color(0xFF063A82);
  static const primaryContainer = Color(0xFFDCE9F8);
  static const textPrimary = Color(0xFF0E1A2B);
  static const textSecondary = Color(0xFF3C4A5E);
  static const success = Color(0xFF1A7F4E);
  static const surfaceMuted = Color(0xFFF3F7FB);
  static const sheet = Color(0xFFF7FAFF);
  static const screenBg = Color(0xFFF8FAFD);
  static const border = Color(0xFFD3DFEC);
  static const blue100 = Color(0xFFCCD9FC);
  static const slate500 = Color(0xFF6B7280);
  static const orange = Color(0xFFFC8742);
  static const peach = Color(0xFFF5A475);
  static const steel = Color(0xFF3476AE);
}

/// Shadows used on cards and floating controls.
class VShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x1F084AA3), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x29084AA3), blurRadius: 20, offset: Offset(0, 6)),
  ];
}

/// Small helper so text styles stay short at the call site.
TextStyle vText(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
