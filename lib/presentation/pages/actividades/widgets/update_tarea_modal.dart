import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/laboratorio_provider.dart';
import '../../../../data/models/actividad_model.dart';

class UpdateTareaModal extends StatefulWidget {
  final ActividadTareaModel tarea;

  const UpdateTareaModal({super.key, required this.tarea});

  static void show(BuildContext context, ActividadTareaModel tarea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => UpdateTareaModal(tarea: tarea),
    );
  }

  @override
  State<UpdateTareaModal> createState() => _UpdateTareaModalState();
}

class _UpdateTareaModalState extends State<UpdateTareaModal> {
  late TextEditingController _obsController;
  late String _estado;

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.tarea.observacion ?? '');
    _estado = widget.tarea.estado ?? 'espera';
  }

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = Provider.of<LaboratorioProvider>(context, listen: false);
    final success = await provider.updateTarea(widget.tarea.id, _estado, _obsController.text);
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Error al actualizar tarea'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding para evitar que el teclado cubra el contenido
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Detalles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.tarea.tareaDescripcion,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          
          DropdownButtonFormField<String>(
            value: _estado,
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
            ),
            items: const [
              DropdownMenuItem(value: 'espera', child: Text('En Espera')),
              DropdownMenuItem(value: 'realizado', child: Text('Realizado')),
              DropdownMenuItem(value: 'problema', child: Text('Revisión / Problema')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _estado = val);
            },
          ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _obsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observación',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Consumer<LaboratorioProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: provider.isLoading ? null : _submit,
                child: provider.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              );
            }
          ),
        ],
      ),
    );
  }
}
