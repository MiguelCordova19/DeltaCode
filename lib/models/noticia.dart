class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String url;
  final String? imagenUrl;
  final DateTime fechaPublicacion;
  final String fuente;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.url,
    this.imagenUrl,
    required this.fechaPublicacion,
    required this.fuente,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      url: json['url'] ?? '',
      imagenUrl: json['imagenUrl'],
      fechaPublicacion: json['fechaPublicacion'] != null
          ? DateTime.parse(json['fechaPublicacion'])
          : DateTime.now(),
      fuente: json['fuente'] ?? 'El Comercio',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'url': url,
      'imagenUrl': imagenUrl,
      'fechaPublicacion': fechaPublicacion.toIso8601String(),
      'fuente': fuente,
    };
  }
}
