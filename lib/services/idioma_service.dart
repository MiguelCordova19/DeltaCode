import 'package:shared_preferences/shared_preferences.dart';

class IdiomaService {
  static const String _keyIdioma = 'idioma_app';
  
  // Idiomas disponibles
  static const String ESPANOL = 'es';
  static const String QUECHUA = 'qu';
  
  Future<String> obtenerIdiomaActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyIdioma) ?? ESPANOL;
  }
  
  Future<bool> cambiarIdioma(String idioma) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyIdioma, idioma);
  }
}
