import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';

class ProfilePhotoUploadPage extends StatefulWidget {
  const ProfilePhotoUploadPage({super.key});

  @override
  State<ProfilePhotoUploadPage> createState() => _ProfilePhotoUploadPageState();
}

class _ProfilePhotoUploadPageState extends State<ProfilePhotoUploadPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf seçilirken hata oluştu: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _handleContinue() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _handleSkip() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: AppColors.combinedBg(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(screenWidth),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),

                      // Profile Icon
                      _buildProfileIcon(screenWidth),

                      SizedBox(height: screenHeight * 0.04),

                      // Title
                      Text(
                        AppStrings.uploadPhoto,
                        style: _getResponsiveTitleStyle(screenWidth),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: AppPaddings.s),

                      // Description
                      Text(
                        AppStrings.uploadPhotoDesc1,
                        style: _getResponsiveDescStyle(screenWidth),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.06),

                      // Photo Upload Area
                      _buildPhotoUploadArea(screenWidth, screenHeight),

                      SizedBox(height: screenHeight * 0.08),
                    ],
                  ),
                ),
              ),

              // Bottom Buttons
              _buildBottomButtons(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPaddingsResponsive.getScreenPadding(screenWidth).left,
        vertical: AppPaddings.m,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: screenWidth >= 768 ? 24 : 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppStrings.profileDetail,
              style: _getResponsiveHeaderStyle(screenWidth),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProfileIcon(double screenWidth) {
    final iconSize = screenWidth >= 768 ? 80.0 : 60.0;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: AppColors.gray20,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, color: AppColors.gray60, size: iconSize * 0.6),
    );
  }

  Widget _buildPhotoUploadArea(double screenWidth, double screenHeight) {
    final containerSize = screenWidth >= 768 ? 200.0 : 176.0;

    return GestureDetector(
      onTap: _selectedImage == null ? _pickImage : null,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.gray20,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: _selectedImage == null
            ? _buildUploadPlaceholder(containerSize)
            : _buildSelectedImage(containerSize),
      ),
    );
  }

  Widget _buildUploadPlaceholder(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.gray20,
          width: 2,
          style: BorderStyle.none,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.gray10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.gray40,
                size: size * 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage(double size) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            image: DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(double screenWidth) {
    return Container(
      padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
      child: Column(
        children: [
          // Continue Button
          CustomPrimaryButton(
            text: AppStrings.continueBtn,
            onPressed: _handleContinue,
          ),

          SizedBox(height: AppPaddings.m),

          // Skip Button
          TextButton(
            onPressed: _handleSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              AppStrings.skip,
              style: _getResponsiveSkipStyle(screenWidth),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  // Responsive Text Styles
  TextStyle _getResponsiveHeaderStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading5;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading6;
    } else {
      return AppTextStyles.bodyXLargeBold;
    }
  }

  TextStyle _getResponsiveTitleStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading3;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading4;
    } else {
      return AppTextStyles.heading5;
    }
  }

  TextStyle _getResponsiveDescStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.bodyLargeRegular.copyWith(color: AppColors.gray70);
    } else if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.gray70);
    } else {
      return AppTextStyles.bodySmallRegular.copyWith(color: AppColors.gray70);
    }
  }

  TextStyle _getResponsiveSkipStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyLargeMedium.copyWith(color: AppColors.gray70);
    } else {
      return AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.gray70);
    }
  }
}
