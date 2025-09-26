import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool enabled;
  final int maxLines;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final bool showLabel;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.showLabel = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Extension sizes
    final responsivePadding = _getResponsivePadding(screenWidth);
    final responsiveRadius = _getResponsiveRadius(screenWidth);
    final responsiveSpacing = _getResponsiveSpacing(screenWidth);

    final containerHeight = screenWidth > 900
        ? 80.0
        : screenWidth > 600
        ? 76.0
        : 72.0;
    final iconSize = screenWidth > 900
        ? 24.0
        : screenWidth > 600
        ? 22.0
        : 20.0;
    final fontSize = screenWidth > 900
        ? 18.0
        : screenWidth > 600
        ? 17.0
        : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: AppColors.gray80,
              fontSize: fontSize - 2,
            ),
          ),
          SizedBox(height: responsiveSpacing),
        ],

        // Text Field Container
        SizedBox(
          height: containerHeight,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? !_isPasswordVisible : false,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            style: AppTextStyles.bodyLargeRegular.copyWith(
              color: widget.enabled ? AppColors.white : AppColors.gray50,
              fontSize: fontSize,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyLargeRegular.copyWith(
                color: AppColors.gray50,
                fontSize: fontSize,
              ),

              // Icons
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: AppColors.white,
                      size: iconSize,
                    )
                  : null,

              suffixIcon: _buildSuffixIcon(iconSize),

              filled: true,
              fillColor: AppColors.white.withOpacity(0.05),

              // Borders - with Extension radius
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.3),
                  width: screenWidth > 900 ? 2 : 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: screenWidth > 900 ? 2 : 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(responsiveRadius),
                borderSide: BorderSide(color: AppColors.gray20, width: 1),
              ),

              // Padding
              contentPadding: responsivePadding,

              // Error style
              errorStyle: AppTextStyles.bodySmallRegular.copyWith(
                color: AppColors.error,
                height: 0.6,
                fontSize: screenWidth > 600 ? 13.0 : 12.0,
              ),
              errorMaxLines: 1,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  EdgeInsets _getResponsivePadding(double screenWidth) {
    if (screenWidth > 900) {
      return const EdgeInsets.symmetric(
        horizontal: AppPaddings.xl,
        vertical: AppPaddings.m,
      );
    } else if (screenWidth > 600) {
      return const EdgeInsets.symmetric(
        horizontal: AppPaddings.l,
        vertical: AppPaddings.s + AppPaddings.xs,
      );
    } else {
      return const EdgeInsets.symmetric(
        horizontal: AppPaddings.m,
        vertical: AppPaddings.m + AppPaddings.xs,
      );
    }
  }

  // Radius values ​​from AppPaddings
  double _getResponsiveRadius(double screenWidth) {
    if (screenWidth > 900) {
      return AppPaddings.l - AppPaddings.xs;
    } else if (screenWidth > 600) {
      return AppPaddings.m + AppPaddings.xs;
    } else {
      return AppPaddings.m + AppPaddings.xs / 2;
    }
  }

  // Spacing values ​​from AppPaddings
  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth > 600) {
      return AppPaddings.s + AppPaddings.xs / 2;
    } else {
      return AppPaddings.s;
    }
  }

  Widget? _buildSuffixIcon(double iconSize) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.white.withOpacity(0.3),
          size: iconSize,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: AppColors.white.withOpacity(0.3),
          size: iconSize,
        ),
        onPressed: widget.onSuffixTap,
      );
    }
    return null;
  }
}
