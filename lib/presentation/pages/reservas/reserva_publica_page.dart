import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/reserva_provider.dart';
import '../../../data/models/reserva_model.dart';

class ReservaPublicaPage extends StatefulWidget {
  const ReservaPublicaPage({super.key});

  @override
  State<ReservaPublicaPage> createState() => _ReservaPublicaPageState();
}

class _ReservaPublicaPageState extends State<ReservaPublicaPage> {
  DateTime _fechaSeleccionada = DateTime.now();
  String _filtroLaboratorio = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar reservas del día actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservaProvider>().loadReservas(_fechaSeleccionada);
    });
  }

  // Helpers de internacionalización estáticos para evitar dependencias de intl
  String _getDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'LUN';
      case DateTime.tuesday: return 'MAR';
      case DateTime.wednesday: return 'MIÉ';
      case DateTime.thursday: return 'JUE';
      case DateTime.friday: return 'VIE';
      case DateTime.saturday: return 'SÁB';
      case DateTime.sunday: return 'DOM';
      default: return '';
    }
  }

  String _getNombreMes(int month) {
    switch (month) {
      case 1: return 'Enero';
      case 2: return 'Febrero';
      case 3: return 'Marzo';
      case 4: return 'Abril';
      case 5: return 'Mayo';
      case 6: return 'Junio';
      case 7: return 'Julio';
      case 8: return 'Agosto';
      case 9: return 'Septiembre';
      case 10: return 'Octubre';
      case 11: return 'Noviembre';
      case 12: return 'Diciembre';
      default: return '';
    }
  }

  // Generar lista de los próximos 14 días para el selector horizontal
  List<DateTime> _getListaDias() {
    final dias = <DateTime>[];
    final hoy = DateTime.now();
    for (int i = 0; i < 14; i++) {
      dias.add(hoy.add(Duration(days: i)));
    }
    return dias;
  }

  void _seleccionarFecha(DateTime fecha) {
    setState(() {
      _fechaSeleccionada = fecha;
      _filtroLaboratorio = ''; // Resetear filtro al cambiar fecha
    });
    context.read<ReservaProvider>().loadReservas(fecha);
  }

  Future<void> _abrirDatePicker() async {
    final DateTime? seleccionado = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (seleccionado != null) {
      _seleccionarFecha(seleccionado);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservaProvider>(context);
    final diasTimeline = _getListaDias();

    // Obtener nombres de laboratorios únicos para el filtro de las reservas cargadas
    final laboratoriosUnicos = provider.reservas
        .map((r) => r.laboratorioNombre)
        .where((nombre) => nombre.isNotEmpty)
        .toSet()
        .toList();

    // Filtrar localmente
    final List<ReservaModel> reservasFiltradas = provider.reservas.where((r) {
      if (_filtroLaboratorio.isEmpty) return true;
      return r.laboratorioNombre == _filtroLaboratorio;
    }).toList();

    // Comprobar si la fecha seleccionada está dentro de los 14 días mostrados en la barra
    bool estaEnTimeline = false;
    for (var d in diasTimeline) {
      if (d.year == _fechaSeleccionada.year &&
          d.month == _fechaSeleccionada.month &&
          d.day == _fechaSeleccionada.day) {
        estaEnTimeline = true;
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'RESERVAS DIARIAS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black),
            onPressed: _abrirDatePicker,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Divisor superior
          Container(height: 1, color: Colors.black26),

          // Selector de fecha horizontal (Date Timeline)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: diasTimeline.length,
              itemBuilder: (context, index) {
                final dia = diasTimeline[index];
                final esMismoDia = dia.year == _fechaSeleccionada.year &&
                    dia.month == _fechaSeleccionada.month &&
                    dia.day == _fechaSeleccionada.day;

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () => _seleccionarFecha(dia),
                    child: Container(
                      width: 55,
                      decoration: BoxDecoration(
                        color: esMismoDia ? Colors.black : Colors.white,
                        border: Border.all(
                          color: esMismoDia ? Colors.black : Colors.black12,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDiaSemana(dia.weekday),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: esMismoDia ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dia.day.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: esMismoDia ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Si seleccionó una fecha externa al timeline, mostrar indicador
          if (!estaEnTimeline)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fecha seleccionada: ${_fechaSeleccionada.day} de ${_getNombreMes(_fechaSeleccionada.month)} de ${_fechaSeleccionada.year}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => _seleccionarFecha(DateTime.now()),
                      child: const Text(
                        'VOLVER A HOY',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '${_getNombreMes(_fechaSeleccionada.month).toUpperCase()} ${_fechaSeleccionada.year}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
            ),

          Container(height: 1, color: Colors.black12),

          // Selector de filtro de laboratorios (Pills de filtro)
          if (laboratoriosUnicos.isNotEmpty)
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: laboratoriosUnicos.length + 1,
                itemBuilder: (context, index) {
                  final esTodos = index == 0;
                  final labNombre = esTodos ? '' : laboratoriosUnicos[index - 1];
                  final esSeleccionado = (esTodos && _filtroLaboratorio.isEmpty) ||
                      (_filtroLaboratorio == labNombre);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        esTodos ? 'Todos los laboratorios' : labNombre,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: esSeleccionado ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: esSeleccionado,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filtroLaboratorio = labNombre;
                          });
                        }
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Colors.black12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                },
              ),
            ),

          if (laboratoriosUnicos.isNotEmpty)
            Container(height: 1, color: Colors.black12),

          // Listado de Reservas
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : provider.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.black),
                              const SizedBox(height: 16),
                              Text(
                                provider.error!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                ),
                                onPressed: () => _seleccionarFecha(_fechaSeleccionada),
                                child: const Text('REINTENTAR', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : reservasFiltradas.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 64, color: Colors.black26),
                                  const SizedBox(height: 16),
                                  Text(
                                    _filtroLaboratorio.isNotEmpty
                                        ? 'No hay reservas para $_filtroLaboratorio en esta fecha.'
                                        : 'Sin reservas agendadas para esta fecha.',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: reservasFiltradas.length,
                            itemBuilder: (context, index) {
                              final res = reservasFiltradas[index];
                              final horaInicioStr = res.horaInicio.substring(0, 5);
                              final horaFinStr = res.horaFin.substring(0, 5);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.5),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Cabecera de la Reserva (Laboratorio y Horario)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      color: Colors.black12,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              res.laboratorioNombre.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              '🕒 $horaInicioStr - $horaFinStr',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Detalles de la Reserva
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Docente: ',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  res.docenteNombre,
                                                  style: const TextStyle(fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (res.motivo != null && res.motivo!.trim().isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Motivo: ',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            Text(
                                              res.motivo!,
                                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Registrado por: ${res.auxiliarUsername ?? "Sistema"}',
                                                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
