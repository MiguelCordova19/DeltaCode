class InformacionElectoral {
  final String id;
  final String titulo;
  final String categoria;
  final List<SeccionInfo> secciones;
  final String? iconoEmoji;

  InformacionElectoral({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.secciones,
    this.iconoEmoji,
  });
}

class SeccionInfo {
  final String titulo;
  final String? descripcion;
  final List<String> puntos;
  final String? imagenPath;

  SeccionInfo({
    required this.titulo,
    this.descripcion,
    required this.puntos,
    this.imagenPath,
  });
}

class InformacionElectoralData {
  static List<InformacionElectoral> getInformacion() {
    return [
      // INSTRUCCIONES SOBRE LA CÉDULA DE SUFRAGIO
      InformacionElectoral(
        id: 'cedula_sufragio',
        titulo: 'Instrucciones sobre la Cédula de Sufragio',
        categoria: 'Cómo Votar',
        iconoEmoji: '🗳️',
        secciones: [
          SeccionInfo(
            titulo: '¿Qué es la Cédula de Sufragio?',
            descripcion:
                'La cédula de sufragio es el documento oficial donde registras tu voto. Es importante conocer cómo usarla correctamente.',
            puntos: [
              'Es el documento oficial para ejercer tu derecho al voto',
              'Contiene las opciones de candidatos y partidos políticos',
              'Debe ser marcada de forma clara y correcta',
              'Es personal e intransferible',
            ],
          ),
          SeccionInfo(
            titulo: 'Tipos de Cédulas',
            puntos: [
              'Cédula Presidencial: Para elegir Presidente y Vicepresidentes',
              'Cédula Congresional: Para elegir Congresistas de la República',
              'Cédula de Parlamento Andino: Para elegir representantes ante el Parlamento Andino',
            ],
          ),
          SeccionInfo(
            titulo: 'Cómo Marcar tu Voto Correctamente',
            descripcion:
                'Sigue estos pasos para que tu voto sea válido:',
            puntos: [
              '1. Recibe la cédula de sufragio del miembro de mesa',
              '2. Dirígete a la cámara secreta',
              '3. Marca con una X o aspa (✗) dentro del recuadro de tu candidato preferido',
              '4. Marca solo UNA opción por cédula',
              '5. No hagas marcas adicionales ni escribas en la cédula',
              '6. Dobla la cédula para mantener el secreto del voto',
              '7. Deposita la cédula en el ánfora correspondiente',
            ],
          ),
          SeccionInfo(
            titulo: 'Voto en Blanco y Voto Nulo',
            puntos: [
              'VOTO EN BLANCO: No marcas ninguna opción. Es un voto válido que se cuenta.',
              'VOTO NULO: Marcas más de una opción, escribes en la cédula o la dañas. No se cuenta.',
              'VOTO VICIADO: Cédula con marcas que impiden identificar la intención del elector.',
            ],
          ),
          SeccionInfo(
            titulo: 'Errores Comunes a Evitar',
            puntos: [
              '❌ Marcar más de una opción',
              '❌ Escribir nombres o mensajes en la cédula',
              '❌ Hacer dibujos o símbolos adicionales',
              '❌ Romper o dañar la cédula',
              '❌ Marcar fuera del recuadro',
              '❌ Usar marcadores o colores diferentes',
              '✅ Solo marca con una X clara dentro del recuadro de tu preferencia',
            ],
          ),
        ],
      ),

      // RECOMENDACIONES DE SEGURIDAD
      InformacionElectoral(
        id: 'recomendaciones_seguridad',
        titulo: 'Recomendaciones de Seguridad',
        categoria: 'Seguridad Electoral',
        iconoEmoji: '🔒',
        secciones: [
          SeccionInfo(
            titulo: 'Antes de Ir a Votar',
            puntos: [
              'Verifica tu local de votación con anticipación',
              'Lleva tu DNI original y vigente',
              'Revisa el número de tu mesa de sufragio',
              'Planifica tu ruta y horario de llegada',
              'Lleva agua y protección solar si es necesario',
              'No lleves objetos de valor innecesarios',
            ],
          ),
          SeccionInfo(
            titulo: 'En el Local de Votación',
            puntos: [
              'Mantén tu DNI contigo en todo momento',
              'No aceptes indicaciones sobre cómo votar de extraños',
              'Respeta el orden y las filas',
              'No tomes fotografías dentro de la cámara secreta',
              'Mantén la distancia de seguridad con otros electores',
              'Sigue las indicaciones de los miembros de mesa',
              'No ingreses con celulares a la cámara secreta',
            ],
          ),
          SeccionInfo(
            titulo: 'Protege tu Voto',
            puntos: [
              'El voto es secreto: nadie debe ver tu elección',
              'No permitas que te presionen o intimiden',
              'Denuncia cualquier irregularidad a los personeros o autoridades',
              'No aceptes dinero ni regalos a cambio de tu voto',
              'Tu voto es personal: nadie puede votar por ti',
            ],
          ),
          SeccionInfo(
            titulo: 'Después de Votar',
            puntos: [
              'Guarda tu constancia de sufragio',
              'Retírate del local de manera ordenada',
              'No participes en aglomeraciones',
              'Respeta los resultados electorales',
              'Denuncia cualquier irregularidad que hayas presenciado',
            ],
          ),
          SeccionInfo(
            titulo: 'Números de Emergencia',
            puntos: [
              '📞 ONPE: 311-4700',
              '📞 JNE: 311-1700',
              '📞 Policía Nacional: 105',
              '📞 Defensoría del Pueblo: 0800-15170',
              '📞 Línea contra la violencia: 100',
            ],
          ),
        ],
      ),

      // MARCO LEGAL
      InformacionElectoral(
        id: 'marco_legal',
        titulo: 'Marco Legal Electoral',
        categoria: 'Marco Legal',
        iconoEmoji: '⚖️',
        secciones: [
          SeccionInfo(
            titulo: 'Constitución Política del Perú',
            descripcion:
                'Base legal fundamental del sistema electoral peruano',
            puntos: [
              'Artículo 31: Derecho al voto de los ciudadanos mayores de 18 años',
              'Artículo 176: Organización del sistema electoral',
              'Artículo 177: Funciones del Jurado Nacional de Elecciones (JNE)',
              'Artículo 178: Funciones de la ONPE y RENIEC',
              'Artículo 179: Autonomía de los organismos electorales',
            ],
          ),
          SeccionInfo(
            titulo: 'Ley Orgánica de Elecciones (LOE)',
            descripcion: 'Ley N° 26859 - Regula el proceso electoral',
            puntos: [
              'Establece el procedimiento para las elecciones generales',
              'Define los requisitos para ser candidato',
              'Regula la inscripción de candidaturas',
              'Establece el sistema de votación',
              'Define las causales de nulidad del voto',
              'Regula el escrutinio y proclamación de resultados',
            ],
          ),
          SeccionInfo(
            titulo: 'Ley de Partidos Políticos',
            descripcion: 'Ley N° 28094 - Regula la constitución y funcionamiento',
            puntos: [
              'Requisitos para la inscripción de partidos políticos',
              'Democracia interna y elecciones primarias',
              'Financiamiento de partidos políticos',
              'Fiscalización y transparencia',
              'Causales de cancelación de inscripción',
            ],
          ),
          SeccionInfo(
            titulo: 'Ley de Organizaciones Políticas',
            descripcion: 'Ley N° 31792 - Nueva ley de organizaciones políticas',
            puntos: [
              'Moderniza el sistema de partidos políticos',
              'Establece nuevos requisitos de inscripción',
              'Regula las alianzas electorales',
              'Fortalece la democracia interna',
              'Mejora los mecanismos de fiscalización',
            ],
          ),
          SeccionInfo(
            titulo: 'Delitos Electorales',
            descripcion:
                'Conductas sancionadas por el Código Penal',
            puntos: [
              'Compra y venta de votos (Art. 354)',
              'Perturbación o impedimento del proceso electoral (Art. 355)',
              'Atentado contra el derecho de sufragio (Art. 356)',
              'Fraude en inscripción de electores (Art. 357)',
              'Falsificación de documentos electorales (Art. 358)',
              'Penas: Prisión de 1 a 8 años según la gravedad',
            ],
          ),
          SeccionInfo(
            titulo: 'Derechos del Elector',
            puntos: [
              'Derecho a votar libremente y en secreto',
              'Derecho a ser informado sobre candidatos y propuestas',
              'Derecho a fiscalizar el proceso electoral',
              'Derecho a presentar quejas y denuncias',
              'Derecho a recibir constancia de sufragio',
              'Derecho a no ser discriminado',
            ],
          ),
          SeccionInfo(
            titulo: 'Obligaciones del Elector',
            puntos: [
              'Votar es obligatorio para mayores de 18 años hasta los 70 años',
              'Presentar DNI original y vigente',
              'Respetar el orden en el local de votación',
              'No alterar el proceso electoral',
              'Multa por no votar: Varía según el distrito (aprox. S/ 92.00)',
            ],
          ),
          SeccionInfo(
            titulo: 'Organismos Electorales',
            puntos: [
              'JNE (Jurado Nacional de Elecciones): Máxima autoridad electoral',
              'ONPE (Oficina Nacional de Procesos Electorales): Organiza y ejecuta',
              'RENIEC (Registro Nacional de Identificación): Elabora el padrón electoral',
            ],
          ),
        ],
      ),

      // INFORMACIÓN ADICIONAL: MIEMBROS DE MESA
      InformacionElectoral(
        id: 'miembros_mesa_info',
        titulo: 'Información para Miembros de Mesa',
        categoria: 'Miembros de Mesa',
        iconoEmoji: '👥',
        secciones: [
          SeccionInfo(
            titulo: '¿Qué es un Miembro de Mesa?',
            descripcion:
                'Los miembros de mesa son ciudadanos sorteados para garantizar la transparencia del proceso electoral',
            puntos: [
              'Son elegidos por sorteo público',
              'Deben ser ciudadanos en ejercicio',
              'Es una función obligatoria y remunerada',
              'Reciben capacitación previa',
            ],
          ),
          SeccionInfo(
            titulo: 'Funciones Principales',
            puntos: [
              'Verificar la identidad de los electores',
              'Entregar las cédulas de sufragio',
              'Garantizar el secreto del voto',
              'Realizar el conteo de votos (escrutinio)',
              'Firmar las actas electorales',
              'Custodiar el material electoral',
            ],
          ),
          SeccionInfo(
            titulo: 'Derechos del Miembro de Mesa',
            puntos: [
              'Recibir capacitación gratuita',
              'Recibir refrigerio durante la jornada',
              'Recibir pago por su función (S/ 120.00 aprox.)',
              'Justificación laboral automática',
              'Certificado de participación',
            ],
          ),
          SeccionInfo(
            titulo: 'Causales de Excusa',
            puntos: [
              'Ser mayor de 70 años',
              'Estar enfermo (certificado médico)',
              'Vivir a más de 3 horas del local de votación',
              'Tener impedimento físico',
              'Ser personal de salud en servicio',
              'Ser miembro de las Fuerzas Armadas o PNP en servicio',
            ],
          ),
          SeccionInfo(
            titulo: 'Sanciones por Incumplimiento',
            puntos: [
              'Multa económica (aprox. S/ 230.00)',
              'Impedimento para realizar trámites públicos',
              'Registro en el sistema electoral',
            ],
          ),
        ],
      ),
    ];
  }

  // Obtener información por categoría
  static List<InformacionElectoral> getPorCategoria(String categoria) {
    return getInformacion()
        .where((info) => info.categoria == categoria)
        .toList();
  }

  // Obtener todas las categorías
  static List<String> getCategorias() {
    return getInformacion().map((info) => info.categoria).toSet().toList();
  }

  // Buscar información
  static List<InformacionElectoral> buscar(String query) {
    final queryLower = query.toLowerCase();
    return getInformacion().where((info) {
      return info.titulo.toLowerCase().contains(queryLower) ||
          info.categoria.toLowerCase().contains(queryLower) ||
          info.secciones.any((seccion) =>
              seccion.titulo.toLowerCase().contains(queryLower) ||
              seccion.puntos
                  .any((punto) => punto.toLowerCase().contains(queryLower)));
    }).toList();
  }
}
