import '../models/movie_model.dart';
import '../models/movie_list_response_model.dart';
import '../services/movie_service.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMoviesWithFavorites({int page = 1});
  Future<MovieListResponse> getMovies({int page = 1});
  Future<List<Movie>> getFavoriteMovies();
  Future<bool> toggleFavorite(String movieId);
  void setAuthToken(String token);
}

class MovieRepositoryImpl implements MovieRepository {
  final MovieService _movieService;

  MovieRepositoryImpl({MovieService? movieService})
    : _movieService = movieService ?? MovieService();

  @override
  void setAuthToken(String token) {
    _movieService.setAuthToken(token);
  }

  @override
  Future<MovieListResponse> getMovies({int page = 1}) async {
    try {
      return await _movieService.getMovies(page: page);
    } catch (e) {
      throw RepositoryException('Failed to get movies: $e');
    }
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    try {
      final response = await _movieService.getFavoriteMovies();
      return response.movies;
    } catch (e) {
      throw RepositoryException('Failed to get favorite movies: $e');
    }
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      final response = await _movieService.toggleFavorite(movieId);
      return response.success;
    } catch (e) {
      throw RepositoryException('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<List<Movie>> getMoviesWithFavorites({int page = 1}) async {
    try {
      final results = await Future.wait([
        _movieService.getMovies(page: page),
        _movieService.getFavoriteMovies(),
      ]);

      final movieListResponse = results[0] as MovieListResponse;
      final favoriteMoviesResponse = results[1] as FavoriteMoviesResponse;

      // Convert your favorite movie IDs to sets
      final favoriteIds = favoriteMoviesResponse.movies
          .map((movie) => movie.id)
          .toSet();

      // Update favorite status in movie list
      for (var movie in movieListResponse.movies) {
        movie.isFavorite = favoriteIds.contains(movie.id);
      }

      return movieListResponse.movies;
    } catch (e) {
      // If favorites cannot be retrieved, return only the movie list
      try {
        final movieListResponse = await _movieService.getMovies(page: page);
        return movieListResponse.movies;
      } catch (e) {
        throw RepositoryException('Failed to get movies with favorites: $e');
      }
    }
  }
}

// Custom exception class for repository errors
class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
