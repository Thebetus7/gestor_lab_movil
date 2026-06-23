import '../../core/api/incidencia_api.dart';
import '../../core/network/api_client.dart';
import '../models/incidencia_model.dart';

class IncidenciaService {
  final IncidenciaApi _api;

  IncidenciaService() : _api = IncidenciaApi(ApiClient());

  Future<IncidenciaModel> reportarIncidencia(String descripcion, String prioridad, int? idLab, int? idAccesorio) async {
    final response = await _api.reportarIncidencia({
      'descripcion': descripcion,
      'prioridad': prioridad,
      if (idLab != null) 'id_lab': idLab,
      if (idAccesorio != null) 'id_accesorio': idAccesorio,
      'resuelto': false,
    });
    
    return IncidenciaModel.fromJson(response.data as Map<String, dynamic>);
  }
}
