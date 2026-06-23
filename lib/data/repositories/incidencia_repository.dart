import '../models/incidencia_model.dart';
import '../services/incidencia_service.dart';

class IncidenciaRepository {
  final IncidenciaService _service = IncidenciaService();

  Future<IncidenciaModel> reportarIncidencia(String descripcion, String prioridad, int? idLab, int? idAccesorio) async {
    try {
      return await _service.reportarIncidencia(descripcion, prioridad, idLab, idAccesorio);
    } catch (e) {
      rethrow;
    }
  }
}
