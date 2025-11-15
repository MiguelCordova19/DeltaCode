class EventoElectoral {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final DateTime? fechaFin; // Para eventos de varios días
  final TipoEvento tipo;
  final String? ubicacion;
  final bool esFechaLimite;

  EventoElectoral({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    this.fechaFin,
    required this.tipo,
    this.ubicacion,
    this.esFechaLimite = false,
  });

  // Verificar si el evento es en una fecha específica
  bool esEnFecha(DateTime date) {
    if (fechaFin != null) {
      return date.isAfter(fecha.subtract(const Duration(days: 1))) &&
          date.isBefore(fechaFin!.add(const Duration(days: 1)));
    }
    return fecha.year == date.year &&
        fecha.month == date.month &&
        fecha.day == date.day;
  }

  // Verificar si el evento ya pasó
  bool get yaPaso => DateTime.now().isAfter(fecha);

  // Días restantes hasta el evento
  int get diasRestantes => fecha.difference(DateTime.now()).inDays;
}

enum TipoEvento {
  eleccion, // Día de elecciones
  inscripcion, // Inscripción de candidatos
  miembroMesa, // Eventos para miembros de mesa
  debate, // Debates electorales
  propaganda, // Inicio/fin de propaganda
  capacitacion, // Capacitaciones
  sorteo, // Sorteo de miembros de mesa
  otro,
}

// Base de datos de eventos electorales 2024-2026
class EventosElectoralesData {
  static List<EventoElectoral> getEventos() {
    return [
      // JULIO 2024
      EventoElectoral(
        id: 'jul_2024_1',
        titulo: 'Fecha Límite para Afiliarse para Participar en Elecciones Primarias',
        fecha: DateTime(2024, 7, 12),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),

      // DICIEMBRE 2024
      EventoElectoral(
        id: 'dic_2024_1',
        titulo: 'Convocatoria a Elecciones / Publicación del D.S. 035-2025-PCM',
        fecha: DateTime(2024, 12, 23),
        tipo: TipoEvento.otro,
      ),

      // FEBRERO 2025
      EventoElectoral(
        id: 'feb_2025_1',
        titulo: 'Fecha Límite para Renunciar a la Afiliación y Participar como Candidato',
        fecha: DateTime(2025, 2, 18),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'feb_2025_2',
        titulo: 'Fecha Límite para que las OP comuniquen a la ONPE la Modalidad de Elecciones Primarias',
        fecha: DateTime(2025, 2, 26),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // MARZO 2025
      EventoElectoral(
        id: 'mar_2025_1',
        titulo: 'Fecha Límite para solicitar Inscripción de Modificación de Normativa Interna de OP ante el ROP',
        fecha: DateTime(2025, 3, 12),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'mar_2025_2',
        titulo: 'Fecha Límite para que las Alianzas Electorales logren su Inscripción en el ROP',
        fecha: DateTime(2025, 3, 13),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),

      // ABRIL 2025
      EventoElectoral(
        id: 'abr_2025_1',
        titulo: 'Fecha Límite para la Convocatoria a Elecciones Generales que comprende a Elecciones Primarias',
        fecha: DateTime(2025, 4, 11),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'abr_2025_2',
        titulo: 'Fecha Límite para que los Partidos Políticos designen Órganos Electorales Primarios',
        fecha: DateTime(2025, 4, 30),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // MAYO 2025
      EventoElectoral(
        id: 'may_2025_1',
        titulo: 'Fecha Límite para Solicitar la Inscripción de Alianzas Electorales ante la DNROP',
        fecha: DateTime(2025, 5, 2),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'may_2025_2',
        titulo: 'Fecha Límite para que el RENIEC remita a la DNROP el resultado de la Verificación de Afiliados',
        fecha: DateTime(2025, 5, 12),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // JUNIO 2025
      EventoElectoral(
        id: 'jun_2025_1',
        titulo: 'Fecha Límite para que las Candidaturas queden Inscritas (Elecciones Primarias)',
        fecha: DateTime(2025, 6, 30),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),

      // AGOSTO 2025
      EventoElectoral(
        id: 'ago_2025_1',
        titulo: 'Fecha Límite para que la DNROP remita al RENIEC la información para la Elaboración de los Padrones de Electores Afiliados',
        fecha: DateTime(2025, 8, 1),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'ago_2025_2',
        titulo: 'Fecha Límite para que la DNROP presente a la DHROP la relación de Electores No Afiliados',
        fecha: DateTime(2025, 8, 8),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'ago_2025_3',
        titulo: 'Fecha Límite para que el RENIEC remita al JNE los Padrones de Electores Afiliados',
        fecha: DateTime(2025, 8, 16),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // SEPTIEMBRE 2025
      EventoElectoral(
        id: 'sep_2025_1',
        titulo: 'Fecha Límite para que la DNROP remita al RENIEC la información para la Elaboración de los Padrones de Electores No Afiliados',
        fecha: DateTime(2025, 9, 1),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'sep_2025_2',
        titulo: 'Fecha Límite para que el RENIEC remita al JNE los Padrones de Electores No Afiliados',
        fecha: DateTime(2025, 9, 8),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'sep_2025_3',
        titulo: 'Creación del Padrón Electoral',
        fecha: DateTime(2025, 9, 16),
        tipo: TipoEvento.otro,
      ),

      // OCTUBRE 2025
      EventoElectoral(
        id: 'oct_2025_1',
        titulo: 'Fecha Límite para la Aprobación del Uso de los Padrones para Elecciones Primarias y Formalización de Padrones de las Alianzas Electorales',
        fecha: DateTime(2025, 10, 14),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'oct_2025_2',
        titulo: 'Fecha Límite para que los Candidatos queden Inscritos para participar en Elecciones Primarias',
        fecha: DateTime(2025, 10, 19),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'oct_2025_3',
        titulo: '🗳️ Día de las Elecciones Primarias (Modalidades A y B)',
        fecha: DateTime(2025, 10, 31),
        tipo: TipoEvento.eleccion,
      ),

      // NOVIEMBRE 2025
      EventoElectoral(
        id: 'nov_2025_1',
        titulo: '🗳️ Día para que los Afiliados elijan Delegados (Modalidad C)',
        fecha: DateTime(2025, 11, 13),
        tipo: TipoEvento.eleccion,
      ),
      EventoElectoral(
        id: 'nov_2025_2',
        titulo: '🗳️ Día de la Elección de Candidatos por parte de los Delegados (Modalidad C)',
        fecha: DateTime(2025, 11, 30),
        tipo: TipoEvento.eleccion,
      ),

      // DICIEMBRE 2025
      EventoElectoral(
        id: 'dic_2025_1',
        titulo: 'Fecha Límite de Remisión del Padrón Electoral Preliminar',
        fecha: DateTime(2025, 12, 7),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'dic_2025_2',
        titulo: 'Fecha Límite de Aprobación del Padrón Electoral Definitivo',
        fecha: DateTime(2025, 12, 13),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'dic_2025_3',
        titulo: 'Fecha Máxima para que el JNE proclame resultados de las Elecciones Primarias',
        fecha: DateTime(2025, 12, 15),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'dic_2025_4',
        titulo: 'Fecha Límite para la Presentación de Solicitudes de Inscripción de Fórmulas y Listas de Candidatos',
        fecha: DateTime(2025, 12, 23),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),

      // FEBRERO 2026
      EventoElectoral(
        id: 'feb_2026_1',
        titulo: 'Plazo Máximo para el Sorteo de Miembros de Mesa (ONPE)',
        fecha: DateTime(2026, 2, 1),
        tipo: TipoEvento.sorteo,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'feb_2026_2',
        titulo: 'Fecha Límite para la Publicación de Fórmulas y Listas de Candidatos Admitidas (JNE)',
        fecha: DateTime(2026, 2, 11),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'feb_2026_3',
        titulo: 'Fecha Límite para Resolver Apelaciones sobre Exclusión y Tacha (JNE)',
        fecha: DateTime(2026, 2, 26),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // MARZO 2026
      EventoElectoral(
        id: 'mar_2026_1',
        titulo: 'Fecha Límite para la Renuncia de Candidato(s) y Retiro de Listas',
        fecha: DateTime(2026, 3, 13),
        tipo: TipoEvento.inscripcion,
        esFechaLimite: true,
      ),
      EventoElectoral(
        id: 'mar_2026_2',
        titulo: 'Fecha Límite para Resolver Exclusiones y Tachas en 1ra Instancia',
        fecha: DateTime(2026, 3, 14),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // ABRIL 2026
      EventoElectoral(
        id: 'abr_2026_1',
        titulo: '🗳️ ELECCIONES GENERALES - PRIMERA VUELTA',
        descripcion: 'Elección de Presidente, Vicepresidentes y Congresistas',
        fecha: DateTime(2026, 4, 11),
        tipo: TipoEvento.eleccion,
      ),
      EventoElectoral(
        id: 'abr_2026_2',
        titulo: 'Fecha Límite para Exclusión por Situación Jurídica del Candidato',
        fecha: DateTime(2026, 4, 12),
        tipo: TipoEvento.otro,
        esFechaLimite: true,
      ),

      // JUNIO 2026
      EventoElectoral(
        id: 'jun_2026_1',
        titulo: '🗳️ ELECCIONES GENERALES - SEGUNDA VUELTA',
        descripcion: 'Elección de Presidente y Vicepresidentes (si es necesaria)',
        fecha: DateTime(2026, 6, 7),
        tipo: TipoEvento.eleccion,
      ),
    ];
  }

  // Obtener eventos de un mes específico
  static List<EventoElectoral> getEventosPorMes(int year, int month) {
    return getEventos().where((evento) {
      return evento.fecha.year == year && evento.fecha.month == month;
    }).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  // Obtener próximos eventos
  static List<EventoElectoral> getProximosEventos({int limite = 5}) {
    final ahora = DateTime.now();
    return getEventos()
        .where((evento) => evento.fecha.isAfter(ahora))
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha))
      ..take(limite);
  }

  // Obtener eventos por tipo
  static List<EventoElectoral> getEventosPorTipo(TipoEvento tipo) {
    return getEventos().where((evento) => evento.tipo == tipo).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }
}
