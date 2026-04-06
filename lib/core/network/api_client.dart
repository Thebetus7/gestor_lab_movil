import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_exceptions.dart';
import 'api_response.dart';

class ApiClient {
  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse> get(String url) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(Uri.parse(url), headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Error de red');
    }
  }

  Future<ApiResponse> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await _client
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Error de red');
    }
  }

  Future<ApiResponse> patch(String url, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await _client
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Error de red');
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(success: true, data: body, statusCode: statusCode);
    }
    if (statusCode == 401) throw UnauthorizedException('Sesión expirada');
    throw ApiException('Error ($statusCode)', statusCode: statusCode);
  }
}
