import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

enum MovieState { initial, loading, loaded, error, loadingMore }

class MovieProvider extends ChangeNotifier {
  final MovieRepository _repository;

  MovieProvider({MovieRepository? repository})
    : _repository = repository ?? MovieRepositoryImpl();

  // State
  MovieState _state = MovieState.initial;
  List<Movie> _movies = [];
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMorePages = true;

  // Favorites State
  List<Movie> _favoriteMovies = [];
  bool _isLoadingFavorites = false;
  String? _favoritesErrorMessage;

  // Getters
  MovieState get state => _state;
  List<Movie> get movies => _movies;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasMorePages => _hasMorePages;
  bool get isLoading => _state == MovieState.loading;
  bool get isLoadingMore => _state == MovieState.loadingMore;
  bool get hasError => _state == MovieState.error;
  bool get hasMovies => _movies.isNotEmpty;

  // Favorites Getters
  List<Movie> get favoriteMovies => _favoriteMovies;
  bool get isLoadingFavorites => _isLoadingFavorites;
  String? get favoritesErrorMessage => _favoritesErrorMessage;
  bool get hasFavorites => _favoriteMovies.isNotEmpty;

  // Auth token
  void setAuthToken(String token) {
    _repository.setAuthToken(token);
  }

  // First movie load
  Future<void> loadMovies() async {
    if (_state == MovieState.loading) return;

    _setState(MovieState.loading);
    _errorMessage = null;

    try {
      final movies = await _repository.getMoviesWithFavorites(page: 1);

      _movies = movies;
      _currentPage = 1;
      _hasMorePages = movies.isNotEmpty;
      _setState(MovieState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(MovieState.error);
    }
  }

  // Load more movies (pagination)
  Future<void> loadMoreMovies() async {
    if (!_hasMorePages || _state == MovieState.loadingMore) return;

    _setState(MovieState.loadingMore);

    try {
      final nextPage = _currentPage + 1;
      final newMovies = await _repository.getMoviesWithFavorites(
        page: nextPage,
      );

      if (newMovies.isNotEmpty) {
        _movies.addAll(newMovies);
        _currentPage = nextPage;
        _hasMorePages = newMovies.isNotEmpty;
      } else {
        _hasMorePages = false;
      }

      _setState(MovieState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(MovieState.error);
    }
  }

  // Load favorite movies for profile page
  Future<void> loadFavoriteMovies() async {
    if (_isLoadingFavorites) return;

    _isLoadingFavorites = true;
    _favoritesErrorMessage = null;
    notifyListeners();

    try {
      final favorites = await _repository.getFavoriteMovies();
      _favoriteMovies = favorites;
      _isLoadingFavorites = false;
      notifyListeners();
    } catch (e) {
      _favoritesErrorMessage = e.toString();
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  // Toggle favorite status
  Future<void> toggleMovieFavorite(String movieId) async {
    // Update in main movies list
    final movieIndex = _movies.indexWhere((movie) => movie.id == movieId);
    if (movieIndex != -1) {
      final originalValue = _movies[movieIndex].isFavorite;
      _movies[movieIndex].isFavorite = !originalValue;
      notifyListeners();

      try {
        final success = await _repository.toggleFavorite(movieId);

        if (!success) {
          _movies[movieIndex].isFavorite = originalValue;
          notifyListeners();
        } else {
          // Always refresh favorites after successful toggle
          await loadFavoriteMovies();
        }
      } catch (e) {
        _movies[movieIndex].isFavorite = originalValue;
        notifyListeners();
        _errorMessage = 'Favori durumu değiştirilemedi: $e';
      }
    }
  }

  // Refresh movies
  Future<void> refresh() async {
    _movies.clear();
    _currentPage = 1;
    _hasMorePages = true;
    await loadMovies();
  }

  // Get movie by ID
  Movie? getMovieById(String id) {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get favorite movies from current list (not from API)
  List<Movie> get localFavoriteMovies {
    return _movies.where((movie) => movie.isFavorite).toList();
  }

  void _setState(MovieState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == MovieState.error) {
      _setState(_movies.isEmpty ? MovieState.initial : MovieState.loaded);
    }
  }

  void clearFavoritesError() {
    _favoritesErrorMessage = null;
    notifyListeners();
  }
}
