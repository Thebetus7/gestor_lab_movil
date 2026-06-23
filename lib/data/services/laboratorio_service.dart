import '../../core/api/laboratorio_api.dart';
import '../../core/network/api_client.dart';
import '../models/actividad_model.dart';
import '../models/laboratorio_model.dart';

class LaboratorioService {
  final LaboratorioApi _laboratorioApi;

  LaboratorioService() : _laboratorioApi = LaboratorioApi(ApiClient());

  Future<List<ActividadModel>> getActividades() async {
    final response = await _laboratorioApi.getActividades();
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ActividadModel.fromJson(json)).toList();
  }

  Future<ActividadModel> getActividadDetail(int id) async {
    final response = await _laboratorioApi.getActividadDetail(id);
    return ActividadModel.fromJson(response.data);
  }

  Future<void> updateActividadTarea(int id, String estado, String observacion) async {
    await _laboratorioApi.updateActividadTarea(id, {
      'estado': estado,
      'observacion': observacion,
    });
  }

  Future<List<LaboratorioModel>> getLaboratorios() async {
    final response = await _laboratorioApi.getLaboratorios();
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => LaboratorioModel.fromJson(json)).toList();
  }
}
