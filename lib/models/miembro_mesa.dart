class MiembroMesa {
  final String id;
  final String nombres;
  final String apellidos;
  final String dni;
  final int numeroMesa;
  final CargoMesa cargo;
  final String localVotacion;
  final String direccionLocal;
  final String distrito;
  final String provincia;
  final String departamento;
  final bool esSuplente;
  final String? observaciones;

  MiembroMesa({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.numeroMesa,
    required this.cargo,
    required this.localVotacion,
    required this.direccionLocal,
    required this.distrito,
    required this.provincia,
    required this.departamento,
    this.esSuplente = false,
    this.observaciones,
  });

  String get nombreCompleto => '$nombres $apellidos';

  String get cargoDescripcion {
    switch (cargo) {
      case CargoMesa.presidente:
        return 'Presidente de Mesa';
      case CargoMesa.secretario:
        return 'Secretario';
      case CargoMesa.tercerMiembro:
        return 'Tercer Miembro';
      case CargoMesa.suplente:
        return 'Suplente';
    }
  }

  factory MiembroMesa.fromJson(Map<String, dynamic> json) {
    return MiembroMesa(
      id: json['id'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      dni: json['dni'] ?? '',
      numeroMesa: json['numeroMesa'] ?? 0,
      cargo: CargoMesa.values.firstWhere(
        (e) => e.toString() == 'CargoMesa.${json['cargo']}',
        orElse: () => CargoMesa.tercerMiembro,
      ),
      localVotacion: json['localVotacion'] ?? '',
      direccionLocal: json['direccionLocal'] ?? '',
      distrito: json['distrito'] ?? '',
      provincia: json['provincia'] ?? '',
      departamento: json['departamento'] ?? '',
      esSuplente: json['esSuplente'] ?? false,
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'dni': dni,
      'numeroMesa': numeroMesa,
      'cargo': cargo.toString().split('.').last,
      'localVotacion': localVotacion,
      'direccionLocal': direccionLocal,
      'distrito': distrito,
      'provincia': provincia,
      'departamento': departamento,
      'esSuplente': esSuplente,
      'observaciones': observaciones,
    };
  }
}

enum CargoMesa {
  presidente,
  secretario,
  tercerMiembro,
  suplente,
}

class InfoMiembroMesa {
  static const String compensacionEconomica = 'S/ 120.00';
  
  static const List<String> derechos = [
    'Recibir compensación económica de S/ 120.00',
    'Permiso laboral remunerado el día de las elecciones',
    'Justificar inasistencia por causas válidas',
    'Recibir capacitación de la ONPE',
    'Solicitar apoyo de las fuerzas del orden',
  ];

  static const List<String> obligaciones = [
    'Asistir puntualmente a la instalación de la mesa (8:00 AM)',
    'Permanecer en la mesa durante toda la jornada electoral',
    'Verificar la identidad de los electores',
    'Garantizar el secreto del voto',
    'Realizar el escrutinio al cierre de la votación',
    'Firmar el Acta Electoral',
    'Entregar los documentos electorales a la ODPE',
  ];

  static const Map<String, String> funcionesPorCargo = {
    'Presidente': 'Conduce los actos principales de la mesa electoral, representa a la mesa ante las autoridades y coordina con el secretario y tercer miembro.',
    'Secretario': 'Apoya al presidente en las tareas administrativas, verifica la lista de electores y ayuda en el llenado de documentos.',
    'Tercer Miembro': 'Permanece junto al presidente y secretario, apoya en todas las tareas de la mesa y puede reemplazar al secretario si es necesario.',
  };

  static const List<Map<String, String>> causalesExcusa = [
    {
      'causa': 'Enfermedad grave',
      'requisito': 'Certificado médico',
      'plazo': 'Antes de la elección',
    },
    {
      'causa': 'Ser mayor de 70 años',
      'requisito': 'Copia de DNI',
      'plazo': 'Antes de la elección',
    },
    {
      'causa': 'Ser funcionario electoral',
      'requisito': 'Constancia de designación',
      'plazo': 'Antes de la elección',
    },
    {
      'causa': 'Vivir a más de 3 horas del local',
      'requisito': 'Declaración jurada',
      'plazo': 'Antes de la elección',
    },
  ];

  static const String multaPorInasistencia = 'S/ 267.50';
  
  static const String procedimientoCompensacion = '''
Para recibir la compensación económica:

1. Registrarse en la plataforma de ONPE después de cumplir el cargo
2. Elegir modalidad de pago:
   • Depósito en cuenta bancaria
   • Billetera digital (Yape, Plin, etc.)
   • Cobro presencial en Banco de la Nación
3. Esperar la confirmación de ONPE (aproximadamente 15 días)
4. Recibir el pago de S/ 120.00
''';

  static const String procedimientoJustificacion = '''
Para justificar la inasistencia:

ANTES DE LA ELECCIÓN (Excusa):
1. Acudir a la ODPE de tu jurisdicción
2. Presentar documentos que sustenten la causal
3. Esperar resolución de la ODPE

DESPUÉS DE LA ELECCIÓN (Justificación):
1. Presentar solicitud ante el JNE o ODPE
2. Adjuntar certificado médico u otro documento válido
3. Hacerlo dentro del plazo establecido
4. Esperar resolución

NOTA: La multa por omisión es de S/ 267.50
''';
}
