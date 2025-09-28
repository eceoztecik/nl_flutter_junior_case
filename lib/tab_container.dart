import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:jr_case_boilerplate/features/nav_bar/enums/nav_bar_views.dart';
import 'package:jr_case_boilerplate/features/nav_bar/view/nav_bar_view.dart';
import 'package:jr_case_boilerplate/features/profile/view/profile_view.dart';

class TabContainer extends StatefulWidget {
  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: [HomePage(), ProfilePage()],
          ),

          // NavBar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarView(
              selectedView: NavBarViews.values[currentIndex],
              onItemTapped: (view) {
                setState(() {
                  currentIndex = view.index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
