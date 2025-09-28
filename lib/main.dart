import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jr_case_boilerplate/core/routes/app_router.dart';
import 'package:jr_case_boilerplate/core/routes/app_routes.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/features/auth/providers/auth_provider.dart';

void main() {
  runApp(const ShartflixApp());
}

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: AppStrings.appName,
        //theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,

        // Initial route
        initialRoute: AppRoutes.initial,

        // Static routes
        routes: AppRouter.getRoutes(),

        // Dynamic route generator
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
