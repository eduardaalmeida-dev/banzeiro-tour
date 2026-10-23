import 'package:flutter/material.dart';

abstract final class AppVisualIdentity {
  static const primaryGreen = Color(0xFF0B7A43);
  static const darkGreen = Color(0xFF103B27);
  static const softGreen = Color(0xFFE8F4EC);
  static const pageBackground = Color(0xFFF5F7F6);
  static const fieldBackground = Color(0xFFF1F4F2);
  static const mutedText = Color(0xFF6B8275);
  static const subtleBorder = Color(0xFFDFE7E2);
  static const boatmanBlue = Color(0xFF17647A);
  static const boatmanBlueDark = Color(0xFF0B4051);
  static const guideForest = Color(0xFF1D6137);
  static const guideForestDark = Color(0xFF103B27);
  static const artisanGold = Color(0xFFE9A923);
  static const artisanGoldDark = Color(0xFFBB7412);
  static const cookTerracotta = Color(0xFFC85A48);
  static const cookTerracottaDark = Color(0xFF963B35);
  static const capacityMedium = Color(0xFFE3A92B);
  static const capacityHigh = Color(0xFFC85A48);

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: pageBackground,
    );
  }
}
