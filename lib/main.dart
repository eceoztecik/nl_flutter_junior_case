import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/routes/app_router.dart';
import 'package:jr_case_boilerplate/core/routes/app_routes.dart';
import 'core/constants/app_strings.dart';

void main() {
  runApp(const ShartflixApp());
}

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      //theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,

      // Initial route
      initialRoute: AppRoutes.initial,

      // Static routes
      routes: AppRouter.getRoutes(),

      // Dynamic route generator
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
