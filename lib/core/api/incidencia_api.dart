import '../network/api_client.dart';
import '../network/api_response.dart';
import '../constants/api_constants.dart';

class IncidenciaApi {
  final ApiClient _client;

  IncidenciaApi(this._client);

  Future<ApiResponse> reportarIncidencia(Map<String, dynamic> data) {
    return _client.post(ApiConstants.incidencias, body: data);
  }
}
