enum EstadoSenador {
  precandidato,
  oficial,
}

enum TipoSenador {
  nacional,
  regional,
}

class Senador {
  final String id;
  final String nombre;
  final int? edad;
  final String? profesion;
  final String? biografia;
  final List<String> propuestas;
  final String partido;
  final EstadoSenador estado;
  final TipoSenador tipo;
  final String? region; // Solo para senadores regionales

  Senador({
    required this.id,
    required this.nombre,
    this.edad,
    this.profesion,
    this.biografia,
    required this.propuestas,
    required this.partido,
    required this.estado,
    required this.tipo,
    this.region,
  });

  factory Senador.fromJson(Map<String, dynamic> json) {
    return Senador(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      edad: json['edad'] as int?,
      profesion: json['profesion'] as String?,
      biografia: json['biografia'] as String?,
      propuestas: (json['propuestas'] as List<dynamic>).cast<String>(),
      partido: json['partido'] as String,
      estado: json['estado'] == 'OFICIAL'
          ? EstadoSenador.oficial
          : EstadoSenador.precandidato,
      tipo: json['tipo'] == 'REGIONAL'
          ? TipoSenador.regional
          : TipoSenador.nacional,
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      if (edad != null) 'edad': edad,
      if (profesion != null) 'profesion': profesion,
      if (biografia != null) 'biografia': biografia,
      'propuestas': propuestas,
      'partido': partido,
      'estado': estado == EstadoSenador.oficial ? 'OFICIAL' : 'PRECANDIDATO',
      'tipo': tipo == TipoSenador.regional ? 'REGIONAL' : 'NACIONAL',
      if (region != null) 'region': region,
    };
  }

  // Obtener partidos únicos
  static List<String> getPartidosUnicos(List<Senador> senadores) {
    return senadores.map((s) => s.partido).toSet().toList()..sort();
  }
}
