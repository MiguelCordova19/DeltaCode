class MensajeChat {
  final String id;
  final String texto;
  final bool esUsuario;
  final DateTime timestamp;

  MensajeChat({
    required this.id,
    required this.texto,
    required this.esUsuario,
    required this.timestamp,
  });

  factory MensajeChat.fromJson(Map<String, dynamic> json) {
    return MensajeChat(
      id: json['id'] ?? '',
      texto: json['texto'] ?? '',
      esUsuario: json['esUsuario'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'esUsuario': esUsuario,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
