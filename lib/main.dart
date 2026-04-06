import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/state/auth_provider.dart';
import 'presentation/state/laboratorio_provider.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/dashboard/dashboard_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LaboratorioProvider()),
      ],
      child: const GestorLabApp(),
    ),
  );
}

class GestorLabApp extends StatelessWidget {
  const GestorLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestorLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const DashboardPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
