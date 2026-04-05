import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/auth_api.dart';
import '../../core/network/api_client.dart';

class AuthService {
  final AuthApi _authApi;

  AuthService() : _authApi = AuthApi(ApiClient());

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _authApi.login(username, password);
    final data = response.data as Map<String, dynamic>;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', data['access']);
    await prefs.setString('refresh_token', data['refresh']);

    return data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _authApi.getProfile();
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}
