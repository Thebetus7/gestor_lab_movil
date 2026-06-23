import '../../core/api/reserva_api.dart';
import '../../core/network/api_client.dart';
import '../models/reserva_model.dart';

class ReservaService {
  final ReservaApi _reservaApi;

  ReservaService() : _reservaApi = ReservaApi(ApiClient());

  Future<List<ReservaModel>> getReservas({String? fecha}) async {
    final Map<String, String> queryParams = {};
    if (fecha != null) {
      queryParams['fecha'] = fecha;
    }

    final response = await _reservaApi.getReservas(queryParams: queryParams.isNotEmpty ? queryParams : null);
    final List<dynamic> data = response.data as List<dynamic>;
    
    return data.map((json) => ReservaModel.fromJson(json)).toList();
  }
}
