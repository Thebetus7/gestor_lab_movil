import '../models/reserva_model.dart';
import '../services/reserva_service.dart';

class ReservaRepository {
  final ReservaService _service = ReservaService();

  Future<List<ReservaModel>> getReservas({String? fecha}) async {
    try {
      return await _service.getReservas(fecha: fecha);
    } catch (e) {
      rethrow;
    }
  }
}
