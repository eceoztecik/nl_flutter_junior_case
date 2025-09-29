import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';

class ProfileMovieCard extends StatelessWidget {
  final String title;
  final String description;
  final String? posterUrl;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const ProfileMovieCard({
    super.key,
    required this.title,
    required this.description,
    this.posterUrl,
    this.onTap,
    this.onRemove,
  });

  Widget _buildPosterImage(BuildContext context) {
    if (posterUrl == null || posterUrl!.isEmpty) {
      return _buildPlaceholder(context);
    }

    String cleanUrl = posterUrl!.trim();

    if (cleanUrl.startsWith("http://")) {
      cleanUrl = cleanUrl.replaceFirst("http://", "https://");
    }

    if (cleanUrl.contains("ia.media-imdb.com")) {
      cleanUrl = cleanUrl.replaceFirst(
        "ia.media-imdb.com",
        "m.media-amazon.com",
      );
    }

    return Image.network(
      cleanUrl,
      fit: BoxFit.cover,
      headers: const {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Referer': 'https://www.imdb.com/',
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder(context);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.gray30,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.gray30,
      child: Center(
        child: Icon(
          Icons.movie,
          color: AppColors.gray60,
          size: screenWidth >= 768 ? 40 : 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster with Remove Button
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      screenWidth >= 768 ? 16 : 12,
                    ),
                    color: AppColors.gray20,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      screenWidth >= 768 ? 16 : 12,
                    ),
                    child: _buildPosterImage(context),
                  ),
                ),

                // Remove from favorites button
                if (onRemove != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.gray20,
                            title: Text(
                              'Favorilerden Çıkar',
                              style: AppTextStyles.bodyLargeBold.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            content: Text(
                              'Bu filmi favorilerinizden çıkarmak istediğinize emin misiniz?',
                              style: AppTextStyles.bodyMediumRegular.copyWith(
                                color: AppColors.gray60,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'İptal',
                                  style: AppTextStyles.bodyMediumMedium
                                      .copyWith(color: AppColors.gray60),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onRemove?.call();
                                },
                                child: Text(
                                  'Çıkar',
                                  style: AppTextStyles.bodyMediumBold.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: AppPaddings.s),

          // Movie Title
          Text(
            title,
            style: _getResponsiveMovieTitleStyle(screenWidth),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppPaddings.xs),

          // Description
          Text(
            description.isNotEmpty ? description : 'Açıklama yok',
            style: _getResponsiveDescriptionStyle(screenWidth),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  TextStyle _getResponsiveMovieTitleStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyLargeBold;
    } else {
      return AppTextStyles.bodyMediumBold;
    }
  }

  TextStyle _getResponsiveDescriptionStyle(double screenWidth) {
    if (screenWidth >= 768) {
      return AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.gray60);
    } else {
      return AppTextStyles.bodySmallRegular.copyWith(color: AppColors.gray60);
    }
  }
}
