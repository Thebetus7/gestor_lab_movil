class ApiConstants {
  // Use localhost in dev, but for Android emulator use 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String login = '$baseUrl/usuarios/login/';
  static const String profile = '$baseUrl/usuarios/perfil/';
  
  static const String actividades = '$baseUrl/laboratorio/actividades/';
  static const String actividadTareas = '$baseUrl/laboratorio/actividad-tareas/';
}
