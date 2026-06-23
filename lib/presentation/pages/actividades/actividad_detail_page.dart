import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/laboratorio_provider.dart';

import 'widgets/update_tarea_modal.dart';

class ActividadDetailPage extends StatefulWidget {
  final int actividadId;

  const ActividadDetailPage({super.key, required this.actividadId});

  @override
  State<ActividadDetailPage> createState() => _ActividadDetailPageState();
}

class _ActividadDetailPageState extends State<ActividadDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaboratorioProvider>(context, listen: false).loadActividadDetail(widget.actividadId);
    });
  }

  Color _getColorForEstado(String? estado) {
    if (estado == 'realizado') return Colors.green;
    if (estado == 'problema') return Colors.red;
    return Colors.amber.shade700;
  }

  IconData _getIconForEstado(String? estado) {
    if (estado == 'realizado') return Icons.check_circle;
    if (estado == 'problema') return Icons.error;
    return Icons.pending;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LaboratorioProvider>(context);
    final actividad = provider.currentActividad;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DETALLE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: provider.isLoading && actividad == null
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : actividad == null
              ? const Center(child: Text('Actividad no encontrada'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        actividad.descripcion ?? 'Sin descripción',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (actividad.laboratorios != null && actividad.laboratorios!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'LABORATORIOS ASIGNADOS',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: actividad.laboratorios!.map((lab) {
                            return Chip(
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              label: Text(
                                lab.nombre.toUpperCase(),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const Divider(color: Colors.black, thickness: 1.5, height: 32),
                      const Text(
                        'TAREAS ASIGNADAS',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: (actividad.actividadTareas == null || actividad.actividadTareas!.isEmpty)
                            ? const Center(child: Text('No hay tareas asignadas', style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                itemCount: actividad.actividadTareas!.length,
                                itemBuilder: (context, index) {
                                  final tarea = actividad.actividadTareas![index];
                                  final estadoColor = _getColorForEstado(tarea.estado);
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            width: 6,
                                            decoration: BoxDecoration(
                                              color: estadoColor,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                                bottomLeft: Radius.circular(6),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              title: Text(tarea.tareaDescripcion, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              subtitle: tarea.observacion != null && tarea.observacion!.isNotEmpty
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Text('Observación: ${tarea.observacion}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                                    )
                                                  : null,
                                              trailing: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(_getIconForEstado(tarea.estado), color: estadoColor),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    tarea.estado?.toUpperCase() ?? 'ESPERA',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: estadoColor),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                UpdateTareaModal.show(context, tarea);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
