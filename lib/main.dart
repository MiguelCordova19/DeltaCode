import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'config/app_colors.dart';

void main() {
  runApp(const EleccionesApp());
}

class EleccionesApp extends StatelessWidget {
  const EleccionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elecciones 2026',
      debugShowCheckedModeBanner: false,
      
      // Localizaciones en español
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('es', 'PE'), // Español Perú
      ],
      locale: const Locale('es', 'PE'), // Español Perú por defecto
      
      // Tema con colores peruanos
      theme: AppTheme.lightTheme,
      
      home: const SplashScreen(),
    );
  }
}
