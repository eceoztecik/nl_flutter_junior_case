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

  // Auth token
  void setAuthToken(String token) {
    _repository.setAuthToken(token);
  }

  // First movie
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

  Future<void> toggleMovieFavorite(String movieId) async {
    final movieIndex = _movies.indexWhere((movie) => movie.id == movieId);
    if (movieIndex == -1) return;

    // Optimistic update - UI
    final originalValue = _movies[movieIndex].isFavorite;
    _movies[movieIndex].isFavorite = !originalValue;
    notifyListeners();

    try {
      final success = await _repository.toggleFavorite(movieId);

      if (!success) {
        _movies[movieIndex].isFavorite = originalValue;
        notifyListeners();
      }
    } catch (e) {
      _movies[movieIndex].isFavorite = originalValue;
      notifyListeners();

      _errorMessage = 'Favori durumu değiştirilemedi: $e';
    }
  }

  Future<void> refresh() async {
    _movies.clear();
    _currentPage = 1;
    _hasMorePages = true;
    await loadMovies();
  }

  Movie? getMovieById(String id) {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Favorite movies
  List<Movie> get favoriteMovies {
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
}
