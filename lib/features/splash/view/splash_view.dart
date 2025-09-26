import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushNamed(context, AppRoutes.login);
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

          child: Container(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                    Text(
                      AppStrings.appName,
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: isTablet ? 36 : 28,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: isTablet ? 80 : 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
