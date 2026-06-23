class AccesorioModel {
  final int id;
  final String nombre;

  AccesorioModel({
    required this.id,
    required this.nombre,
  });

  factory AccesorioModel.fromJson(Map<String, dynamic> json) {
    return AccesorioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? 'Sin nombre',
    );
  }
}
