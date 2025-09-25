import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFE50914); // Red
  static const Color primaryDark = Color(0xFF6F060B); // Dark Red
  static const Color secondary = Color(0xFF5949E6); // Purple/Blue
  // White Tones (Grays with Opacity)
  static const Color white = Color(0xFFFFFFFF); // 100%
  static Color gray90 = Colors.white.withOpacity(0.9);
  static Color gray80 = Colors.white.withOpacity(0.8);
  static Color gray70 = Colors.white.withOpacity(0.7);
  static Color gray60 = Colors.white.withOpacity(0.6);
  static Color gray50 = Colors.white.withOpacity(0.5);
  static Color gray40 = Colors.white.withOpacity(0.4);
  static Color gray30 = Colors.white.withOpacity(0.3);
  static Color gray20 = Colors.white.withOpacity(0.2);
  static Color gray10 = Colors.white.withOpacity(0.1);
  static Color gray5 = Colors.white.withOpacity(0.05);
  // Alert & Status Colors
  static const Color success = Color(0xFF00C247); // Green
  static const Color info = Color(0xFF004CE8); // Blue
  static const Color warning = Color(0xFFFFBE16); // Yellow
  static const Color error = Color(0xFFF47171); // Red/Pink

  // Others
  static const Color black = Color(0xFF000000);
  // Border Color
  static const Color gradientBorder = Color(0xFFEEEEEE);
  // Gradients

  static const LinearGradient popularCardGradient = LinearGradient(
    colors: [Color(0xFF5949E6), Color(0xFFE50914)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient normalCardGradient = LinearGradient(
    colors: [Color(0xFF6F060B), Color(0xFFE50914)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activeNavGradient = LinearGradient(
    colors: [Color(0xFF6F060B), Color(0xFFE50914)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Linear + Radial glow
  static const LinearGradient _linear = LinearGradient(
    colors: [
      Color(0xFF2D0808), // Üst - koyu kırmızımsı
      Color(0xFF1A0404), // Logo seviyesi - çok koyu kırmızı
      Color(0xFF000000), // Siyah
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.35, 0.6],
  );

  static const RadialGradient _radial = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.1,
    colors: [
      Color(0xB0FF1B1B), // Daha belirgin kırmızı ışık
      Color(0x208D0000), // Orta ton koyu kırmızı
      Colors.transparent, // Şeffaf
    ],
    stops: [0.0, 0.35, 0.7],
  );

  static Widget combinedBg({Widget? child}) {
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(gradient: _linear)),
        Container(decoration: const BoxDecoration(gradient: _radial)),
        if (child != null) child!,
      ],
    );
  }
}
