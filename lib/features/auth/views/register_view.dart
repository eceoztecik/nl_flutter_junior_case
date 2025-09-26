import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/enums/assets/app_images.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';
import 'package:jr_case_boilerplate/core/mixins/validators_mixin.dart';
import 'package:jr_case_boilerplate/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:jr_case_boilerplate/features/auth/enums/social_login_type.dart';
import 'package:jr_case_boilerplate/features/auth/extensions/social_login_type_ext.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with ValidatorsMixin {
  // Form controllers for input fields
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State management for loading and terms acceptance
  bool _isRegisterLoading = false;
  bool _isTermsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Validate form and check if terms are accepted before proceeding
    if (_formKey.currentState!.validate() && _isTermsAccepted) {
      setState(() {
        _isRegisterLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      } catch (e) {
        // Handle registration errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kayıt başarısız: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isRegisterLoading = false;
          });
        }
      }
    } else if (!_isTermsAccepted) {
      // Show error if terms are not accepted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı sözleşmesini kabul etmelisiniz'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AppColors.combinedBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogoSection(screenWidth),

                  SizedBox(
                    height: AppPaddingsResponsive.getLogoInputSpacing(
                      screenWidth,
                    ),
                  ),

                  _buildNameField(),
                  SizedBox(
                    height: AppPaddingsResponsive.getInputSpacing(screenWidth),
                  ),
                  _buildEmailField(),
                  SizedBox(
                    height: AppPaddingsResponsive.getInputSpacing(screenWidth),
                  ),
                  _buildPasswordField(),
                  SizedBox(
                    height: AppPaddingsResponsive.getInputSpacing(screenWidth),
                  ),
                  _buildConfirmPasswordField(),

                  SizedBox(height: _getTermsSpacing(screenWidth)),
                  _buildTermsCheckbox(screenWidth),

                  SizedBox(
                    height: AppPaddingsResponsive.getSectionSpacing(
                      screenWidth,
                    ),
                  ),
                  _buildRegisterButton(),

                  SizedBox(
                    height: AppPaddingsResponsive.getSectionSpacing(
                      screenWidth,
                    ),
                  ),
                  _buildSocialLoginSection(screenWidth),

                  SizedBox(
                    height: AppPaddingsResponsive.getSocialSpacing(screenWidth),
                  ),
                  _buildLoginLink(),

                  SizedBox(height: _getBottomSpacing(screenWidth)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getTermsSpacing(double screenWidth) {
    if (screenWidth >= 768) {
      return AppPaddings.m;
    } else {
      return AppPaddings.s;
    }
  }

  double _getBottomSpacing(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppPaddings.xl;
    } else if (screenWidth >= 768) {
      return AppPaddings.l;
    } else {
      return AppPaddings.m + AppPaddings.s;
    }
  }

  Widget _buildLogoSection(double screenWidth) {
    final logoSize = screenWidth >= 1200 ? 90.0 : 80.0;

    return Transform.translate(
      offset: const Offset(0, -10),
      child: Column(
        children: [
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Center(child: Image.asset(AppImages.logo.path)),
          ),

          SizedBox(height: AppPaddings.s),

          Text('Hesap Oluştur', style: AppTextStyles.heading4),

          SizedBox(height: AppPaddings.xs),

          Text(
            AppStrings.registerSubtitle,
            style: AppTextStyles.bodyMediumRegular.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      hintText: AppStrings.fullName,
      controller: _nameController,
      keyboardType: TextInputType.name,
      prefixIcon: Icons.person_outline,
      textInputAction: TextInputAction.next,
      validator: validateName,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hintText: AppStrings.email,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.mail_outline,
      textInputAction: TextInputAction.next,
      validator: validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      hintText: AppStrings.password,
      controller: _passwordController,
      isPassword: true,
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.next,
      validator: validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      hintText: 'Şifre Tekrar',
      controller: _confirmPasswordController,
      isPassword: true,
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.done,
      // Custom validation to check password match
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Şifre tekrarı gerekli';
        }
        if (value != _passwordController.text) {
          return 'Şifreler eşleşmiyor';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox(double screenWidth) {
    final fontSize = screenWidth >= 768 ? 14.0 : 13.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: screenWidth >= 768 ? 1.1 : 1.0,
          child: Checkbox(
            value: _isTermsAccepted,
            onChanged: (value) {
              setState(() {
                _isTermsAccepted = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            checkColor: AppColors.white,
            side: BorderSide(color: AppColors.gray40),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppPaddings.xs),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmallRegular.copyWith(
                  color: AppColors.gray60,
                  fontSize: fontSize,
                ),
                children: [
                  TextSpan(text: AppStrings.termsLine1),
                  TextSpan(
                    text: ' ${AppStrings.termsLine2}',
                    style: TextStyle(
                      color: AppColors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' ${AppStrings.termsLine3}'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CustomPrimaryButton(
      text: AppStrings.register,
      isLoading: _isRegisterLoading,
      onPressed: _handleRegister,
    );
  }

  Widget _buildSocialLoginSection(double screenWidth) {
    final socialButtonSpacing = screenWidth >= 768
        ? AppPaddings.m + AppPaddings.xs
        : AppPaddings.m;
    final socialButtonSize = screenWidth >= 1200
        ? 70.0
        : screenWidth >= 768
        ? 65.0
        : 60.0;
    final socialIconSize = screenWidth >= 1200
        ? 32.0
        : screenWidth >= 768
        ? 30.0
        : 28.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          SocialLoginType.google,
          socialButtonSize,
          socialIconSize,
        ),
        SizedBox(width: socialButtonSpacing),
        _buildSocialButton(
          SocialLoginType.apple,
          socialButtonSize,
          socialIconSize,
        ),
        SizedBox(width: socialButtonSpacing),
        _buildSocialButton(
          SocialLoginType.facebook,
          socialButtonSize,
          socialIconSize,
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    SocialLoginType type,
    double size,
    double iconSize,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(AppPaddings.m),
        border: Border.all(color: AppColors.gray20),
      ),
      child: IconButton(
        onPressed: () => type.authenticate(),
        icon: Icon(type.icon, color: type.iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.hasAccountQuestion,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.gray60,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppStrings.login,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
