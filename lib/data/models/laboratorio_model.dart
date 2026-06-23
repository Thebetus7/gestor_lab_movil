import 'accesorio_model.dart';

class LaboratorioModel {
  final int id;
  final String nombre;
  final String? capacidad;
  final List<AccesorioModel>? accesorios;

  LaboratorioModel({
    required this.id,
    required this.nombre,
    this.capacidad,
    this.accesorios,
  });

  factory LaboratorioModel.fromJson(Map<String, dynamic> json) {
    return LaboratorioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? 'Sin nombre',
      capacidad: json['capacidad'] as String?,
      accesorios: json['accesorios'] != null
          ? (json['accesorios'] as List).map((i) => AccesorioModel.fromJson(i)).toList()
          : null,
    );
  }
}
