import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/laboratorio_provider.dart';
import 'actividad_detail_page.dart';

class ActividadesView extends StatefulWidget {
  const ActividadesView({super.key});

  @override
  State<ActividadesView> createState() => _ActividadesViewState();
}

class _ActividadesViewState extends State<ActividadesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaboratorioProvider>(context, listen: false).loadActividades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LaboratorioProvider>(context);

    if (provider.isLoading && provider.actividades.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    if (provider.error != null && provider.actividades.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.black),
            const SizedBox(height: 16),
            Text(provider.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: () => provider.loadActividades(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      itemCount: provider.actividades.length,
      itemBuilder: (context, index) {
        final actividad = provider.actividades[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              actividad.descripcion ?? 'Actividad #${actividad.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: actividad.descripcion != null
                ? Text('ID: #${actividad.id}', style: const TextStyle(color: Colors.black54))
                : null,
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActividadDetailPage(actividadId: actividad.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
