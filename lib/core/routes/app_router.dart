import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/splash/view/splash_view.dart';
import 'app_routes.dart';

abstract class AppRouter {
  // Route generator
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _createRoute(const SplashScreen());

      case AppRoutes.login:
        return _createRoute(const LoginView());

      case AppRoutes.register:
        // return _createRoute(const RegisterView());
        return _createRoute(_placeholderPage('Register'));

      default:
        return _createRoute(_placeholderPage('404 - Page Not Found'));
    }
  }

  // Get static routes map for MaterialApp routes parameter
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.login: (context) => const LoginView(),
      AppRoutes.register: (context) => _placeholderPage('Register'),
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
