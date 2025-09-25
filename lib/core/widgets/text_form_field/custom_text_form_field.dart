import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: AppColors.gray80,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Field Container
        SizedBox(
          height: 72,
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
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyLargeRegular.copyWith(
                color: AppColors.gray50,
              ),

              // Icons
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.white, size: 20)
                  : null,

              suffixIcon: _buildSuffixIcon(),

              filled: true,
              fillColor: AppColors.white.withOpacity(0.05),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: AppColors.gray20, width: 1),
              ),

              // Padding
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),

              errorStyle: AppTextStyles.bodySmallRegular.copyWith(
                color: AppColors.error,
                height: 1.2,
              ),
              errorMaxLines: 1,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      // Password visibility toggle
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.gray50,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      // Custom suffix icon
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppColors.gray50, size: 20),
        onPressed: widget.onSuffixTap,
      );
    }
    return null;
  }
}
