import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import '../enums/nav_bar_views.dart';
import '../extensions/nav_bar_views_ext.dart';

class CustomNavBarItem extends StatelessWidget {
  final NavBarViews navBarView;
  final VoidCallback onTap;
  final bool isSelected;

  const CustomNavBarItem({
    super.key,
    required this.navBarView,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: screenWidth >= 768 ? 56 : 48,
          decoration: BoxDecoration(
            color: navBarView.isPrimary ? Colors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(
              screenWidth >= 1200
                  ? 16.0
                  : screenWidth >= 768
                  ? 14.0
                  : screenWidth >= 480
                  ? 12.0
                  : 10.0,
            ),
            border: navBarView.isPrimary
                ? null
                : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                navBarView.icon,
                color: Colors.white,
                size: screenWidth >= 768 ? 24 : 20,
              ),
              SizedBox(width: AppPaddings.s),
              Text(
                navBarView.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth >= 1200
                      ? 18
                      : screenWidth >= 768
                      ? 16
                      : 14,
                  fontWeight: navBarView.isPrimary
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
