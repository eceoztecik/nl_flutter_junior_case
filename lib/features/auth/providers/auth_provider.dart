import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:jr_case_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:jr_case_boilerplate/features/auth/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  // State variables
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkInitialAuthStatus();
  }

  // Check if user is already logged in
  Future<void> _checkInitialAuthStatus() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      _setLoading(true);

      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final storedUser = await _authRepository.getStoredUser();
        if (storedUser != null) {
          _user = storedUser;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _setError('Failed to check auth status: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authRepository.login(email, password);

      _user = response.user;
      _status = AuthStatus.authenticated;

      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _setError(_parseErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register method
  Future<bool> register(String email, String name, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authRepository.register(email, name, password);

      _user = response.user;
      _status = AuthStatus.authenticated;

      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _setError(_parseErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get profile method
  Future<bool> getProfile() async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.getProfile();
      _user = user;

      notifyListeners();
      return true;
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        await logout();
      } else {
        _setError(_parseErrorMessage(e.toString()));
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Upload photo method
  Future<bool> uploadPhoto(File file) async {
    try {
      _setLoading(true);
      _clearError();

      final photoUrl = await _authRepository.uploadPhoto(file);

      // Update user with new photo URL
      if (_user != null) {
        _user = _user!.copyWith(photoUrl: photoUrl);
        notifyListeners();
      }

      return true;
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        await logout();
      } else {
        _setError(_parseErrorMessage(e.toString()));
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authRepository.logout();

      _user = null;
      _status = AuthStatus.unauthenticated;
      _clearError();

      notifyListeners();
    } catch (e) {
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user info (for profile updates)
  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _parseErrorMessage(String error) {
    // Parse common error messages
    if (error.contains('Invalid credentials')) {
      return 'E-posta veya şifre hatalı';
    } else if (error.contains('email already exists')) {
      return 'Bu e-posta adresi zaten kullanılıyor';
    } else if (error.contains('Invalid input')) {
      return 'Geçersiz bilgi girişi';
    } else if (error.contains('Unauthorized')) {
      return 'Oturum süreniz dolmuş, lütfen tekrar giriş yapın';
    } else if (error.contains('Network error')) {
      return 'İnternet bağlantınızı kontrol edin';
    } else if (error.contains('Invalid file format')) {
      return 'Geçersiz dosya formatı';
    } else {
      return 'Bir hata oluştu, lütfen tekrar deneyin';
    }
  }

  // Clear error message manually
  void clearError() {
    _clearError();
  }

  // Refresh auth status
  Future<void> refreshAuthStatus() async {
    await _checkInitialAuthStatus();
  }
}
