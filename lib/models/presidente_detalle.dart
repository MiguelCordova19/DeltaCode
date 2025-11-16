class PresidenteDetalle {
  final String nombre;
  final String periodo;
  final bool mandatoCorto;
  final List<String> puntosPositivos;
  final List<String> puntosNegativos;

  PresidenteDetalle({
    required this.nombre,
    required this.periodo,
    required this.mandatoCorto,
    required this.puntosPositivos,
    required this.puntosNegativos,
  });

  static final Map<String, PresidenteDetalle> detalles = {
    'Valentín Paniagua': PresidenteDetalle(
      nombre: 'Valentín Paniagua',
      periodo: '2000-2001 (Transitorio)',
      mandatoCorto: true,
      puntosPositivos: [
        'Gobierno de transición democrático que restauró instituciones tras la caída de Fujimori',
        'Convocó elecciones justas en 2001',
        'Promovió la reconciliación nacional, apoyando la Comisión de la Verdad',
      ],
      puntosNegativos: [
        'Mandato muy corto (unos 8 meses), limitando reformas profundas',
        'Recursos limitados y gran herencia de crisis institucional y económica',
        'No pudo resolver problemas estructurales de pobreza de manera significativa en tan poco tiempo',
      ],
    ),
    'Alejandro Toledo': PresidenteDetalle(
      nombre: 'Alejandro Toledo',
      periodo: '2001-2006',
      mandatoCorto: false,
      puntosPositivos: [
        'Crecimiento económico sostenido (el PBI creció varias veces) y modernización del Estado',
        'Reducción inicial de la pobreza (según estudios, la pobreza empieza a caer en su periodo)',
        'Apertura internacional: firmó acuerdos comerciales y promovió la inversión extranjera',
        'Mejora del Índice de Desarrollo Humano (parte del "milagro peruano" 2001-2010)',
      ],
      puntosNegativos: [
        'Desigualdad persistente: aunque creció la economía, no todos se beneficiaron por igual',
        'Críticas neoliberales por su modelo económico',
        'Problemas de corrupción asociados a su nombre, más evidentes luego, que debilitaron su legado',
        'Déficit fiscal en algunos años',
      ],
    ),
    'Alan García': PresidenteDetalle(
      nombre: 'Alan García',
      periodo: '2006-2011',
      mandatoCorto: false,
      puntosPositivos: [
        'Muy buen crecimiento económico coincidiendo con el "boom" de materias primas',
        'Reducción significativa de la pobreza (pasó de ~48.7% en 2005 a cerca de 30% en 2010)',
        'Aumento de la inversión extranjera (minería, energía)',
        'Estabilidad macroeconómica (inflación moderada y reservas)',
      ],
      puntosNegativos: [
        'Conflictos sociales (minería, comunidades indígenas, medio ambiente)',
        'Corrupción: su administración fue señalada por malas prácticas',
        'Institucionalidad débil',
        'Modelo de crecimiento muy dependiente del "boom" global de minerales',
      ],
    ),
    'Ollanta Humala': PresidenteDetalle(
      nombre: 'Ollanta Humala',
      periodo: '2011-2016',
      mandatoCorto: false,
      puntosPositivos: [
        'Impulso social: fortaleció programas sociales, subió el salario mínimo, reforzó salud y pensiones',
        'Contribuyó a una caída significativa de la pobreza',
        'Inversión en educación (infraestructura y capacitación docente)',
        'Continuidad del crecimiento económico con énfasis inclusivo',
      ],
      puntosNegativos: [
        'Protestas sociales, especialmente por proyectos mineros en zonas rurales',
        'No cumplió plenamente sus promesas más radicales; su discurso se moderó',
        'Acusaciones de corrupción (por ejemplo, Odebrecht)',
        'Desigualdad persistente, con brechas notables en áreas rurales',
      ],
    ),
    'Pedro Pablo Kuczynski': PresidenteDetalle(
      nombre: 'Pedro Pablo Kuczynski',
      periodo: '2016-2018 (Renuncia)',
      mandatoCorto: true,
      puntosPositivos: [
        'Enfoque pragmático y técnico: buscó inversión, desarrollo de infraestructura, salud y educación',
        'Relaciones internacionales sólidas y diversificación de mercados',
        'Reforma y discurso anticorrupción, al menos en parte',
      ],
      puntosNegativos: [
        'Gran inestabilidad política por constantes choques con el Congreso',
        'Escándalos de corrupción (Odebrecht) que llevaron a crisis de credibilidad',
        'Renunció antes de completar su mandato',
      ],
    ),
    'Martín Vizcarra': PresidenteDetalle(
      nombre: 'Martín Vizcarra',
      periodo: '2018-2020 (Vacancia)',
      mandatoCorto: true,
      puntosPositivos: [
        'Impulsó la lucha contra la corrupción y promovió reformas institucionales para mayor transparencia',
        'Trató de fortalecer las entidades estatales para reducir la corrupción',
        'Popularidad como presidente "técnico", alejado del partidismo tradicional',
      ],
      puntosNegativos: [
        'Choques con el Congreso que obstaculizaron reformas',
        'Críticas por "autoritarismo" en medidas ejecutivas',
        'Fue vacado por el Congreso, generando una crisis institucional',
      ],
    ),
    'Manuel Merino': PresidenteDetalle(
      nombre: 'Manuel Merino',
      periodo: 'Noviembre 2020 (5 días)',
      mandatoCorto: true,
      puntosPositivos: [
        'Permitió una transición rápida tras la vacancia de Vizcarra',
      ],
      puntosNegativos: [
        'Gobierno muy breve, casi sin políticas implementadas',
        'Su asunción desencadenó protestas masivas y fue criticado por represión',
        'Falta de legitimidad para gobernar a mediano plazo',
      ],
    ),
    'Francisco Sagasti': PresidenteDetalle(
      nombre: 'Francisco Sagasti',
      periodo: '2020-2021 (Transitorio)',
      mandatoCorto: true,
      puntosPositivos: [
        'Gobierno de transición importante para estabilizar la crisis política',
        'Enfoque técnico y moderado, con poca politización',
        'Mantuvo la gobernabilidad y organizó nuevas elecciones sin caer en más caos institucional',
      ],
      puntosNegativos: [
        'Limitaciones por su carácter transitorio; no pudo hacer cambios estructurales fuertes',
        'Legitimidad política menor, al no ser elegido para un mandato regular por toda la población',
      ],
    ),
    'Pedro Castillo Terrones': PresidenteDetalle(
      nombre: 'Pedro Castillo Terrones',
      periodo: '2021-2022 (Vacancia)',
      mandatoCorto: true,
      puntosPositivos: [
        'Representación simbólica de sectores rurales y tradicionalmente marginados',
        'Promesa de cambios estructurales en educación, salud y descentralización',
        'Mayor enfoque en políticas sociales y redistributivas (al menos en discurso)',
      ],
      puntosNegativos: [
        'Inestabilidad política muy alta: choques constantes con el Congreso que paralizaron muchas políticas',
        'Intento de autogolpe en diciembre de 2022',
        'Acusaciones de corrupción y gestión cuestionable',
        'Dificultad para traducir sus promesas en acciones concretas',
      ],
    ),
    'Dina Boluarte Zegarra': PresidenteDetalle(
      nombre: 'Dina Boluarte Zegarra',
      periodo: '2022-2025',
      mandatoCorto: true,
      puntosPositivos: [
        'Asumió en un momento muy complejo, permitiendo cierta continuidad institucional',
        'Mantenimiento del aparato del Estado, evitando un colapso institucional inmediato',
        'Tratamiento técnico de algunas tensiones políticas',
      ],
      puntosNegativos: [
        'Altísima polarización y legitimidad cuestionada por parte de la población',
        'Problemas de gobernabilidad, enfrentando protestas y críticas por represión',
        'Acusaciones de corrupción y mala administración',
        'Dificultad para impulsar reformas grandes con una base política débil',
      ],
    ),
    'José Enrique Jerí Oré': PresidenteDetalle(
      nombre: 'José Enrique Jerí Oré',
      periodo: 'Desde 2025 (Interino)',
      mandatoCorto: true,
      puntosPositivos: [
        'Puede actuar como figura de transición para estabilizar el poder hasta nuevas elecciones',
        'Su posición puede facilitar negociaciones políticas para evitar más crisis institucionales',
      ],
      puntosNegativos: [
        'Su mandato interino puede ser visto como débil o provisional',
        'Pocas capacidades para reformas estructurales',
        'Dependencia del Congreso para gobernar y tomar decisiones clave',
        'Riesgo de baja legitimidad o respaldo popular, lo que puede limitar su acción',
      ],
    ),
  };
}
