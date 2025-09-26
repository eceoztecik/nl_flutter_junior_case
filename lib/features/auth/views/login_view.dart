import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/enums/assets/app_images.dart';
import 'package:jr_case_boilerplate/core/routes/app_routes.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';
import 'package:jr_case_boilerplate/core/mixins/validators_mixin.dart';
import 'package:jr_case_boilerplate/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:jr_case_boilerplate/features/auth/enums/social_login_type.dart';
import 'package:jr_case_boilerplate/features/auth/extensions/social_login_type_ext.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidatorsMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoginLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Giriş başarısız: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoginLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppColors.combinedBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPaddings.screen.horizontal,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogoSection(),

                  const SizedBox(height: 24),

                  _buildEmailField(),
                  const SizedBox(height: 4),
                  _buildPasswordField(),

                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: _buildForgotPassword(),
                  ),
                  const SizedBox(height: 12),
                  // Login Button
                  _buildLoginButton(),

                  const SizedBox(height: 32),
                  // Social Login Section
                  _buildSocialLoginSection(),

                  const SizedBox(height: 24),
                  // Register Link
                  _buildRegisterLink(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Lottie Animation
        Transform.translate(
          offset: const Offset(0, -40),
          child: SizedBox(
            height: 160,
            child: Lottie.network(
              'https://cdn.lottielab.com/l/De6hoGR5fW2CKF.json',
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ),

        // Logo
        Transform.translate(
          offset: const Offset(0, -24),
          child: Column(
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Image.asset(AppImages.logo.path)),
              ),
              const SizedBox(height: 4),
              Text(AppStrings.login, style: AppTextStyles.heading4),
              const SizedBox(height: 4),
              Text(
                AppStrings.loginSubtitle,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hintText: AppStrings.email,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.mail_outline,
      textInputAction: TextInputAction.next,
      validator: validateEmail, // Mixin validator
    );
  }

  // CustomTextField
  Widget _buildPasswordField() {
    return CustomTextField(
      hintText: AppStrings.password,
      controller: _passwordController,
      isPassword: true, // Password field
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.done,
      validator: validatePassword, // Mixin validator
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppStrings.forgotPassword,
          style: AppTextStyles.bodyMediumMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return CustomPrimaryButton(
      text: AppStrings.login,
      isLoading: _isLoginLoading,
      onPressed: _handleLogin,
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(SocialLoginType.google),
            const SizedBox(width: 16),
            _buildSocialButton(SocialLoginType.apple),
            const SizedBox(width: 16),
            _buildSocialButton(SocialLoginType.facebook),
          ],
        ),
      ],
    );
  }

  // _buildSocialButton
  Widget _buildSocialButton(SocialLoginType type) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray20),
      ),
      child: IconButton(
        onPressed: () => type.authenticate(),
        icon: Icon(type.icon, color: type.iconColor, size: 28),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.gray60,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: Text(
            AppStrings.register2,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
