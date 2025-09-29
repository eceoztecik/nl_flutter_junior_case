import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jr_case_boilerplate/features/home/providers/movie_providers.dart';
import 'package:jr_case_boilerplate/features/splash/view/splash_view.dart';
import 'package:jr_case_boilerplate/core/routes/app_router.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/features/auth/providers/auth_provider.dart';
import 'package:jr_case_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:jr_case_boilerplate/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // StorageService initialize
  await StorageService.init();

  runApp(const ShartflixApp());
}

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MovieProvider>(
          create: (_) => MovieProvider(),
          update: (context, authProvider, movieProvider) {
            final provider = movieProvider ?? MovieProvider();

            if (authProvider.isAuthenticated) {
              _setTokenToMovieProvider(provider);
            }
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: AppRouter.getRoutes(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }

  void _setTokenToMovieProvider(MovieProvider provider) async {
    try {
      final authRepo = AuthRepository();
      final token = await authRepo.getStoredToken();
      if (token != null) {
        provider.setAuthToken(token);
      }
    } catch (e) {
      print('Token error: $e');
    }
  }
}
