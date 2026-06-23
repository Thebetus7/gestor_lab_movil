import 'package:flutter/material.dart';
import '../../data/models/reserva_model.dart';
import '../../data/repositories/reserva_repository.dart';

class ReservaProvider extends ChangeNotifier {
  final ReservaRepository _repository = ReservaRepository();

  List<ReservaModel> _reservas = [];
  bool _isLoading = false;
  String? _error;

  List<ReservaModel> get reservas => _reservas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReservas(DateTime fecha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final yStr = fecha.year;
      final mStr = String.fromCharCodes([
        ...fecha.month.toString().padLeft(2, '0').runes
      ]);
      final dStr = String.fromCharCodes([
        ...fecha.day.toString().padLeft(2, '0').runes
      ]);
      final fechaStr = '$yStr-$mStr-$dStr';

      _reservas = await _repository.getReservas(fecha: fechaStr);
    } catch (e) {
      _error = e.toString().replaceAll('Exception:', '').trim();
      _reservas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
