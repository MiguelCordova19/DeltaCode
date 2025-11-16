enum EstadoCandidato {
  precandidato,
  oficial,
}

class Diputado {
  final String nombre;
  final String partido;
  final List<String> consignas;
  final EstadoCandidato estado;
  final String? region; // Opcional: para cuando haya datos por circunscripción

  Diputado({
    required this.nombre,
    required this.partido,
    required this.consignas,
    required this.estado,
    this.region,
  });

  factory Diputado.fromJson(Map<String, dynamic> json) {
    return Diputado(
      nombre: json['nombre'] as String,
      partido: json['partido'] as String,
      consignas: (json['consignas'] as List<dynamic>).cast<String>(),
      estado: json['estado'] == 'OFICIAL'
          ? EstadoCandidato.oficial
          : EstadoCandidato.precandidato,
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'partido': partido,
      'consignas': consignas,
      'estado': estado == EstadoCandidato.oficial ? 'OFICIAL' : 'PRECANDIDATO',
      if (region != null) 'region': region,
    };
  }

  // Datos de precandidatos - Importados desde diputados_data.dart
  static List<Diputado> getPrecandidatos() {
    // Este método será reemplazado por la importación desde DiputadosData
    // Por ahora retorna una lista vacía para evitar duplicación
    return [];
  }

  // Datos oficiales - Por ahora vacío
  static List<Diputado> getCandidatosOficiales() {
    return [];
  }

  // Obtener partidos únicos
  static List<String> getPartidosUnicos(List<Diputado> diputados) {
    return diputados.map((d) => d.partido).toSet().toList()..sort();
  }
}
