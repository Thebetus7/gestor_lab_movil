class IncidenciaModel {
  final int? id;
  final String descripcion;
  final String prioridad;
  final int? idLab;
  final String? nombreLab;
  final bool resuelto;
  final int? idUser;
  final String? usernameUsuario;
  final int? idAccesorio;
  final String? nombreAccesorio;

  IncidenciaModel({
    this.id,
    required this.descripcion,
    required this.prioridad,
    this.idLab,
    this.nombreLab,
    this.resuelto = false,
    this.idUser,
    this.usernameUsuario,
    this.idAccesorio,
    this.nombreAccesorio,
  });

  factory IncidenciaModel.fromJson(Map<String, dynamic> json) {
    return IncidenciaModel(
      id: json['id'] as int?,
      descripcion: json['descripcion'] as String? ?? '',
      prioridad: json['prioridad'] as String? ?? 'media',
      idLab: json['id_lab'] as int?,
      nombreLab: json['nombre_lab'] as String?,
      resuelto: json['resuelto'] as bool? ?? false,
      idUser: json['id_user'] as int?,
      usernameUsuario: json['username_usuario'] as String?,
      idAccesorio: json['id_accesorio'] as int?,
      nombreAccesorio: json['nombre_accesorio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'descripcion': descripcion,
      'prioridad': prioridad,
      if (idLab != null) 'id_lab': idLab,
      if (idAccesorio != null) 'id_accesorio': idAccesorio,
      'resuelto': resuelto,
    };
  }
}
