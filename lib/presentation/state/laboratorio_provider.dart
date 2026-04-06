import 'package:flutter/material.dart';
import '../../data/models/actividad_model.dart';
import '../../data/repositories/laboratorio_repository.dart';

class LaboratorioProvider extends ChangeNotifier {
  final LaboratorioRepository _repo = LaboratorioRepository();
  
  List<ActividadModel> _actividades = [];
  bool _isLoading = false;
  String? _error;

  ActividadModel? _currentActividad;

  List<ActividadModel> get actividades => _actividades;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ActividadModel? get currentActividad => _currentActividad;

  Future<void> loadActividades() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _actividades = await _repo.getActividades();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadActividadDetail(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentActividad = await _repo.getActividadDetail(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateTarea(int tareaId, String estado, String observacion) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repo.updateActividadTarea(tareaId, estado, observacion);
      // Recargar el detalle tras la actualización
      if (_currentActividad != null) {
        _currentActividad = await _repo.getActividadDetail(_currentActividad!.id);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
