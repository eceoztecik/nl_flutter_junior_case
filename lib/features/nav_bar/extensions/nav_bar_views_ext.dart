// Maybe you can manage icon for bottom navigation bar items
import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/nav_bar/enums/nav_bar_views.dart';

extension NavBarViewsExtension on NavBarViews {
  String get title {
    switch (this) {
      case NavBarViews.home:
        return 'Anasayfa';
      case NavBarViews.profile:
        return 'Profil';
    }
  }

  IconData get icon {
    switch (this) {
      case NavBarViews.home:
        return Icons.home;
      case NavBarViews.profile:
        return Icons.person_outline;
    }
  }

  String get route {
    switch (this) {
      case NavBarViews.home:
        return '/home';
      case NavBarViews.profile:
        return '/profile';
    }
  }

  bool get isPrimary {
    switch (this) {
      case NavBarViews.home:
        return true;
      case NavBarViews.profile:
        return false;
    }
  }
}
