import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/bottom_sheet/offer_bottom_sheet.dart';
import 'package:jr_case_boilerplate/features/auth/providers/auth_provider.dart';
import 'package:jr_case_boilerplate/features/home/providers/movie_providers.dart';
import 'package:jr_case_boilerplate/features/profile/widgets/profile_movie_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
      _loadFavorites();
    });
  }

  void _refreshProfile() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      authProvider.getProfile();
    }
  }

  void _loadFavorites() {
    context.read<MovieProvider>().loadFavoriteMovies();
  }

  void _showLimitedOfferBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LimitedOfferPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MovieProvider>().loadFavoriteMovies();
      }
    });
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AppColors.combinedBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppPaddingsResponsive.getScreenPadding(screenWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppPaddings.m),
                _buildHeader(screenWidth),
                SizedBox(
                  height: AppPaddingsResponsive.getSectionSpacing(screenWidth),
                ),
                _buildProfileInfo(screenWidth),
                SizedBox(
                  height: AppPaddingsResponsive.getSectionSpacing(screenWidth),
                ),
                _buildFavoritesSection(screenWidth),
                SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.profileTitle,
          style: _getResponsiveHeaderStyle(screenWidth),
        ),
        GestureDetector(
          onTap: _showLimitedOfferBottomSheet,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 768 ? 20 : 16,
              vertical: screenWidth >= 768 ? 12 : 10,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.activeNavGradient,
              borderRadius: BorderRadius.circular(screenWidth >= 768 ? 25 : 22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  color: AppColors.white,
                  size: screenWidth >= 768 ? 18 : 16,
                ),
                SizedBox(width: AppPaddings.xs),
                Text(
                  AppStrings.limitedOfferBtn,
                  style: _getResponsiveLimitedOfferStyle(screenWidth),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(double screenWidth) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final isLoading = authProvider.isLoading;

        return Row(
          children: [
            Container(
              width: screenWidth >= 768 ? 80 : 60,
              height: screenWidth >= 768 ? 80 : 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  screenWidth >= 768 ? 20 : 16,
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  screenWidth >= 768 ? 20 : 16,
                ),
                child: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                    ? Image.network(
                        user.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultProfileIcon(screenWidth);
                        },
                      )
                    : _buildDefaultProfileIcon(screenWidth),
              ),
            ),
            SizedBox(width: AppPaddings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.gray30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  else
                    Text(
                      user?.name ?? AppStrings.defaultUserName,
                      style: _getResponsiveNameStyle(screenWidth),
                    ),
                  SizedBox(height: AppPaddings.xs),
                  if (isLoading)
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.gray30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  else
                    Text(
                      'ID: ${user?.id.substring(0, 8) ?? 'Unknown'}',
                      style: _getResponsiveIdStyle(screenWidth),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/profile-photo-upload',
                  arguments: {'fromRegister': false},
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth >= 768 ? 20 : 16,
                  vertical: screenWidth >= 768 ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray20,
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 768 ? 14 : 12,
                  ),
                ),
                child: Text(
                  AppStrings.addPhotoBtn,
                  style: _getResponsiveAddPhotoStyle(screenWidth),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultProfileIcon(double screenWidth) {
    return Container(
      color: AppColors.gray30,
      child: Icon(
        Icons.person,
        color: AppColors.gray60,
        size: screenWidth >= 768 ? 40 : 30,
      ),
    );
  }

  Widget _buildFavoritesSection(double screenWidth) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoadingFavorites) {
          return _buildFavoritesLoading(screenWidth);
        }

        if (movieProvider.favoritesErrorMessage != null) {
          return _buildFavoritesError(screenWidth, movieProvider);
        }

        if (!movieProvider.hasFavorites) {
          return _buildFavoritesEmpty(screenWidth);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.myFavorites,
              style: _getResponsiveFavoritesTitleStyle(screenWidth),
            ),
            SizedBox(height: AppPaddings.l),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: AppPaddings.m,
                mainAxisSpacing: AppPaddings.l,
              ),
              itemCount: movieProvider.favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.favoriteMovies[index];
                return ProfileMovieCard(
                  title: movie.title,
                  description: movie.description ?? '',
                  posterUrl: movie.posterUrl,
                  onTap: () {},
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesLoading(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.myFavorites,
          style: _getResponsiveFavoritesTitleStyle(screenWidth),
        ),
        SizedBox(height: AppPaddings.l),
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesError(double screenWidth, MovieProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.myFavorites,
          style: _getResponsiveFavoritesTitleStyle(screenWidth),
        ),
        SizedBox(height: AppPaddings.l),
        Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: AppColors.primary, size: 48),
              SizedBox(height: AppPaddings.m),
              Text(
                'Favoriler yüklenemedi',
                style: AppTextStyles.bodyMediumBold,
              ),
              SizedBox(height: AppPaddings.s),
              ElevatedButton(
                onPressed: _loadFavorites,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesEmpty(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.myFavorites,
          style: _getResponsiveFavoritesTitleStyle(screenWidth),
        ),
        SizedBox(height: AppPaddings.l),
        Center(
          child: Column(
            children: [
              Icon(Icons.favorite_border, color: AppColors.gray60, size: 64),
              SizedBox(height: AppPaddings.m),
              Text(
                'Henüz favori film eklemediniz',
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.gray60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _getResponsiveHeaderStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading3;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading4;
    } else {
      return AppTextStyles.heading5;
    }
  }

  TextStyle _getResponsiveLimitedOfferStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumBold;
    } else {
      return AppTextStyles.bodySmallBold;
    }
  }

  TextStyle _getResponsiveNameStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading5;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading6;
    } else {
      return AppTextStyles.bodyXLargeBold;
    }
  }

  TextStyle _getResponsiveIdStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.gray60);
    } else {
      return AppTextStyles.bodySmallRegular.copyWith(color: AppColors.gray60);
    }
  }

  TextStyle _getResponsiveAddPhotoStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumMedium;
    } else {
      return AppTextStyles.bodySmallMedium;
    }
  }

  TextStyle _getResponsiveFavoritesTitleStyle(double screenWidth) {
    if (screenWidth >= 1200) {
      return AppTextStyles.heading4;
    } else if (screenWidth >= 768) {
      return AppTextStyles.heading5;
    } else {
      return AppTextStyles.heading6;
    }
  }
}
