import 'package:flutter/material.dart';
import '../services/idioma_service.dart';

class IdiomaProvider extends ChangeNotifier {
  final IdiomaService _idiomaService = IdiomaService();
  Locale _locale = const Locale('es');
  
  Locale get locale => _locale;
  
  IdiomaProvider() {
    _cargarIdiomaInicial();
  }
  
  // Cargar idioma guardado sin bloquear la UI
  void _cargarIdiomaInicial() {
    _idiomaService.obtenerIdiomaActual().then((idioma) {
      _locale = Locale(idioma);
      notifyListeners();
    }).catchError((e) {
      // Si hay error, mantener español por defecto
      _locale = const Locale('es');
    });
  }
  
  Future<void> cambiarIdioma(String idioma) async {
    await _idiomaService.cambiarIdioma(idioma);
    _locale = Locale(idioma);
    notifyListeners();
  }
}
