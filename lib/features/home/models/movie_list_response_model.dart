import 'movie_model.dart';

class MovieListResponse {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;

  MovieListResponse({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return MovieListResponse(
      movies:
          (data['movies'] as List<dynamic>?)
              ?.map((movieJson) => Movie.fromJson(movieJson))
              .toList() ??
          [],
      totalPages: data['totalPages'] ?? 1,
      currentPage: data['currentPage'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.map((movie) => movie.toJson()).toList(),
      'totalPages': totalPages,
      'currentPage': currentPage,
    };
  }

  bool get hasNextPage => currentPage < totalPages;

  @override
  String toString() {
    return 'MovieListResponse(movies: ${movies.length} items, totalPages: $totalPages, currentPage: $currentPage)';
  }
}

class FavoriteResponse {
  final bool success;
  final String message;

  FavoriteResponse({required this.success, required this.message});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return FavoriteResponse(
      success: data['success'] ?? json['response']?['code'] == 200 ?? false,
      message: data['message'] ?? json['response']?['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  @override
  String toString() {
    return 'FavoriteResponse(success: $success, message: $message)';
  }
}

class FavoriteMoviesResponse {
  final List<Movie> movies;

  FavoriteMoviesResponse({required this.movies});

  factory FavoriteMoviesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final movies =
        (data['movies'] as List<dynamic>?)
            ?.map((movieJson) => Movie.fromJson(movieJson))
            .toList() ??
        [];

    for (var movie in movies) {
      movie.isFavorite = true;
    }

    return FavoriteMoviesResponse(movies: movies);
  }

  Map<String, dynamic> toJson() {
    return {'movies': movies.map((movie) => movie.toJson()).toList()};
  }

  @override
  String toString() {
    return 'FavoriteMoviesResponse(movies: ${movies.length} items)';
  }
}
