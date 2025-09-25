import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveHeight = height ?? _getResponsiveHeight(screenHeight);
    final responsiveBorderRadius = borderRadius ?? 16.0;
    final loadingSize = _getLoadingSize(responsiveHeight);
    final textStyle = _getResponsiveTextStyle(context, screenWidth);

    return SizedBox(
      width: width ?? double.infinity,
      height: responsiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.gray30,
          disabledForegroundColor: AppColors.gray50,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: loadingSize,
                  height: loadingSize,
                  child: CircularProgressIndicator(
                    strokeWidth: loadingSize * 0.08,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Text(text, style: textStyle, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  // Responsive yükseklik hesaplama
  double _getResponsiveHeight(double screenHeight) {
    if (screenHeight < 600) return 48.0; // Küçük ekranlar
    if (screenHeight < 800) return 56.0; // Orta ekranlar
    return 56.0; // Büyük ekranlar
  }

  // Loading indicator boyutu
  double _getLoadingSize(double buttonHeight) {
    return buttonHeight * 0.4; // Buton yüksekliğinin %40'ı
  }

  // Responsive text style
  TextStyle _getResponsiveTextStyle(BuildContext context, double screenWidth) {
    if (screenWidth < 360) {
      return AppTextStyles.bodyMediumBold; // 14px
    } else if (screenWidth < 768) {
      return AppTextStyles.bodyLargeBold; // 16px
    } else {
      return AppTextStyles.bodyXLargeBold; // 18px (tablet için)
    }
  }
}
