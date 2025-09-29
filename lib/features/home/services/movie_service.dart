import 'dart:convert';
import '../models/movie_list_response_model.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';

class MovieService {
  final ApiService _apiService = ApiService();

  void setAuthToken(String token) async {
    await _apiService.storeToken(token);
  }

  // GET /movie/list - Paginated movie list
  Future<MovieListResponse> getMovies({int page = 1}) async {
    try {
      final response = await _apiService.get('movie/list?page=$page');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final movieResponse = MovieListResponse.fromJson(jsonData);
        return movieResponse;
      } else if (response.statusCode == 401) {
        throw MovieServiceException('Unauthorized - Please login');
      } else {
        throw MovieServiceException(
          'Failed to load movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
      if (e is MovieServiceException) rethrow;
      throw MovieServiceException('Network error: $e');
    }
  }

  // GET /movie/favorites - User's favorite movies
  Future<FavoriteMoviesResponse> getFavoriteMovies() async {
    try {
      final response = await _apiService.get('movie/favorites');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final favoritesResponse = FavoriteMoviesResponse.fromJson(jsonData);
        return favoritesResponse;
      } else if (response.statusCode == 401) {
        throw MovieServiceException('Unauthorized - Please login');
      } else {
        throw MovieServiceException(
          'Failed to load favorite movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(' Error Stack: ${StackTrace.current}');
      if (e is MovieServiceException) rethrow;
      throw MovieServiceException('Network error: $e');
    }
  }

  // POST /movie/favorite/{favoriteId} - Toggle favorite status
  Future<FavoriteResponse> toggleFavorite(String movieId) async {
    try {
      final response = await _apiService.postWithAuth(
        'movie/favorite/$movieId',
        {},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final favoriteResponse = FavoriteResponse.fromJson(jsonData);
        return favoriteResponse;
      } else if (response.statusCode == 401) {
        throw MovieServiceException('Unauthorized - Please login');
      } else if (response.statusCode == 404) {
        throw MovieServiceException('Movie not found');
      } else {
        throw MovieServiceException(
          'Failed to toggle favorite: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(' Error: $e');
      if (e is MovieServiceException) rethrow;
      throw MovieServiceException('Network error: $e');
    }
  }
}

class MovieServiceException implements Exception {
  final String message;
  MovieServiceException(this.message);

  @override
  String toString() => 'MovieServiceException: $message';
}
