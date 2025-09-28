import 'dart:io';
import 'package:jr_case_boilerplate/core/services/storage_service.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/models/login_request_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/register_request_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/auth_response_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService.instance;

  // Login
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final request = LoginRequestModel(email: email, password: password);
      final response = await _authService.login(request);

      print('Login Repository - Response: ${response.token}'); // DEBUG
      print('Login Repository - User: ${response.user.name}'); // DEBUG

      // Store token and user data using StorageService

      await _storeAuthData(response);

      return response;
    } catch (e) {
      print('Login Repository Error: $e'); // DEBUG
      rethrow;
    }
  }

  // Register
  Future<AuthResponseModel> register(
    String email,
    String name,
    String password,
  ) async {
    try {
      final request = RegisterRequestModel(
        email: email,
        name: name,
        password: password,
      );

      print('Register Repository - Request: ${request.toJson()}'); // DEBUG

      final response = await _authService.register(request);

      print('Register Repository - Response Token: ${response.token}'); // DEBUG
      print('Register Repository - User Name: ${response.user.name}'); // DEBUG
      print('Register Repository - User ID: ${response.user.id}'); // DEBUG

      // Store token and user data using StorageService
      await _storeAuthData(response);

      print('Register Repository - Auth data stored successfully'); // DEBUG

      return response;
    } catch (e) {
      print('Register Repository Error: $e'); // DEBUG
      rethrow;
    }
  }

  // Get Profile
  Future<UserModel> getProfile() async {
    try {
      final user = await _authService.getProfile();

      await _storeUserData(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Upload Photo
  Future<String> uploadPhoto(File file) async {
    try {
      final response = await _authService.uploadPhoto(file);

      // Update user data with new photo URL
      final currentUser = await getStoredUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(photoUrl: response.photoUrl);
        await _storeUserData(updatedUser);
      }

      return response.photoUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Logout - using StorageService
  Future<void> logout() async {
    try {
      await _storageService.clearAuthData();
      print('Logout successful - all auth data cleared'); // DEBUG
    } catch (e) {
      print('Logout error: $e'); // DEBUG
      throw Exception('Logout error: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      return _storageService.isLoggedIn();
    } catch (e) {
      print('isLoggedIn error: $e'); // DEBUG
      return false;
    }
  }

  // Get stored token - using StorageService
  Future<String?> getStoredToken() async {
    try {
      return _storageService.getAuthToken();
    } catch (e) {
      print('getStoredToken error: $e'); // DEBUG
      return null;
    }
  }

  // Get stored user - using StorageService
  Future<UserModel?> getStoredUser() async {
    try {
      final userData = _storageService.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('getStoredUser error: $e'); // DEBUG
      return null;
    }
  }

  // Private helper methods using StorageService
  Future<void> _storeAuthData(AuthResponseModel response) async {
    try {
      // Store auth token
      await _storageService.setAuthToken(response.token);

      // Store user data
      await _storageService.setUserData(response.user.toJson());

      print(
        'Auth data stored - Token: ${response.token.substring(0, 20)}...',
      ); // DEBUG
      print('Auth data stored - User: ${response.user.name}'); // DEBUG
    } catch (e) {
      print('Store auth data error: $e'); // DEBUG
      throw Exception('Failed to store auth data: $e');
    }
  }

  Future<void> _storeUserData(UserModel user) async {
    try {
      await _storageService.setUserData(user.toJson());
      print('User data updated: ${user.name}'); // DEBUG
    } catch (e) {
      print('Store user data error: $e'); // DEBUG
      throw Exception('Failed to store user data: $e');
    }
  }

  // Check if specific data exists
  bool hasAuthToken() {
    return _storageService.containsKey('auth_token');
  }

  bool hasUserData() {
    return _storageService.containsKey('user_data');
  }

  // Get user name
  String? getUserName() {
    final userData = _storageService.getUserData();
    return userData?['name'];
  }

  // Get user email
  String? getUserEmail() {
    final userData = _storageService.getUserData();
    return userData?['email'];
  }

  // Update specific user field
  Future<void> updateUserField(String field, dynamic value) async {
    try {
      final userData = _storageService.getUserData();
      if (userData != null) {
        userData[field] = value;
        await _storageService.setUserData(userData);
        print('User field updated: $field = $value'); // DEBUG
      }
    } catch (e) {
      print('Update user field error: $e'); // DEBUG
      throw Exception('Failed to update user field: $e');
    }
  }

  // Refresh auth token
  Future<void> refreshToken() async {
    try {
      throw UnimplementedError('Refresh token not implemented yet');
    } catch (e) {
      rethrow;
    }
  }
}
