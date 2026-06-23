import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_provider.dart';
import '../state/laboratorio_provider.dart';
import 'auth/login_page.dart';
import 'widgets/dashboard_navigation_bar.dart';
import 'inicio/inicio_view.dart';
import 'actividades/actividades_view.dart';
import 'ajustes/ajustes_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final List<String> _titles = const ['INICIO', 'ACTIVIDADES', 'AJUSTES'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchProfile();
      Provider.of<LaboratorioProvider>(context, listen: false).loadLaboratorios();
    });
  }

  void _mostrarReportarIncidencia(BuildContext context) {
    final provider = Provider.of<LaboratorioProvider>(context, listen: false);
    provider.loadLaboratorios();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String descripcion = '';
        String prioridad = 'media';
        int? selectedLabId;

        int? selectedAccesorioId;

        return StatefulBuilder(
          builder: (context, setState) {
            final labs = provider.laboratorios;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 1.5),
              ),
              title: const Text(
                'REPORTAR INCIDENCIA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Descripción del problema:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Ej: Pantalla rota, proyector no enciende...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                      ),
                      onChanged: (val) => descripcion = val,
                    ),
                    const SizedBox(height: 16),
                    const Text('Prioridad:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: prioridad,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'baja', child: Text('Baja')),
                        DropdownMenuItem(value: 'media', child: Text('Media')),
                        DropdownMenuItem(value: 'alta', child: Text('Alta')),
                      ],
                      onChanged: (val) => setState(() => prioridad = val ?? 'media'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Laboratorio afectado (opcional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int?>(
                      value: selectedLabId,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
                      ),
                      hint: const Text('Seleccionar laboratorio...', style: TextStyle(fontSize: 13)),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('Ninguno / General')),
                        ...labs.map((lab) {
                          return DropdownMenuItem<int?>(
                            value: lab.id,
                            child: Text(lab.nombre),
                          );
                        }).toList(),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedLabId = val;
                          selectedAccesorioId = null;
                        });
                      },
                    ),
                    if (selectedLabId != null) ...[
                      const SizedBox(height: 16),
                      const Text('Accesorio afectado (opcional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int?>(
                        value: selectedAccesorioId,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
                        ),
                        hint: const Text('Seleccionar accesorio...', style: TextStyle(fontSize: 13)),
                        items: [
                          const DropdownMenuItem<int?>(value: null, child: Text('Ninguno')),
                          ...(() {
                            final lab = labs.firstWhere((l) => l.id == selectedLabId);
                            return (lab.accesorios ?? []).map((acc) {
                              return DropdownMenuItem<int?>(
                                value: acc.id,
                                child: Text(acc.nombre),
                              );
                            });
                          })(),
                        ],
                        onChanged: (val) => setState(() => selectedAccesorioId = val),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCELAR', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () async {
                    if (descripcion.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, ingresa una descripción.')),
                      );
                      return;
                    }
                    final success = await provider.reportarIncidencia(descripcion, prioridad, selectedLabId, selectedAccesorioId);
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Colors.green, content: Text('Incidencia reportada con éxito.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(backgroundColor: Colors.red, content: Text('Error: ${provider.error}')),
                      );
                    }
                  },
                  child: const Text('REPORTAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Minimalista: Blanco y negro, lineas. Capsula inferior flotante.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: auth.profile == null
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : IndexedStack(
              index: _currentIndex,
              children: const [
                InicioView(),
                ActividadesView(),
                AjustesView(),
              ],
            ),
      bottomNavigationBar: DashboardNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
        onPressed: () => _mostrarReportarIncidencia(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
