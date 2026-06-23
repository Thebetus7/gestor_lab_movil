class ReservaModel {
  final int id;
  final int laboratorio;
  final String laboratorioNombre;
  final String docenteNombre;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final String? motivo;
  final String? auxiliarUsername;

  ReservaModel({
    required this.id,
    required this.laboratorio,
    required this.laboratorioNombre,
    required this.docenteNombre,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    this.motivo,
    this.auxiliarUsername,
  });

  factory ReservaModel.fromJson(Map<String, dynamic> json) {
    return ReservaModel(
      id: json['id'] ?? 0,
      laboratorio: json['laboratorio'] ?? 0,
      laboratorioNombre: json['laboratorio_nombre'] ?? '',
      docenteNombre: json['docente_nombre'] ?? '',
      fecha: json['fecha'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      motivo: json['motivo'],
      auxiliarUsername: json['auxiliar_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'laboratorio': laboratorio,
      'laboratorio_nombre': laboratorioNombre,
      'docente_nombre': docenteNombre,
      'fecha': fecha,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'motivo': motivo,
      'auxiliar_username': auxiliarUsername,
    };
  }
}
