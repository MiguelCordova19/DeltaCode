import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/usuario.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _keyUsuario = 'usuario_actual';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;
  bool get isLoggedIn => _usuarioActual != null;

  // Inicializar y cargar sesión guardada
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    
    if (isLoggedIn) {
      final usuarioJson = prefs.getString(_keyUsuario);
      if (usuarioJson != null) {
        _usuarioActual = Usuario.fromJson(jsonDecode(usuarioJson));
      }
    }
  }

  // Iniciar sesión con DNI y fecha de emisión
  Future<bool> login(String dni, DateTime fechaEmision) async {
    // Validar DNI
    if (!Usuario.validarDNI(dni)) {
      return false;
    }

    // Validar fecha de emisión
    if (!Usuario.validarFechaEmision(fechaEmision)) {
      return false;
    }

    // Aquí podrías hacer una llamada a una API para verificar
    // Por ahora, solo validamos el formato
    
    // Crear usuario
    _usuarioActual = Usuario(
      dni: dni,
      fechaEmision: fechaEmision,
    );

    // Guardar sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsuario, jsonEncode(_usuarioActual!.toJson()));

    return true;
  }

  // Cerrar sesión
  Future<void> logout() async {
    _usuarioActual = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsuario);
  }

  // Verificar si hay sesión activa
  Future<bool> checkSession() async {
    await initialize();
    return isLoggedIn;
  }
}
