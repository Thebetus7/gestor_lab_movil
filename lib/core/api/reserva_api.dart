import '../network/api_client.dart';
import '../network/api_response.dart';
import '../constants/api_constants.dart';

class ReservaApi {
  final ApiClient _client;

  ReservaApi(this._client);

  Future<ApiResponse> getReservas({Map<String, String>? queryParams}) {
    if (queryParams != null && queryParams.isNotEmpty) {
      final uri = Uri.parse(ApiConstants.reservas).replace(queryParameters: queryParams);
      return _client.get(uri.toString());
    }
    return _client.get(ApiConstants.reservas);
  }

  Future<ApiResponse> getEstadoEspacios(String fecha) {
    return _client.get('${ApiConstants.reservas}estado-espacios/?fecha=$fecha');
  }
}
