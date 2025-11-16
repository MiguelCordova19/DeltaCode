enum EstadoSenador {
  precandidato,
  oficial,
}

class Senador {
  final String id;
  final String nombre;
  final int edad;
  final String profesion;
  final String biografia;
  final List<String> propuestas;
  final String partido;
  final EstadoSenador estado;

  Senador({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.profesion,
    required this.biografia,
    required this.propuestas,
    required this.partido,
    required this.estado,
  });

  factory Senador.fromJson(Map<String, dynamic> json) {
    return Senador(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      edad: json['edad'] as int,
      profesion: json['profesion'] as String,
      biografia: json['biografia'] as String,
      propuestas: (json['propuestas'] as List<dynamic>).cast<String>(),
      partido: json['partido'] as String,
      estado: json['estado'] == 'OFICIAL'
          ? EstadoSenador.oficial
          : EstadoSenador.precandidato,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'profesion': profesion,
      'biografia': biografia,
      'propuestas': propuestas,
      'partido': partido,
      'estado': estado == EstadoSenador.oficial ? 'OFICIAL' : 'PRECANDIDATO',
    };
  }

  // Obtener partidos únicos
  static List<String> getPartidosUnicos(List<Senador> senadores) {
    return senadores.map((s) => s.partido).toSet().toList()..sort();
  }
}
