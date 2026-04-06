import '../network/api_client.dart';
import '../network/api_response.dart';
import '../constants/api_constants.dart';

class LaboratorioApi {
  final ApiClient _client;

  LaboratorioApi(this._client);

  Future<ApiResponse> getActividades() {
    return _client.get(ApiConstants.actividades);
  }

  Future<ApiResponse> getActividadDetail(int id) {
    return _client.get('${ApiConstants.actividades}$id/');
  }

  Future<ApiResponse> updateActividadTarea(int id, Map<String, dynamic> data) {
    return _client.patch('${ApiConstants.actividadTareas}$id/', body: data);
  }
}
