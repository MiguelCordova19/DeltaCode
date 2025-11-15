import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _keyIsLoggedIn = 'is_logged_in';
  final UsuarioService _usuarioService = UsuarioService();

  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;
  bool get isLoggedIn => _usuarioActual != null;

  // Inicializar y cargar sesión guardada
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    
    if (isLoggedIn) {
      _usuarioActual = await _usuarioService.obtenerUsuario();
    }
  }

  // Iniciar sesión con DNI y fecha de emisión
  Future<bool> login(String dni, DateTime fechaEmision) async {
    // Validar DNI (8 dígitos)
    if (dni.length != 8 || !RegExp(r'^\d+$').hasMatch(dni)) {
      return false;
    }

    // Validar fecha de emisión (no puede ser futura)
    if (fechaEmision.isAfter(DateTime.now())) {
      return false;
    }

    // Aquí podrías hacer una llamada a una API para verificar
    // Por ahora, aceptamos cualquier DNI válido
    
    // Crear o actualizar usuario
    final usuario = await _usuarioService.obtenerUsuario();
    if (usuario != null) {
      usuario.dni = dni;
      await _usuarioService.guardarUsuario(usuario);
      _usuarioActual = usuario;
    } else {
      // Crear nuevo usuario con datos básicos
      _usuarioActual = Usuario(
        dni: dni,
        nombres: 'Usuario',
        apellidos: 'Electoral',
      );
      await _usuarioService.guardarUsuario(_usuarioActual!);
    }

    // Guardar sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);

    return true;
  }

  // Cerrar sesión
  Future<void> logout() async {
    _usuarioActual = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    // No eliminamos los datos del usuario, solo la sesión
  }

  // Verificar si hay sesión activa
  Future<bool> checkSession() async {
    await initialize();
    return isLoggedIn;
  }
}
