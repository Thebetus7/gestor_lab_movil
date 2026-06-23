class ActividadTareaModel {
  final int id;
  final int? idActiv;
  final int? idTarea;
  final String tareaDescripcion;
  final String? observacion;
  final String? estado;

  ActividadTareaModel({
    required this.id,
    this.idActiv,
    this.idTarea,
    required this.tareaDescripcion,
    this.observacion,
    this.estado,
  });

  factory ActividadTareaModel.fromJson(Map<String, dynamic> json) {
    return ActividadTareaModel(
      id: json['id'] as int,
      idActiv: json['id_activ'] as int?,
      idTarea: json['id_tarea'] as int?,
      tareaDescripcion: json['tarea_descripcion'] as String? ?? 'Sin descripción',
      observacion: json['observacion'] as String?,
      estado: json['estado'] as String?,
    );
  }
}

class ActividadLaboratorioModel {
  final int id;
  final String nombre;

  ActividadLaboratorioModel({required this.id, required this.nombre});

  factory ActividadLaboratorioModel.fromJson(Map<String, dynamic> json) {
    return ActividadLaboratorioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? 'Sin nombre',
    );
  }
}

class ActividadModel {
  final int id;
  final String? descripcion;
  final bool isActive;
  final List<ActividadTareaModel>? actividadTareas;
  final List<ActividadLaboratorioModel>? laboratorios;

  ActividadModel({
    required this.id,
    this.descripcion,
    required this.isActive,
    this.actividadTareas,
    this.laboratorios,
  });

  factory ActividadModel.fromJson(Map<String, dynamic> json) {
    var list = json['actividad_tareas'] as List?;
    List<ActividadTareaModel>? tareasList = list?.map((i) => ActividadTareaModel.fromJson(i)).toList();

    var labsListRaw = json['laboratorios'] as List?;
    List<ActividadLaboratorioModel>? labsList = labsListRaw?.map((i) => ActividadLaboratorioModel.fromJson(i)).toList();

    return ActividadModel(
      id: json['id'] as int,
      descripcion: json['descripcion'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      actividadTareas: tareasList,
      laboratorios: labsList,
    );
  }
}
