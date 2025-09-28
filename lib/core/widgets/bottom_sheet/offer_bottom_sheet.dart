import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';

class LimitedOfferPopup extends StatefulWidget {
  const LimitedOfferPopup({Key? key}) : super(key: key);

  @override
  _LimitedOfferPopupState createState() => _LimitedOfferPopupState();
}

class _LimitedOfferPopupState extends State<LimitedOfferPopup> {
  int selectedPackageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: _getResponsiveHeight(screenHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_getResponsiveBorderRadius(screenWidth)),
          topRight: Radius.circular(_getResponsiveBorderRadius(screenWidth)),
        ),
      ),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  _getResponsiveBorderRadius(screenWidth),
                ),
                topRight: Radius.circular(
                  _getResponsiveBorderRadius(screenWidth),
                ),
              ),
              child: Image.asset(
                'assets/images/popup_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Padding(
              padding: _getResponsivePadding(screenWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: _getResponsiveSpacing(screenWidth) * 0.8),

                  // Title
                  Text(
                    AppStrings.limitedOffer,
                    style: _getResponsiveTitleStyle(screenWidth),
                  ),

                  SizedBox(height: AppPaddings.m),

                  // Subtitle
                  Text(
                    AppStrings.offerSubtitle,
                    textAlign: TextAlign.center,
                    style: _getResponsiveSubtitleStyle(screenWidth),
                  ),

                  SizedBox(height: _getResponsiveSpacing(screenWidth)),

                  // Bonus section
                  Container(
                    padding: _getResponsiveContainerPadding(screenWidth),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        _getResponsiveContainerRadius(screenWidth),
                      ),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.bonusFeatures,
                          style: _getResponsiveBonusTitleStyle(screenWidth),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenWidth) * 0.7,
                        ),

                        // Bonus icons row
                        _buildBonusIconsRow(screenWidth),
                      ],
                    ),
                  ),

                  SizedBox(height: _getResponsiveSpacing(screenWidth) * 0.8),

                  // Package selection title
                  Text(
                    AppStrings.selectTokenPackage,
                    textAlign: TextAlign.center,
                    style: _getResponsivePackageTitleStyle(screenWidth),
                  ),

                  SizedBox(height: _getResponsiveSpacing(screenWidth) * 0.7),

                  // Package cards with overlapping discount badges
                  _buildPackageCardsSection(screenWidth),

                  SizedBox(height: _getResponsiveSpacing(screenWidth)),

                  // Buy button
                  _buildBuyButton(screenWidth),

                  SizedBox(height: _getResponsiveSpacing(screenWidth) * 0.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusIconsRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBonusItem(
          imagePath: 'assets/images/popup1.png',
          label: AppStrings.premiumAccount,
          screenWidth: screenWidth,
        ),
        _buildBonusItem(
          imagePath: 'assets/images/popup2.png',
          label: AppStrings.moreMatching,
          screenWidth: screenWidth,
        ),
        _buildBonusItem(
          imagePath: 'assets/images/popup3.png',
          label: AppStrings.prioritySupport,
          screenWidth: screenWidth,
        ),
        _buildBonusItem(
          imagePath: 'assets/images/popup4.png',
          label: AppStrings.moreLikes,
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildPackageCardsSection(double screenWidth) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPackageIndex = 0),
                child: Container(
                  margin: EdgeInsets.only(
                    top: _getResponsiveDiscountBadgeSpace(screenWidth),
                  ),
                  child: _buildPackageCard(
                    context: context,
                    originalPrice: AppStrings.tokenPackage1,
                    newPrice: AppStrings.finalTokenPackage1,
                    priceText: AppStrings.price1,
                    weeklyText: AppStrings.weekly,
                    isSelected: selectedPackageIndex == 0,
                    packageIndex: 0,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ),
            SizedBox(width: _getResponsiveCardSpacing(screenWidth)),

            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPackageIndex = 1),
                child: Container(
                  margin: EdgeInsets.only(
                    top: _getResponsiveDiscountBadgeSpace(screenWidth),
                  ),
                  child: _buildPackageCard(
                    context: context,
                    originalPrice: AppStrings.tokenPackage2,
                    newPrice: AppStrings.finalTokenPackage2,
                    priceText: AppStrings.price2,
                    weeklyText: AppStrings.weekly,
                    isSelected: selectedPackageIndex == 1,
                    packageIndex: 1,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ),
            SizedBox(width: _getResponsiveCardSpacing(screenWidth)),

            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPackageIndex = 2),
                child: Container(
                  margin: EdgeInsets.only(
                    top: _getResponsiveDiscountBadgeSpace(screenWidth),
                  ),
                  child: _buildPackageCard(
                    context: context,
                    originalPrice: AppStrings.tokenPackage3,
                    newPrice: AppStrings.finalTokenPackage3,
                    priceText: AppStrings.price3,
                    weeklyText: AppStrings.weekly,
                    isSelected: selectedPackageIndex == 2,
                    packageIndex: 2,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ),
          ],
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: _buildDiscountBadge(
                    AppStrings.discount1,
                    selectedPackageIndex == 0,
                    screenWidth,
                  ),
                ),
              ),
              SizedBox(width: _getResponsiveCardSpacing(screenWidth)),
              Expanded(
                child: Center(
                  child: _buildDiscountBadge(
                    AppStrings.discount2,
                    selectedPackageIndex == 1,
                    screenWidth,
                  ),
                ),
              ),
              SizedBox(width: _getResponsiveCardSpacing(screenWidth)),
              Expanded(
                child: Center(
                  child: _buildDiscountBadge(
                    AppStrings.discount3,
                    selectedPackageIndex == 2,
                    screenWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuyButton(double screenWidth) {
    return CustomPrimaryButton(
      text: AppStrings.viewAllTokens,
      onPressed: () {},
    );
  }

  Widget _buildBonusItem({
    required String imagePath,
    required String label,
    required double screenWidth,
  }) {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: _getResponsiveBonusIconSize(screenWidth),
            height: _getResponsiveBonusIconSize(screenWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment.topLeft,
                radius: 1.2,
                colors: [Color(0xFF6F060B), Color(0xFF6F060B)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53E3E).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(
                  _getResponsiveBonusIconPadding(screenWidth),
                ),
                child: Image.asset(
                  imagePath,
                  width: _getResponsiveBonusImageSize(screenWidth),
                  height: _getResponsiveBonusImageSize(screenWidth),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: AppPaddings.xs),
          Container(
            constraints: BoxConstraints(
              maxWidth: _getResponsiveBonusTextMaxWidth(screenWidth),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _getResponsiveBonusLabelStyle(screenWidth),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(
    String discount,
    bool isSelected,
    double screenWidth,
  ) {
    List<Color> getBadgeColors() {
      if (isSelected) {
        return const [Color(0xFF5949E6), Color(0xFF5949E6)];
      } else {
        return const [Color(0xFF6F060B), Color(0xFF6F060B)];
      }
    }

    return Container(
      padding: _getResponsiveBadgePadding(screenWidth),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getBadgeColors(),
        ),
        borderRadius: BorderRadius.circular(
          _getResponsiveBadgeRadius(screenWidth),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          if (isSelected) ...[
            BoxShadow(
              color: const Color(0xFF5949E6).withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ],
      ),
      child: Text(discount, style: _getResponsiveBadgeTextStyle(screenWidth)),
    );
  }

  Widget _buildPackageCard({
    required BuildContext context,
    required String originalPrice,
    required String newPrice,
    required String priceText,
    required String weeklyText,
    required bool isSelected,
    required int packageIndex,
    required double screenWidth,
  }) {
    List<Color> getGradientColors() {
      if (isSelected) {
        return const [Color(0xFF5949E6), Color(0xFFE50914)];
      } else {
        return const [Color(0xFF6F060B), Color(0xFFE50914)];
      }
    }

    return Container(
      height: _getResponsiveCardHeight(screenWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getResponsiveCardRadius(screenWidth),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getGradientColors(),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          if (isSelected) ...[
            BoxShadow(
              color: const Color(0xFF5949E6).withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ],
        border: isSelected
            ? Border.all(
                color: const Color(0xFF5949E6).withOpacity(0.6),
                width: 2,
              )
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: _getResponsiveCardPadding(screenWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    originalPrice,
                    textAlign: TextAlign.center,
                    style: _getResponsiveOriginalPriceStyle(screenWidth),
                  ),

                  Text(
                    newPrice,
                    textAlign: TextAlign.center,
                    style: _getResponsiveNewPriceStyle(screenWidth, isSelected),
                  ),

                  Text(
                    AppStrings.jeton,
                    textAlign: TextAlign.center,
                    style: _getResponsiveJetonTextStyle(
                      screenWidth,
                      isSelected,
                    ),
                  ),

                  SizedBox(height: _getResponsiveCardInnerSpacing(screenWidth)),

                  Center(
                    child: Container(
                      width: _getResponsiveDividerWidth(screenWidth),
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppPaddings.s),

                  Text(
                    priceText,
                    textAlign: TextAlign.center,
                    style: _getResponsivePriceStyle(screenWidth, isSelected),
                  ),

                  Text(
                    weeklyText,
                    textAlign: TextAlign.center,
                    style: _getResponsiveWeeklyStyle(screenWidth),
                  ),
                ],
              ),
            ),
          ),

          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _getResponsiveCardRadius(screenWidth),
                  ),
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.5),
                    radius: 1.2,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveHeight(double screenHeight) {
    if (screenHeight < 600) return screenHeight * 0.85;
    if (screenHeight < 800) return screenHeight * 0.75;
    return screenHeight * 0.75;
  }

  double _getResponsiveBorderRadius(double screenWidth) {
    if (screenWidth < 360) return 24.0;
    if (screenWidth < 768) return 32.0;
    return 40.0;
  }

  EdgeInsets _getResponsivePadding(double screenWidth) {
    if (screenWidth < 360)
      return const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16);
    if (screenWidth < 768)
      return const EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24);
    return const EdgeInsets.only(top: 24, bottom: 24, left: 32, right: 32);
  }

  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth < 360) return 16.0;
    if (screenWidth < 768) return 24.0;
    return 32.0;
  }

  EdgeInsets _getResponsiveContainerPadding(double screenWidth) {
    if (screenWidth < 360) return const EdgeInsets.all(12);
    if (screenWidth < 768) return const EdgeInsets.all(16);
    return const EdgeInsets.all(20);
  }

  double _getResponsiveContainerRadius(double screenWidth) {
    if (screenWidth < 360) return 16.0;
    if (screenWidth < 768) return 20.0;
    return 24.0;
  }

  double _getResponsiveBonusIconSize(double screenWidth) {
    if (screenWidth < 360) return 36.0;
    if (screenWidth < 768) return 44.0;
    return 52.0;
  }

  double _getResponsiveBonusIconPadding(double screenWidth) {
    if (screenWidth < 360) return 6.0;
    if (screenWidth < 768) return 8.0;
    return 10.0;
  }

  double _getResponsiveBonusImageSize(double screenWidth) {
    if (screenWidth < 360) return 20.0;
    if (screenWidth < 768) return 28.0;
    return 32.0;
  }

  double _getResponsiveCardHeight(double screenWidth) {
    if (screenWidth < 360) return 160.0;
    if (screenWidth < 768) return 180.0;
    return 200.0;
  }

  double _getResponsiveCardRadius(double screenWidth) {
    if (screenWidth < 360) return 12.0;
    if (screenWidth < 768) return 16.0;
    return 20.0;
  }

  EdgeInsets _getResponsiveCardPadding(double screenWidth) {
    if (screenWidth < 360) return const EdgeInsets.all(8);
    if (screenWidth < 768) return const EdgeInsets.all(12);
    return const EdgeInsets.all(16);
  }

  double _getResponsiveCardSpacing(double screenWidth) {
    if (screenWidth < 360) return 6.0;
    if (screenWidth < 768) return 8.0;
    return 12.0;
  }

  double _getResponsiveDiscountBadgeSpace(double screenWidth) {
    if (screenWidth < 360) return 8.0;
    if (screenWidth < 768) return 12.0;
    return 16.0;
  }

  EdgeInsets _getResponsiveBadgePadding(double screenWidth) {
    if (screenWidth < 360)
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
    if (screenWidth < 768)
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
  }

  double _getResponsiveBadgeRadius(double screenWidth) {
    if (screenWidth < 360) return 8.0;
    if (screenWidth < 768) return 12.0;
    return 16.0;
  }

  double _getResponsiveButtonHeight(double screenWidth) {
    if (screenWidth < 360) return 44.0;
    if (screenWidth < 768) return 48.0;
    return 56.0;
  }

  double _getResponsiveButtonRadius(double screenWidth) {
    if (screenWidth < 360) return 22.0;
    if (screenWidth < 768) return 24.0;
    return 28.0;
  }

  double _getResponsiveCardInnerSpacing(double screenWidth) {
    if (screenWidth < 360) return 12.0;
    if (screenWidth < 768) return 20.0;
    return 24.0;
  }

  double _getResponsiveDividerWidth(double screenWidth) {
    if (screenWidth < 360) return 60.0;
    if (screenWidth < 768) return 80.0;
    return 100.0;
  }

  double _getResponsiveBonusTextMaxWidth(double screenWidth) {
    if (screenWidth < 360) return 65.0;
    if (screenWidth < 768) return 70.0;
    return 80.0;
  }

  // Text Styles
  TextStyle _getResponsiveTitleStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodyLargeBold.copyWith(
        color: Colors.white,
        fontSize: 18,
      );
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyLargeSemibold.copyWith(
        color: Colors.white,
        fontSize: 22,
      );
    } else {
      return AppTextStyles.heading6.copyWith(color: Colors.white);
    }
  }

  TextStyle _getResponsiveSubtitleStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodySmallRegular.copyWith(
        color: Colors.white,
        height: 1.3,
      );
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(
        color: Colors.white,
        height: 1.3,
      );
    } else {
      return AppTextStyles.bodyLargeRegular.copyWith(
        color: Colors.white,
        height: 1.3,
      );
    }
  }

  TextStyle _getResponsiveBonusTitleStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodyMediumSemibold.copyWith(color: Colors.white);
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyLargeSemibold.copyWith(color: Colors.white);
    } else {
      return AppTextStyles.bodyXLargeSemibold.copyWith(color: Colors.white);
    }
  }

  TextStyle _getResponsiveBonusLabelStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodyXSmallMedium.copyWith(
        color: Colors.white,
        height: 1.2,
      );
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyXSmallMedium.copyWith(
        color: Colors.white,
        height: 1.2,
        fontSize: 10,
      );
    } else {
      return AppTextStyles.bodySmallMedium.copyWith(
        color: Colors.white,
        height: 1.2,
      );
    }
  }

  TextStyle _getResponsivePackageTitleStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodySmallMedium.copyWith(color: Colors.white);
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyMediumMedium.copyWith(color: Colors.white);
    } else {
      return AppTextStyles.bodyLargeMedium.copyWith(color: Colors.white);
    }
  }

  TextStyle _getResponsiveBadgeTextStyle(double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodyXSmallBold.copyWith(color: Colors.white);
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyXSmallBold.copyWith(
        color: Colors.white,
        fontSize: 11,
      );
    } else {
      return AppTextStyles.bodySmallBold.copyWith(color: Colors.white);
    }
  }

  TextStyle _getResponsiveOriginalPriceStyle(double screenWidth) {
    double fontSize = screenWidth < 360 ? 12 : (screenWidth < 768 ? 14 : 16);
    return TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: fontSize,
      decoration: TextDecoration.lineThrough,
      decorationColor: Colors.white.withOpacity(0.7),
      decorationThickness: 2,
    );
  }

  TextStyle _getResponsiveNewPriceStyle(double screenWidth, bool isSelected) {
    double fontSize;
    if (screenWidth < 360) {
      fontSize = isSelected ? 20 : 18;
    } else if (screenWidth < 768) {
      fontSize = isSelected ? 26 : 23;
    } else {
      fontSize = isSelected ? 30 : 26;
    }

    return AppTextStyles.bodyLargeBold.copyWith(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      height: 1.1,
    );
  }

  TextStyle _getResponsiveJetonTextStyle(double screenWidth, bool isSelected) {
    double fontSize;
    if (screenWidth < 360) {
      fontSize = isSelected ? 11 : 10;
    } else if (screenWidth < 768) {
      fontSize = isSelected ? 13 : 12;
    } else {
      fontSize = isSelected ? 15 : 14;
    }

    return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _getResponsivePriceStyle(double screenWidth, bool isSelected) {
    double fontSize;
    if (screenWidth < 360) {
      fontSize = isSelected ? 14 : 13;
    } else if (screenWidth < 768) {
      fontSize = isSelected ? 17 : 16;
    } else {
      fontSize = isSelected ? 20 : 18;
    }

    return AppTextStyles.bodyLargeMedium.copyWith(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle _getResponsiveWeeklyStyle(double screenWidth) {
    double fontSize = screenWidth < 360 ? 8 : (screenWidth < 768 ? 9 : 10);
    return TextStyle(
      color: Colors.white.withOpacity(0.8),
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.2,
    );
  }
}
