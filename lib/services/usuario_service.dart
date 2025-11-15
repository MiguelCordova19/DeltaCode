import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

class UsuarioService {
  static const String _userKey = 'usuario_data';

  // Guardar usuario
  Future<bool> guardarUsuario(Usuario usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(usuario.toJson());
      return await prefs.setString(_userKey, jsonString);
    } catch (e) {
      print('Error al guardar usuario: $e');
      return false;
    }
  }

  // Obtener usuario
  Future<Usuario?> obtenerUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userKey);
      
      if (jsonString == null) {
        // Retornar usuario de ejemplo si no hay datos
        return Usuario.ejemplo();
      }
      
      final jsonMap = jsonDecode(jsonString);
      return Usuario.fromJson(jsonMap);
    } catch (e) {
      print('Error al obtener usuario: $e');
      return Usuario.ejemplo();
    }
  }

  // Actualizar campo específico
  Future<bool> actualizarCampo(String campo, dynamic valor) async {
    try {
      final usuario = await obtenerUsuario();
      if (usuario == null) return false;

      // Actualizar el campo correspondiente
      switch (campo) {
        case 'nombres':
          usuario.nombres = valor;
          break;
        case 'apellidos':
          usuario.apellidos = valor;
          break;
        case 'email':
          usuario.email = valor;
          break;
        case 'telefono':
          usuario.telefono = valor;
          break;
        case 'direccion':
          usuario.direccion = valor;
          break;
        case 'distrito':
          usuario.distrito = valor;
          break;
        case 'provincia':
          usuario.provincia = valor;
          break;
        case 'departamento':
          usuario.departamento = valor;
          break;
        case 'notificacionesActivas':
          usuario.notificacionesActivas = valor;
          break;
        case 'notificacionesEmail':
          usuario.notificacionesEmail = valor;
          break;
        case 'notificacionesPush':
          usuario.notificacionesPush = valor;
          break;
        case 'recordatoriosElectorales':
          usuario.recordatoriosElectorales = valor;
          break;
      }

      return await guardarUsuario(usuario);
    } catch (e) {
      print('Error al actualizar campo: $e');
      return false;
    }
  }

  // Limpiar datos de usuario
  Future<bool> limpiarUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Error al limpiar usuario: $e');
      return false;
    }
  }
}
