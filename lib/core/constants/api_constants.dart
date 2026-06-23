class ApiConstants {
  // Use localhost in dev, 10.0.2.2 for Android emulator, or your local Wi-Fi IP (192.168.1.100) for physical devices
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String login = '$baseUrl/usuarios/login/';
  static const String profile = '$baseUrl/usuarios/perfil/';
  
  static const String actividades = '$baseUrl/actividad/actividades/';
  static const String actividadTareas = '$baseUrl/actividad/actividad-tareas/';
  static const String incidencias = '$baseUrl/actividad/incidencias/';
  static const String laboratorios = '$baseUrl/laboratorio/laboratorios/';
  static const String reservas = '$baseUrl/reserva/reservas/';
  static const String docentes = '$baseUrl/reserva/docentes/';
}

