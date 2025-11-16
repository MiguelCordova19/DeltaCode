class ParlamentoAndino {
  final String id;
  final String nombre;
  final String partido;
  final List<String> consignas;

  ParlamentoAndino({
    required this.id,
    required this.nombre,
    required this.partido,
    required this.consignas,
  });

  factory ParlamentoAndino.fromJson(Map<String, dynamic> json) {
    return ParlamentoAndino(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      partido: json['partido'] as String,
      consignas: (json['consignas'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'partido': partido,
      'consignas': consignas,
    };
  }

  // Obtener partidos únicos
  static List<String> getPartidosUnicos(List<ParlamentoAndino> candidatos) {
    return candidatos.map((c) => c.partido).toSet().toList()..sort();
  }
}
