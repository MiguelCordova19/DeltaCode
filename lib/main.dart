import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'config/app_colors.dart';
import 'providers/idioma_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => IdiomaProvider(),
      child: const EleccionesApp(),
    ),
  );
}

class EleccionesApp extends StatelessWidget {
  const EleccionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IdiomaProvider>(
      builder: (context, idiomaProvider, _) {
        return MaterialApp(
          title: 'DecideYA',
          debugShowCheckedModeBanner: false,
          
          // Localizaciones
          locale: idiomaProvider.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
            Locale('qu'),
          ],
          
          // Fallback a español cuando no hay localización disponible
          localeResolutionCallback: (locale, supportedLocales) {
            // Si el idioma es quechua, usar español para Material
            if (locale?.languageCode == 'qu') {
              return const Locale('es');
            }
            // Para otros casos, usar el idioma solicitado si está soportado
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            // Si no está soportado, usar español por defecto
            return const Locale('es');
          },
          
          // Tema con colores peruanos
          theme: AppTheme.lightTheme,
          
          home: const SplashScreen(),
        );
      },
    );
  }
}
