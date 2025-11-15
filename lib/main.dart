import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';

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
      locale: const Locale('es', 'ES'),
      
      theme: ThemeData(
        primaryColor: const Color(0xFF7C4DFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          primary: const Color(0xFF7C4DFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
