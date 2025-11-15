class Usuario {
  String dni;
  String nombres;
  String apellidos;
  String? email;
  String? telefono;
  DateTime? fechaNacimiento;
  String? direccion;
  String? distrito;
  String? provincia;
  String? departamento;
  
  // Información electoral
  String? localVotacion;
  String? direccionLocal;
  String? numeroMesa;
  
  // Configuraciones
  bool notificacionesActivas;
  bool notificacionesEmail;
  bool notificacionesPush;
  bool recordatoriosElectorales;
  
  Usuario({
    required this.dni,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
    this.fechaNacimiento,
    this.direccion,
    this.distrito,
    this.provincia,
    this.departamento,
    this.localVotacion,
    this.direccionLocal,
    this.numeroMesa,
    this.notificacionesActivas = true,
    this.notificacionesEmail = true,
    this.notificacionesPush = true,
    this.recordatoriosElectorales = true,
  });

  String get nombreCompleto => '$nombres $apellidos';
  
  int? get edad {
    if (fechaNacimiento == null) return null;
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento!.year;
    if (hoy.month < fechaNacimiento!.month ||
        (hoy.month == fechaNacimiento!.month && hoy.day < fechaNacimiento!.day)) {
      edad--;
    }
    return edad;
  }

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'direccion': direccion,
      'distrito': distrito,
      'provincia': provincia,
      'departamento': departamento,
      'localVotacion': localVotacion,
      'direccionLocal': direccionLocal,
      'numeroMesa': numeroMesa,
      'notificacionesActivas': notificacionesActivas,
      'notificacionesEmail': notificacionesEmail,
      'notificacionesPush': notificacionesPush,
      'recordatoriosElectorales': recordatoriosElectorales,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      dni: json['dni'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      email: json['email'],
      telefono: json['telefono'],
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : null,
      direccion: json['direccion'],
      distrito: json['distrito'],
      provincia: json['provincia'],
      departamento: json['departamento'],
      localVotacion: json['localVotacion'],
      direccionLocal: json['direccionLocal'],
      numeroMesa: json['numeroMesa'],
      notificacionesActivas: json['notificacionesActivas'] ?? true,
      notificacionesEmail: json['notificacionesEmail'] ?? true,
      notificacionesPush: json['notificacionesPush'] ?? true,
      recordatoriosElectorales: json['recordatoriosElectorales'] ?? true,
    );
  }

  // Usuario de ejemplo
  static Usuario ejemplo() {
    return Usuario(
      dni: '12345678',
      nombres: 'Juan Carlos',
      apellidos: 'Pérez García',
      email: 'juan.perez@email.com',
      telefono: '+51 987 654 321',
      fechaNacimiento: DateTime(1990, 5, 15),
      direccion: 'Av. Principal 123, Dpto. 401',
      distrito: 'San Isidro',
      provincia: 'Lima',
      departamento: 'Lima',
      localVotacion: 'I.E. San Martín de Porres',
      direccionLocal: 'Av. Arequipa 1234, San Isidro',
      numeroMesa: '058423',
    );
  }
}
