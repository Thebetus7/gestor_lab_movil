import '../models/actividad_model.dart';
import '../services/laboratorio_service.dart';

class LaboratorioRepository {
  final LaboratorioService _service = LaboratorioService();

  Future<List<ActividadModel>> getActividades() async {
    return await _service.getActividades();
  }

  Future<ActividadModel> getActividadDetail(int id) async {
    return await _service.getActividadDetail(id);
  }

  Future<void> updateActividadTarea(int id, String estado, String observacion) async {
    await _service.updateActividadTarea(id, estado, observacion);
  }
}
