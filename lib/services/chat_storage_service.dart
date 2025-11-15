import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_conversation.dart';

class ChatStorageService {
  static const String _keyConversations = 'chat_conversations';
  static const String _keyActiveConversationId = 'active_conversation_id';

  // Guardar todas las conversaciones
  Future<void> guardarConversaciones(List<ChatConversation> conversaciones) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = conversaciones.map((c) => c.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_keyConversations, jsonString);
  }

  // Cargar todas las conversaciones
  Future<List<ChatConversation>> cargarConversaciones() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyConversations);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ChatConversation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al cargar conversaciones: $e');
      return [];
    }
  }

  // Guardar una conversación
  Future<void> guardarConversacion(ChatConversation conversacion) async {
    final conversaciones = await cargarConversaciones();
    final index = conversaciones.indexWhere((c) => c.id == conversacion.id);
    
    if (index >= 0) {
      conversaciones[index] = conversacion;
    } else {
      conversaciones.add(conversacion);
    }

    await guardarConversaciones(conversaciones);
  }

  // Eliminar una conversación
  Future<void> eliminarConversacion(String conversacionId) async {
    final conversaciones = await cargarConversaciones();
    conversaciones.removeWhere((c) => c.id == conversacionId);
    await guardarConversaciones(conversaciones);
  }

  // Guardar ID de conversación activa
  Future<void> guardarConversacionActiva(String conversacionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveConversationId, conversacionId);
  }

  // Obtener ID de conversación activa
  Future<String?> obtenerConversacionActiva() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveConversationId);
  }

  // Limpiar conversación activa
  Future<void> limpiarConversacionActiva() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActiveConversationId);
  }
}
