import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/extensions/app/app_padding_ext.dart';

class HomeMovieListItem extends StatefulWidget {
  final String? posterUrl;
  final String title;
  final String? description;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const HomeMovieListItem({
    super.key,
    this.posterUrl,
    required this.title,
    this.description,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<HomeMovieListItem> createState() => _HomeMovieListItemState();
}

class _HomeMovieListItemState extends State<HomeMovieListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isFavorite;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    // Animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onFavoriteToggle?.call();
  }

  Widget _buildPosterImage() {
    if (widget.posterUrl == null || widget.posterUrl!.isEmpty) {
      return Image.asset('assets/images/Image.png', fit: BoxFit.cover);
    }

    String cleanUrl = widget.posterUrl!.trim();

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
        return Image.asset('assets/images/Image.png', fit: BoxFit.cover);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[900],
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(child: _buildPosterImage()),

          // Dark overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Main content - Bottom positioned
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heart button with animation
                  Padding(
                    padding: EdgeInsets.only(
                      right: AppPaddingsResponsive.getScreenPadding(
                        screenWidth,
                      ).right,
                      bottom: AppPaddings.m,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _toggleLike,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: 52,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  _isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isLiked ? Colors.red : Colors.white,
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Movie info section
                  Padding(
                    padding: AppPaddingsResponsive.getScreenPadding(
                      screenWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo and title
                        Row(
                          children: [
                            Container(
                              width: screenWidth >= 768 ? 32 : 28,
                              height: screenWidth >= 768 ? 32 : 28,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth >= 768 ? 20 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppPaddings.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth >= 1200
                                          ? 32
                                          : screenWidth >= 768
                                          ? 28
                                          : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: AppPaddings.xs),
                                  Text(
                                    widget.description?.isNotEmpty == true
                                        ? widget.description!
                                        : 'Açıklama bulunamadı',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: screenWidth >= 1200
                                          ? 18
                                          : screenWidth >= 768
                                          ? 16
                                          : 14,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: AppPaddings.xs),
                                  GestureDetector(
                                    onTap: () {},
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'DevamınıOku',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth >= 1200
                                                  ? 18
                                                  : screenWidth >= 768
                                                  ? 16
                                                  : 14,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: AppPaddingsResponsive.getSectionSpacing(
                            screenWidth,
                          ),
                        ),

                        // Bottom safe area + NavBar space
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
