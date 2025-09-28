import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/bottom_sheet/offer_bottom_sheet.dart';
import 'package:jr_case_boilerplate/features/nav_bar/enums/nav_bar_views.dart';
import 'package:jr_case_boilerplate/features/nav_bar/extensions/nav_bar_views_ext.dart';
import 'package:jr_case_boilerplate/features/nav_bar/view/nav_bar_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  void _showLimitedOfferBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LimitedOfferPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AppColors.combinedBg(
        child: Stack(
          children: [
            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppPaddings.m),
                    // Header
                    _buildHeader(screenWidth),
                    SizedBox(
                      height: AppPaddingsResponsive.getSectionSpacing(
                        screenWidth,
                      ),
                    ),
                    // Profile Info Section
                    _buildProfileInfo(screenWidth),
                    SizedBox(
                      height: AppPaddingsResponsive.getSectionSpacing(
                        screenWidth,
                      ),
                    ),
                    // Favorites Section
                    _buildFavoritesSection(screenWidth),
                    SizedBox(height: 120), // Space for navbar
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavBarView(
                selectedView: NavBarViews.profile,
                onItemTapped: (NavBarViews view) {
                  if (view == NavBarViews.home) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.profileTitle,
          style: _getResponsiveHeaderStyle(screenWidth),
        ),
        GestureDetector(
          onTap: _showLimitedOfferBottomSheet,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 768 ? 20 : 16,
              vertical: screenWidth >= 768 ? 12 : 10,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.activeNavGradient,
              borderRadius: BorderRadius.circular(screenWidth >= 768 ? 25 : 22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  color: AppColors.white,
                  size: screenWidth >= 768 ? 18 : 16,
                ),
                SizedBox(width: AppPaddings.xs),
                Text(
                  AppStrings.limitedOfferBtn,
                  style: _getResponsiveLimitedOfferStyle(screenWidth),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(double screenWidth) {
    return Row(
      children: [
        // Profile Image
        Container(
          width: screenWidth >= 768 ? 80 : 60,
          height: screenWidth >= 768 ? 80 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth >= 768 ? 20 : 16),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8E35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth >= 768 ? 20 : 16),
            child: Image.asset(
              'assets/images/profile_photo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.gray30,
                  child: Icon(
                    Icons.person,
                    color: AppColors.gray60,
                    size: screenWidth >= 768 ? 40 : 30,
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(width: AppPaddings.l),

        // Profile Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.userName,
                style: _getResponsiveNameStyle(screenWidth),
              ),
              SizedBox(height: AppPaddings.xs),
              Text(
                AppStrings.userIdLabel,
                style: _getResponsiveIdStyle(screenWidth),
              ),
            ],
          ),
        ),

        // Add Photo Button
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth >= 768 ? 20 : 16,
            vertical: screenWidth >= 768 ? 12 : 10,
          ),
          decoration: BoxDecoration(
            color: AppColors.gray20,
            borderRadius: BorderRadius.circular(screenWidth >= 768 ? 14 : 12),
          ),
          child: Text(
            AppStrings.addPhotoBtn,
            style: _getResponsiveAddPhotoStyle(screenWidth),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.myFavorites,
          style: _getResponsiveFavoritesTitleStyle(screenWidth),
        ),

        SizedBox(height: AppPaddings.l),

        // Movies Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: AppPaddings.m,
          mainAxisSpacing: AppPaddings.l,
          children: [
            _buildMovieCard(
              title: AppStrings.loveAgain,
              studio: AppStrings.sony,
              imagePath: 'assets/images/love_again.png',
              screenWidth: screenWidth,
            ),
            _buildMovieCard(
              title: AppStrings.pastLives,
              studio: AppStrings.a24,
              imagePath: 'assets/images/past_lives.png',
              screenWidth: screenWidth,
            ),
            _buildMovieCard(
              title: AppStrings.anyoneButYou,
              studio: AppStrings.columbia,
              imagePath: 'assets/images/anyone_but_you.png',
              screenWidth: screenWidth,
            ),
            _buildMovieCard(
              title: AppStrings.culpaMia,
              studio: AppStrings.netflix,
              imagePath: 'assets/images/culpa_mia.png',
              screenWidth: screenWidth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovieCard({
    required String title,
    required String studio,
    required String imagePath,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie Poster
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth >= 768 ? 16 : 12),
              color: AppColors.gray20,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth >= 768 ? 16 : 12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.gray30,
                    child: Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.gray60,
                        size: screenWidth >= 768 ? 40 : 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: AppPaddings.s),

        // Movie Title
        Text(
          title,
          style: _getResponsiveMovieTitleStyle(screenWidth),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: AppPaddings.xs),

        // Studio
        Text(
          studio,
          style: _getResponsiveStudioStyle(screenWidth),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Responsive Text Styles
  TextStyle _getResponsiveHeaderStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading3;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading4;
    } else {
      return AppTextStyles.heading5;
    }
  }

  TextStyle _getResponsiveLimitedOfferStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumBold;
    } else {
      return AppTextStyles.bodySmallBold;
    }
  }

  TextStyle _getResponsiveNameStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading5;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading6;
    } else {
      return AppTextStyles.bodyXLargeBold;
    }
  }

  TextStyle _getResponsiveIdStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.gray60);
    } else {
      return AppTextStyles.bodySmallRegular.copyWith(color: AppColors.gray60);
    }
  }

  TextStyle _getResponsiveAddPhotoStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumMedium;
    } else {
      return AppTextStyles.bodySmallMedium;
    }
  }

  TextStyle _getResponsiveFavoritesTitleStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading4;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading5;
    } else {
      return AppTextStyles.heading6;
    }
  }

  TextStyle _getResponsiveMovieTitleStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyLargeBold;
    } else {
      return AppTextStyles.bodyMediumBold;
    }
  }

  TextStyle _getResponsiveStudioStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.gray60);
    } else {
      return AppTextStyles.bodySmallRegular.copyWith(color: AppColors.gray60);
    }
  }
}
