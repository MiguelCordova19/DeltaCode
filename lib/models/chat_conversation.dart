import 'mensaje_chat.dart';

class ChatConversation {
  final String id;
  final String titulo;
  final DateTime fechaCreacion;
  final DateTime ultimaActualizacion;
  final List<MensajeChat> mensajes;

  ChatConversation({
    required this.id,
    required this.titulo,
    required this.fechaCreacion,
    required this.ultimaActualizacion,
    required this.mensajes,
  });

  // Convertir a JSON para guardar
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'ultimaActualizacion': ultimaActualizacion.toIso8601String(),
      'mensajes': mensajes.map((m) => m.toJson()).toList(),
    };
  }

  // Crear desde JSON
  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      ultimaActualizacion: DateTime.parse(json['ultimaActualizacion'] as String),
      mensajes: (json['mensajes'] as List)
          .map((m) => MensajeChat.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  // Copiar con cambios
  ChatConversation copyWith({
    String? id,
    String? titulo,
    DateTime? fechaCreacion,
    DateTime? ultimaActualizacion,
    List<MensajeChat>? mensajes,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      mensajes: mensajes ?? this.mensajes,
    );
  }

  // Generar título automático desde el primer mensaje del usuario
  static String generarTituloAutomatico(String primerMensaje) {
    final palabras = primerMensaje.split(' ');
    if (palabras.length <= 6) {
      return primerMensaje;
    }
    return '${palabras.take(6).join(' ')}...';
  }
}
