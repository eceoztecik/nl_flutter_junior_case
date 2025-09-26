import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';

extension AppPaddingsResponsive on AppPaddings {
  static EdgeInsets getScreenPadding(double screenWidth) {
    if (screenWidth >= 1200) {
      return const EdgeInsets.all(32.0); // Desktop
    } else if (screenWidth >= 768) {
      return const EdgeInsets.all(24.0); // Tablet
    } else if (screenWidth >= 480) {
      return const EdgeInsets.all(16.0); // Large Phone
    } else {
      return const EdgeInsets.all(12.0); // Small Phone
    }
  }

  static EdgeInsets getFormPadding(double screenWidth) {
    if (screenWidth >= 1200) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0);
    } else if (screenWidth >= 768) {
      return const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0);
    } else if (screenWidth >= 480) {
      return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0);
    }
  }
}
