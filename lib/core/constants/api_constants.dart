class ApiConstants {
  // AWS: Docker mapea puerto 80 del servidor → 8000 del contenedor (no uses :8000 desde fuera)
  static const String baseUrl = 'http://18.221.224.13/api';

  static const String login = '$baseUrl/usuarios/login/';
  static const String profile = '$baseUrl/usuarios/perfil/';
  
  static const String actividades = '$baseUrl/actividad/actividades/';
  static const String actividadTareas = '$baseUrl/actividad/actividad-tareas/';
  static const String incidencias = '$baseUrl/actividad/incidencias/';
  static const String laboratorios = '$baseUrl/laboratorio/laboratorios/';
  static const String reservas = '$baseUrl/reserva/reservas/';
  static const String docentes = '$baseUrl/reserva/docentes/';
}

