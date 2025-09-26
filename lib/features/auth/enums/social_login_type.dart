import 'package:flutter/material.dart';

enum SocialLoginType { google, apple, facebook }

extension SocialLoginTypeExtension on SocialLoginType {
  String get name {
    switch (this) {
      case SocialLoginType.google:
        return 'Google';
      case SocialLoginType.apple:
        return 'Apple';
      case SocialLoginType.facebook:
        return 'Facebook';
    }
  }

  IconData get icon {
    switch (this) {
      case SocialLoginType.google:
        return Icons.g_mobiledata;
      case SocialLoginType.apple:
        return Icons.apple;
      case SocialLoginType.facebook:
        return Icons.facebook;
    }
  }
}
