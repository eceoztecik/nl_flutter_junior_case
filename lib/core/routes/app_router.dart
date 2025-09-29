import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/auth/views/register_view.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:jr_case_boilerplate/features/profile/view/profile_view.dart';
import 'package:jr_case_boilerplate/features/splash/view/splash_view.dart';
import 'package:jr_case_boilerplate/features/upload_photo/view/upload_photo_view.dart';
import 'package:jr_case_boilerplate/tab_container.dart';
import 'app_routes.dart';

abstract class AppRouter {
  // Route generator
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _createRoute(const SplashScreen(), settings: settings);

      case AppRoutes.login:
        return _createRoute(const LoginView(), settings: settings);

      case AppRoutes.register:
        return _createRoute(const RegisterView(), settings: settings);
      case AppRoutes.home:
        return _createRoute(TabContainer(), settings: settings);
      case AppRoutes.profilePhotoUpload:
        return _createRoute(const ProfilePhotoUploadPage(), settings: settings);
      case AppRoutes.profile:
        return _createRoute(const ProfilePage(), settings: settings);

      default:
        return _createRoute(_placeholderPage('404 - Page Not Found'));
    }
  }

  // Get static routes map for MaterialApp routes parameter
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.login: (context) => const LoginView(),
      AppRoutes.register: (context) => const RegisterView(),
      AppRoutes.home: (context) => TabContainer(),
      AppRoutes.profile: (context) => const ProfilePage(),
    };
  }

  // Custom page route with slide animation
  static Route<dynamic> _createRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  // Placeholder page for development
  static Widget _placeholderPage(String pageName) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D0808), Color(0xFF1A0404), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.35, 0.6],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.red.shade400),
            const SizedBox(height: 20),
            Text(
              '$pageName Coming Soon!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This page is under development',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
