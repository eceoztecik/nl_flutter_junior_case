import 'package:flutter/material.dart';

class AppPaddings {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 24.0;
  static const double xl = 32.0;

  // General paddings
  static const EdgeInsets screen = EdgeInsets.all(16.0);
  static const EdgeInsets card = EdgeInsets.all(12.0);
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 12.0,
  );
  static const EdgeInsets form = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Common spacings
  static const SizedBox spacingS = SizedBox(height: 8.0);
  static const SizedBox spacingM = SizedBox(height: 16.0);
  static const SizedBox spacingL = SizedBox(height: 24.0);
  static const SizedBox spacingXL = SizedBox(height: 32.0);
}
