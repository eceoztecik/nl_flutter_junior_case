import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/routes/app_routes.dart';
import 'package:jr_case_boilerplate/features/auth/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = context.read<AuthProvider>();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // AuthProvider initial status check
    while (authProvider.status == AuthStatus.initial) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    if (authProvider.isAuthenticated && authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: AppColors.combinedBg(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Container
                  Container(
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 120 : 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      child: Center(
                        child: Image.asset(
                          'assets/images/Icon.png',
                          errorBuilder: (context, error, stackTrace) {
                            print('Asset error: $error');
                            return Text('N', style: AppTextStyles.heading1);
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? AppPaddings.xl : AppPaddings.l),

                  // App Name
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.heading2.copyWith(
                      fontSize: isTablet ? 36 : 28,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: isTablet ? 40 : 30),

                  // Loading Indicator
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 80 : 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
