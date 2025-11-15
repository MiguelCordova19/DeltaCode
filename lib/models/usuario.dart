class Usuario {
  final String dni;
  final DateTime fechaEmision;
  final String? nombre;
  final String? apellidos;
  final String? direccion;
  final String? mesa;

  Usuario({
    required this.dni,
    required this.fechaEmision,
    this.nombre,
    this.apellidos,
    this.direccion,
    this.mesa,
  });

  // Validar DNI peruano (8 dígitos)
  static bool validarDNI(String dni) {
    if (dni.length != 8) return false;
    return RegExp(r'^[0-9]{8}$').hasMatch(dni);
  }

  // Validar que la fecha no sea futura
  static bool validarFechaEmision(DateTime fecha) {
    return fecha.isBefore(DateTime.now()) || 
           fecha.isAtSameMomentAs(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'fechaEmision': fechaEmision.toIso8601String(),
      'nombre': nombre,
      'apellidos': apellidos,
      'direccion': direccion,
      'mesa': mesa,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      dni: json['dni'],
      fechaEmision: DateTime.parse(json['fechaEmision']),
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      direccion: json['direccion'],
      mesa: json['mesa'],
    );
  }
}
