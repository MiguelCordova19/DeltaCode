import 'package:flutter/material.dart';

/// Colores de la aplicación basados en la bandera peruana
class AppColors {
  // Colores principales - Bandera Peruana (tonos suavizados)
  static const Color rojoPeru = Color(0xFFE85D75); // Rojo suave
  static const Color rojoPesuOscuro = Color(0xFFD94A63); // Rojo más oscuro suave
  static const Color blancoPeru = Color(0xFFFFFFFF); // Blanco
  
  // Colores secundarios
  static const Color grisClaro = Color(0xFFF5F5F5);
  static const Color grisOscuro = Color(0xFF424242);
  static const Color grisTexto = Color(0xFF757575);
  
  // Colores de acento
  static const Color azulInfo = Color(0xFF2196F3);
  static const Color verdeExito = Color(0xFF4CAF50);
  static const Color naranjaAdvertencia = Color(0xFFFF9800);
  static const Color rojoError = Color(0xFFE85D75); // Error con rojo suave
  
  // Gradientes
  static const LinearGradient gradienteRojo = LinearGradient(
    colors: [rojoPeru, rojoPesuOscuro],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradienteClaro = LinearGradient(
    colors: [blancoPeru, grisClaro],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Tema de la aplicación
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.rojoPeru,
      scaffoldBackgroundColor: AppColors.blancoPeru,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.rojoPeru,
        primary: AppColors.rojoPeru,
        secondary: AppColors.rojoPesuOscuro,
        surface: AppColors.blancoPeru,
        background: AppColors.grisClaro,
        error: AppColors.rojoError,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.rojoPeru,
        foregroundColor: AppColors.blancoPeru,
        elevation: 0,
        centerTitle: false,
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.rojoPeru,
        foregroundColor: AppColors.blancoPeru,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rojoPeru,
          foregroundColor: AppColors.blancoPeru,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.rojoPeru,
          side: const BorderSide(color: AppColors.rojoPeru),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.rojoPeru,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grisClaro),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rojoPeru, width: 2),
        ),
        filled: true,
        fillColor: AppColors.grisClaro,
        prefixIconColor: AppColors.rojoPeru,
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.blancoPeru,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.rojoPeru,
        unselectedItemColor: AppColors.grisTexto,
        backgroundColor: AppColors.blancoPeru,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.rojoPeru;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.rojoPeru.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.rojoPeru,
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grisOscuro,
        contentTextStyle: const TextStyle(color: AppColors.blancoPeru),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
