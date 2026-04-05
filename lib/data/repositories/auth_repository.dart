import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String username, String password) async {
    try {
      await _authService.login(username, password);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await _authService.getProfile();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
