import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color softPink = Color(0xFFEC4899);
  static const Color softCoral = Color(0xFFF97316);
  static const Color softBlue = Color(0xFF60A5FA);
  static const Color softGreen = Color(0xFF22C55E);
  static const Color softOrange = Color(0xFFEAB308);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color lightText = Color(0xFF94A3B8);
  static const Color cardBg = Color(0xFF1E293B);

  static const Color glassWhite = Color(0xCC1E293B);
  static const Color glassWhiteLight = Color(0x991E293B);
  static const Color glassBorder = Color(0x4D64748B);
  static const Color glassShadow = Color(0x4D000000);

  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    double blur = 20,
    Color? borderColor,
    Color? bgColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor ?? glassBorder, width: 1),
      color: bgColor ?? glassWhite,
      boxShadow: [
        BoxShadow(color: glassShadow, blurRadius: blur, offset: const Offset(0, 4)),
      ],
    );
  }

  static BoxDecoration glassGradientDecoration({
    double borderRadius = 20,
    double blur = 20,
    Color? borderColor,
    List<Color>? gradientColors,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor ?? glassBorder, width: 1),
      gradient: LinearGradient(
        colors: gradientColors ?? [glassWhite, glassWhiteLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(color: glassShadow, blurRadius: blur, offset: const Offset(0, 4)),
      ],
    );
  }

  static LinearGradient get backgroundGradient => const LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get blueGradient => LinearGradient(
    colors: [primaryBlue, const Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get purpleGradient => LinearGradient(
    colors: [primaryPurple, const Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get indigoGradient => LinearGradient(
    colors: [primaryIndigo, const Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get sunsetGradient => LinearGradient(
    colors: [softCoral, softPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get premiumGradient => LinearGradient(
    colors: [primaryBlue, primaryIndigo, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration blurredBackground() {
    return BoxDecoration(gradient: backgroundGradient);
  }

  static TextStyle get titleStyle => TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, color: darkText, letterSpacing: -0.5,
  );

  static TextStyle get subtitleStyle => TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, color: lightText,
  );

  static TextStyle get glassTextStyle => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: darkText.withValues(alpha: 0.75),
  );

  static EdgeInsets get screenPadding => const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
}
