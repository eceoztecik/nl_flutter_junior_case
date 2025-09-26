import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';
import 'package:jr_case_boilerplate/features/nav_bar/enums/nav_bar_views.dart';
import 'package:jr_case_boilerplate/features/nav_bar/extensions/nav_bar_views_ext.dart';
import 'package:jr_case_boilerplate/features/nav_bar/view/nav_bar_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLiked = true;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/Image.png', fit: BoxFit.cover),
          ),

          // Dark overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Main content - Bottom positioned
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heart button
                  Padding(
                    padding: EdgeInsets.only(
                      right: AppPaddingsResponsive.getScreenPadding(
                        screenWidth,
                      ).right,
                      bottom: AppPaddings.m,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _toggleLike,
                        child: Container(
                          width: 52,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Profile info section
                  Padding(
                    padding: AppPaddingsResponsive.getScreenPadding(
                      screenWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo and title
                        Row(
                          children: [
                            Container(
                              width: screenWidth >= 768 ? 32 : 28,
                              height: screenWidth >= 768 ? 32 : 28,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth >= 768 ? 20 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppPaddings.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Son Ana Kadar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth >= 1200
                                          ? 32
                                          : screenWidth >= 768
                                          ? 28
                                          : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: AppPaddings.xs),
                                  Text(
                                    'Birbirine derinden bağlı iki çocukluk arkadaşı olan Sydney ve Karl',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: screenWidth >= 1200
                                          ? 18
                                          : screenWidth >= 768
                                          ? 16
                                          : 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: AppPaddings.xs),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'DevamınıOku',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth >= 1200
                                                ? 18
                                                : screenWidth >= 768
                                                ? 16
                                                : 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: AppPaddingsResponsive.getSectionSpacing(
                            screenWidth,
                          ),
                        ),

                        // Bottom safe area + NavBar space
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarView(
              selectedView: NavBarViews.home,
              onItemTapped: (NavBarViews view) {
                if (view == NavBarViews.profile) {
                  Navigator.pushNamed(context, view.route);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
