import 'dart:convert';
import 'dart:io';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:jr_case_boilerplate/features/auth/models/login_request_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/register_request_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/auth_response_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/user_model.dart';
import 'package:jr_case_boilerplate/features/auth/models/upload_photo_response_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiService.loginEndpoint,
        request.toJson(),
      );

      print('Login Response Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponseModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = _parseApiError(errorData);
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Register
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiService.registerEndpoint,
        request.toJson(),
      );

      print('Register Response Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponseModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = _parseApiError(errorData);
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Get Profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiService.get(ApiService.profileEndpoint);

      print('Profile Response Code: ${response.statusCode}');
      print('Profile Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data'] ?? data;
        return UserModel.fromJson(userData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = _parseApiError(errorData);
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }

  // Upload Photo
  Future<UploadPhotoResponseModel> uploadPhoto(File file) async {
    try {
      final streamedResponse = await _apiService.uploadFile(
        ApiService.uploadPhotoEndpoint,
        file,
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('Upload Photo Response Code: ${response.statusCode}');
      print('Upload Photo Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UploadPhotoResponseModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = _parseApiError(errorData);
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  String _parseApiError(Map<String, dynamic> errorData) {
    try {
      final response = errorData['response'];
      if (response != null) {
        final message = response['message'] ?? '';

        switch (message) {
          case 'PASSWORD_TOO_SHORT':
            return 'Şifre çok kısa (minimum 6 karakter)';
          case 'INVALID_EMAIL':
            return 'Geçersiz e-posta adresi';
          case 'EMAIL_ALREADY_EXISTS':
            return 'Bu e-posta adresi zaten kullanılıyor';
          case 'INVALID_CREDENTIALS':
            return 'E-posta veya şifre hatalı';
          case 'USER_NOT_FOUND':
            return 'Kullanıcı bulunamadı';
          case 'INVALID_TOKEN':
            return 'Oturum süresi dolmuş';
          case 'INVALID_FILE_FORMAT':
            return 'Geçersiz dosya formatı';
          case 'FILE_TOO_LARGE':
            return 'Dosya boyutu çok büyük';
          default:
            return message.isNotEmpty ? message : 'Bilinmeyen hata';
        }
      }

      // Fallback to generic error
      return 'Bir hata oluştu';
    } catch (e) {
      return 'Bir hata oluştu';
    }
  }
}
