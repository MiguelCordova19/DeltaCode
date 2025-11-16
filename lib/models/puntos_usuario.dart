class PuntosUsuario {
  final int balance;
  final List<Logro> logros;
  final List<Transaccion> historial;
  final List<CuponCanjeado> cuponesCanjeados;
  final String codigoReferido;
  final String? codigoReferidoPor;
  final List<Referido> referidos;

  PuntosUsuario({
    required this.balance,
    required this.logros,
    required this.historial,
    required this.cuponesCanjeados,
    required this.codigoReferido,
    this.codigoReferidoPor,
    required this.referidos,
  });

  factory PuntosUsuario.inicial() {
    return PuntosUsuario(
      balance: 0,
      logros: [],
      historial: [],
      cuponesCanjeados: [],
      codigoReferido: _generarCodigoReferido(),
      codigoReferidoPor: null,
      referidos: [],
    );
  }

  static String _generarCodigoReferido() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 100000;
    return 'DECIDE${random.toString().padLeft(5, '0')}';
  }

  factory PuntosUsuario.fromJson(Map<String, dynamic> json) {
    return PuntosUsuario(
      balance: json['balance'] ?? 0,
      logros: (json['logros'] as List?)
              ?.map((e) => Logro.fromJson(e))
              .toList() ??
          [],
      historial: (json['historial'] as List?)
              ?.map((e) => Transaccion.fromJson(e))
              .toList() ??
          [],
      cuponesCanjeados: (json['cuponesCanjeados'] as List?)
              ?.map((e) => CuponCanjeado.fromJson(e))
              .toList() ??
          [],
      codigoReferido: json['codigoReferido'] ?? _generarCodigoReferido(),
      codigoReferidoPor: json['codigoReferidoPor'],
      referidos: (json['referidos'] as List?)
              ?.map((e) => Referido.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'logros': logros.map((e) => e.toJson()).toList(),
      'historial': historial.map((e) => e.toJson()).toList(),
      'cuponesCanjeados': cuponesCanjeados.map((e) => e.toJson()).toList(),
      'codigoReferido': codigoReferido,
      'codigoReferidoPor': codigoReferidoPor,
      'referidos': referidos.map((e) => e.toJson()).toList(),
    };
  }

  PuntosUsuario copyWith({
    int? balance,
    List<Logro>? logros,
    List<Transaccion>? historial,
    List<CuponCanjeado>? cuponesCanjeados,
    String? codigoReferido,
    String? codigoReferidoPor,
    List<Referido>? referidos,
  }) {
    return PuntosUsuario(
      balance: balance ?? this.balance,
      logros: logros ?? this.logros,
      historial: historial ?? this.historial,
      cuponesCanjeados: cuponesCanjeados ?? this.cuponesCanjeados,
      codigoReferido: codigoReferido ?? this.codigoReferido,
      codigoReferidoPor: codigoReferidoPor ?? this.codigoReferidoPor,
      referidos: referidos ?? this.referidos,
    );
  }
}

class Logro {
  final String id;
  final String titulo;
  final String descripcion;
  final int puntos;
  final String icono;
  final DateTime fechaObtenido;
  final bool completado;

  Logro({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.puntos,
    required this.icono,
    required this.fechaObtenido,
    this.completado = false,
  });

  factory Logro.fromJson(Map<String, dynamic> json) {
    return Logro(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntos: json['puntos'],
      icono: json['icono'],
      fechaObtenido: DateTime.parse(json['fechaObtenido']),
      completado: json['completado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'puntos': puntos,
      'icono': icono,
      'fechaObtenido': fechaObtenido.toIso8601String(),
      'completado': completado,
    };
  }
}

class Transaccion {
  final String tipo; // 'ganado' o 'canjeado'
  final int puntos;
  final String descripcion;
  final DateTime fecha;

  Transaccion({
    required this.tipo,
    required this.puntos,
    required this.descripcion,
    required this.fecha,
  });

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      tipo: json['tipo'],
      puntos: json['puntos'],
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'puntos': puntos,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}

class Cupon {
  final String id;
  final String titulo;
  final String descripcion;
  final int puntosRequeridos;
  final String imagen;
  final String categoria;
  final DateTime? fechaExpiracion;

  Cupon({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.puntosRequeridos,
    required this.imagen,
    required this.categoria,
    this.fechaExpiracion,
  });
}

class CuponCanjeado {
  final String id;
  final String cuponId;
  final String titulo;
  final String descripcion;
  final String imagen;
  final String categoria;
  final String codigoBarras;
  final DateTime fechaCanje;
  final DateTime fechaExpiracion;
  final bool usado;

  CuponCanjeado({
    required this.id,
    required this.cuponId,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.categoria,
    required this.codigoBarras,
    required this.fechaCanje,
    required this.fechaExpiracion,
    this.usado = false,
  });

  factory CuponCanjeado.fromJson(Map<String, dynamic> json) {
    return CuponCanjeado(
      id: json['id'],
      cuponId: json['cuponId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      categoria: json['categoria'],
      codigoBarras: json['codigoBarras'],
      fechaCanje: DateTime.parse(json['fechaCanje']),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion']),
      usado: json['usado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cuponId': cuponId,
      'titulo': titulo,
      'descripcion': descripcion,
      'imagen': imagen,
      'categoria': categoria,
      'codigoBarras': codigoBarras,
      'fechaCanje': fechaCanje.toIso8601String(),
      'fechaExpiracion': fechaExpiracion.toIso8601String(),
      'usado': usado,
    };
  }

  CuponCanjeado copyWith({
    bool? usado,
  }) {
    return CuponCanjeado(
      id: id,
      cuponId: cuponId,
      titulo: titulo,
      descripcion: descripcion,
      imagen: imagen,
      categoria: categoria,
      codigoBarras: codigoBarras,
      fechaCanje: fechaCanje,
      fechaExpiracion: fechaExpiracion,
      usado: usado ?? this.usado,
    );
  }
}

class Referido {
  final String id;
  final String codigoReferido;
  final DateTime fechaRegistro;
  final int puntosGanados;
  final bool activo;

  Referido({
    required this.id,
    required this.codigoReferido,
    required this.fechaRegistro,
    required this.puntosGanados,
    this.activo = true,
  });

  factory Referido.fromJson(Map<String, dynamic> json) {
    return Referido(
      id: json['id'],
      codigoReferido: json['codigoReferido'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
      puntosGanados: json['puntosGanados'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigoReferido': codigoReferido,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'puntosGanados': puntosGanados,
      'activo': activo,
    };
  }
}
