class LocalVotacion {
  final String id;
  final String nombre;
  final String direccion;
  final String distrito;
  final double latitud;
  final double longitud;
  final String? referencia;
  final int numeroMesas;
  final String? embedUrl; // URL del iframe de Google Maps
  final String? googleMapsUrl; // URL directa de Google Maps (goo.gl)

  LocalVotacion({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.distrito,
    required this.latitud,
    required this.longitud,
    this.referencia,
    required this.numeroMesas,
    this.embedUrl,
    this.googleMapsUrl,
  });

  // Generar URL de Google Maps con el lugar específico
  String get urlGoogleMaps {
    // Si tiene URL personalizada, usarla; sino generar con coordenadas
    if (googleMapsUrl != null && googleMapsUrl!.isNotEmpty) {
      return googleMapsUrl!;
    }
    return 'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
  }
  
  // URL directa de Google Maps para navegación
  String get urlGoogleMapsDirections {
    // Si tiene URL personalizada, usarla para direcciones; sino generar
    if (googleMapsUrl != null && googleMapsUrl!.isNotEmpty) {
      return googleMapsUrl!;
    }
    return 'https://www.google.com/maps/dir/?api=1&destination=$latitud,$longitud';
  }

  // Generar URL de Waze
  String get urlWaze {
    return 'https://waze.com/ul?ll=$latitud,$longitud&navigate=yes';
  }

  factory LocalVotacion.fromJson(Map<String, dynamic> json) {
    return LocalVotacion(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      distrito: json['distrito'] ?? '',
      latitud: json['latitud']?.toDouble() ?? 0.0,
      longitud: json['longitud']?.toDouble() ?? 0.0,
      referencia: json['referencia'],
      numeroMesas: json['numeroMesas'] ?? 0,
      embedUrl: json['embedUrl'],
      googleMapsUrl: json['googleMapsUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'distrito': distrito,
      'latitud': latitud,
      'longitud': longitud,
      'referencia': referencia,
      'numeroMesas': numeroMesas,
      'embedUrl': embedUrl,
      'googleMapsUrl': googleMapsUrl,
    };
  }
}
