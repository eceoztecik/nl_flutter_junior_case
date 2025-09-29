import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';
import 'package:jr_case_boilerplate/features/auth/providers/auth_provider.dart';

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilirken hata oluştu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _handleContinue() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen bir fotoğraf seçin'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.uploadPhoto(_selectedImage!);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil fotoğrafı başarıyla yüklendi'),
            backgroundColor: AppColors.success,
          ),
        );

        // Argument
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final fromRegister = args?['fromRegister'] ?? false;

        if (fromRegister) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Fotoğraf yüklenirken hata oluştu',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleSkip() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final fromRegister = args?['fromRegister'] ?? false;

    if (fromRegister) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: AppColors.combinedBg(
        child: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  _buildHeader(screenWidth),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppPaddingsResponsive.getScreenPadding(
                        screenWidth,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.08),
                          _buildProfileIcon(screenWidth),
                          SizedBox(height: screenHeight * 0.04),
                          Text(
                            AppStrings.uploadPhoto,
                            style: _getResponsiveTitleStyle(screenWidth),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppPaddings.s),
                          Text(
                            AppStrings.uploadPhotoDesc1,
                            style: _getResponsiveDescStyle(screenWidth),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.06),
                          _buildPhotoUploadArea(
                            screenWidth,
                            screenHeight,
                            authProvider.isLoading,
                          ),
                          SizedBox(height: screenHeight * 0.08),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtons(screenWidth, authProvider.isLoading),
                ],
              );
            },
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

  Widget _buildPhotoUploadArea(
    double screenWidth,
    double screenHeight,
    bool isLoading,
  ) {
    final containerSize = screenWidth >= 768 ? 200.0 : 176.0;

    return GestureDetector(
      onTap: isLoading || _selectedImage != null ? null : _pickImage,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.gray20, width: 1),
        ),
        child: _selectedImage == null
            ? _buildUploadPlaceholder(containerSize, isLoading)
            : _buildSelectedImage(containerSize, isLoading),
      ),
    );
  }

  Widget _buildUploadPlaceholder(double size, bool isLoading) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.add, color: AppColors.gray40, size: size * 0.15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage(double size, bool isLoading) {
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
        if (isLoading)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 3,
              ),
            ),
          ),
        if (!isLoading)
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
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButtons(double screenWidth, bool isLoading) {
    return Container(
      padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
      child: Column(
        children: [
          CustomPrimaryButton(
            text: AppStrings.continueBtn,
            onPressed: (_selectedImage == null || isLoading)
                ? null
                : _handleContinue,
            isLoading: isLoading,
          ),
          SizedBox(height: AppPaddings.m),
          TextButton(
            onPressed: isLoading ? null : _handleSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              AppStrings.skip,
              style: _getResponsiveSkipStyle(screenWidth).copyWith(
                color: isLoading ? AppColors.gray50 : AppColors.gray70,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

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
      return AppTextStyles.bodyLargeMedium;
    } else {
      return AppTextStyles.bodyMediumMedium;
    }
  }
}
