import '../network/api_client.dart';
import '../network/api_response.dart';
import '../constants/api_constants.dart';

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<ApiResponse> login(String username, String password) {
    return _client.post(ApiConstants.login, body: {
      'username': username,
      'password': password,
    });
  }

  Future<ApiResponse> getProfile() {
    return _client.get(ApiConstants.profile);
  }
}
