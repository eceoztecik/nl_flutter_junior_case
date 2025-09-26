import 'dart:ui';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/features/auth/enums/social_login_type.dart';

extension SocialLoginTypeHelper on SocialLoginType {
  Color get backgroundColor {
    return AppColors.gray10;
  }

  Color get iconColor {
    return AppColors.white;
  }

  Future<void> authenticate() async {
    switch (this) {
      case SocialLoginType.google:
        // Google Sign In
        break;
      case SocialLoginType.apple:
        // Apple Sign In
        break;
      case SocialLoginType.facebook:
        // Facebook Login
        break;
    }
  }
}
