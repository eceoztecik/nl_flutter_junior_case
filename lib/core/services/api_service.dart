import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://caseapi.servicelabs.tech/';

  static const String loginEndpoint = 'user/login';
  static const String registerEndpoint = 'user/register';
  static const String profileEndpoint = 'user/profile';
  static const String uploadPhotoEndpoint = 'user/upload_photo';

  // Headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _headersWithAuth async {
    final headers = Map<String, String>.from(_headers);
    final token = await _getStoredToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Token operations
  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    try {
      final headers = await _headersWithAuth;
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),

        headers: _headers,
        body: jsonEncode(body),
      );
      print('POST Body: ${jsonEncode(body)}'); // DEBUG
      print('Response: ${response.statusCode} - ${response.body}'); // DEBUG

      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request with auth
  Future<http.Response> postWithAuth(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _headersWithAuth;
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Multipart request for file upload
  Future<http.StreamedResponse> uploadFile(String endpoint, File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );

      // Add auth header
      final token = await _getStoredToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      return await request.send();
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  // Public methods for token management
  Future<void> storeToken(String token) async {
    await _storeToken(token);
  }

  Future<void> removeToken() async {
    await _removeToken();
  }

  Future<String?> getToken() async {
    return await _getStoredToken();
  }
}
