import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import '../enums/nav_bar_views.dart';

class NavBarView extends StatelessWidget {
  final NavBarViews? selectedView;
  final Function(NavBarViews) onItemTapped;

  const NavBarView({super.key, this.selectedView, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, right: 16, bottom: 12, left: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.95),
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Active/Selected
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: selectedView == NavBarViews.home
                          ? AppColors
                                .activeNavGradient // Gradient - active
                          : null,
                      color: selectedView == NavBarViews.home
                          ? null
                          : Colors.transparent, // Transparent - inactive
                      borderRadius: BorderRadius.circular(42),
                      border: selectedView == NavBarViews.home
                          ? null
                          : Border.all(color: AppColors.gray20, width: 1),
                    ),
                    child: InkWell(
                      onTap: () => onItemTapped(NavBarViews.home),
                      borderRadius: BorderRadius.circular(42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, color: AppColors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Anasayfa',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10), // Gap between buttons
                // Profil button
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: selectedView == NavBarViews.profile
                          ? AppColors.activeNavGradient
                          : null,
                      color: selectedView == NavBarViews.profile
                          ? null
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(42),
                      border: selectedView == NavBarViews.profile
                          ? null
                          : Border.all(color: AppColors.gray20, width: 1),
                    ),
                    child: InkWell(
                      onTap: () => onItemTapped(NavBarViews.profile),
                      borderRadius: BorderRadius.circular(42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: AppColors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Profil',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
