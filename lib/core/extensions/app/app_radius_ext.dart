import 'package:flutter/material.dart';

extension AppRadiusResponsive on BorderRadius {
  static BorderRadius getInputRadius(double screenWidth) {
    if (screenWidth >= 1200) {
      return BorderRadius.circular(16.0); // Desktop
    } else if (screenWidth >= 768) {
      return BorderRadius.circular(14.0); // Tablet
    } else if (screenWidth >= 480) {
      return BorderRadius.circular(12.0); // Large Phone
    } else {
      return BorderRadius.circular(10.0); // Small Phone
    }
  }
}
