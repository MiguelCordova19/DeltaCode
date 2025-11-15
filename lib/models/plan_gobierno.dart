class PlanGobierno {
  final String partidoId;
  final String partidoNombre;
  final Map<String, List<String>> categorias;
  final String? anio;
  final String? ambito;
  final String? nota;

  PlanGobierno({
    required this.partidoId,
    required this.partidoNombre,
    required this.categorias,
    this.anio,
    this.ambito,
    this.nota,
  });

  // Verificar si el plan es del año actual (2026)
  bool get esActual => anio == '2026' || anio == null;

  // Obtener mensaje de advertencia si no es actual
  String? get mensajeAdvertencia {
    if (esActual) return null;
    return nota ?? 'Plan de gobierno de $anio. Plan 2026 en proceso de carga.';
  }

  // Obtener propuestas de una categoría específica
  List<String> getPropuestas(String categoria) {
    return categorias[categoria] ?? [];
  }

  // Obtener todas las categorías disponibles
  List<String> getCategorias() {
    return categorias.keys.toList();
  }

  // Base de datos de planes de gobierno
  static final Map<String, PlanGobierno> _planes = {
    'accion_popular': PlanGobierno(
      partidoId: 'accion_popular',
      partidoNombre: 'Acción Popular',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Crear 5 millones de empleos formales en 5 años e impulsar la reactivación económica.',
          'Fortalecer PYMES con asistencia técnica y crédito barato para potenciar el mercado externo.',
          'Implementar reforma tributaria para lograr justicia social y reconstruir los ahorros públicos.',
          'Reconstruir ahorros públicos y retomar el manejo responsable de la deuda pública.',
          'Reducir la informalidad económica y laboral, e incentivar la actividad formal.',
          'Combatir monopolios y oligopolios, y promover la libre competencia.',
          'Cerrar las brechas de infraestructura y de inequidad en la distribución de la riqueza.',
        ],
        'Educación': [
          'Invertir 10% del PBI en educación y adoptar estándares de calidad de la OECD.',
          'Potenciar la teleeducación a nivel nacional con mejor infraestructura y enfoque en TICs.',
          'Vincular currículos universitarios con necesidades empresariales para evitar el desempleo.',
          'Implantar la meritocracia y becas completas para los mejores alumnos en todos los niveles.',
          'Fortalecer currícula con educación cívica, artes y enseñanza del quechua para potenciar identidad.',
          'Otorgar becas en el extranjero para especialización de estudiantes y promover su retorno.',
        ],
        'Salud': [
          'Fortalecer la infraestructura y equipamiento hospitalario para superar la crisis sanitaria.',
          'Garantizar el acceso universal a salud integral descentralizada y priorizar la medicina preventiva.',
          'Abaratar medicinas (exoneración IGV/ISC) e impulsar la Telemedicina para reducir brechas.',
          'Cubrir déficit de médicos especialistas con mejor infraestructura, capacitación e incentivos.',
          'Erradicar la desnutrición y anemia infantil, fortaleciendo programas y postas médicas.',
          'Modernizar logística y sistematizar control de gastos para evitar corrupción en compras de salud.',
          'Asegurar la compra y realizar vacunación masiva contra el COVID-19 apenas sea posible.',
        ],
        'Seguridad': [
          'Usar inteligencia policial y voluntad política contra crimen organizado y narcotráfico.',
          'Luchar contra la corrupción política/económica y reinstalar la honestidad en la función pública.',
          'Control directo de narcotráfico en puertos/aeropuertos con convenios con la DEA.',
          'Reforma carcelaria: convertir cárceles en centros productivos aislados de las ciudades.',
          'Desarrollar políticas para mitigar todo tipo de violencia familiar, especial a la mujer.',
          'Interconectar cámaras de vigilancia en línea con patrulleros para interceptar al delincuente.',
          'Evaluar mandos medios en licitaciones para detectar y vigilar actos de corrupción.',
        ],
        'Visión País': [
          'Reinstalar la honestidad, veracidad y laboriosidad ("Ama Sua, Ama Llulla, Ama Quella").',
          'Proponer un nuevo pacto social y debatir una nueva Constitución o cambios específicos.',
          'Fortalecer la institucionalidad y estabilizar la gobernanza en los ámbitos regional y nacional.',
          'Impulsar la reforma judicial estructural para tener una justicia honesta y confiable.',
          'Priorizar e instalar servicios de agua y desagüe para toda la población peruana.',
          'Proteger derechos civiles, garantizando libertad de expresión, asociación y protesta.',
          'Estrategia a mediano plazo para innovación/productividad basada en ciencia, tecnología y educación.',
        ],
      },
    ),
    'alianza_progreso': PlanGobierno(
      partidoId: 'alianza_progreso',
      partidoNombre: 'Alianza Para el Progreso',
      anio: '2019-2022',
      ambito: 'Lima Metropolitana',
      nota: 'Plan municipal 2019-2022. Plan nacional 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Desarrollar nuevas áreas industriales y comerciales en Lima con un servicio de alta calidad.',
          'Ejecutar política de revitalización y modernización de los mercados tradicionales distritales.',
          'Simplificar trámites administrativos para la apertura de locales comerciales en el municipio.',
          'Impulsar un programa de formalización comercial y reubicar el comercio informal.',
          'Impulsar acciones para atraer nuevas inversiones que promuevan el desarrollo de la ciudad.',
        ],
        'Seguridad': [
          'Integrar en tiempo real el Centro de Monitoreo de Seguridad de Lima con todos los distritos.',
          'Promocionar la incorporación de cámaras privadas a la red de monitoreo (\'Adopta una Cámara\').',
          'Implementar el \'Serenazgo sin Fronteras\' para apoyar a distritos con menor capacidad.',
          'Disponer que el Serenazgo realice labores de Inteligencia urbana, mimetizándose en focos delictivos.',
          'Elaborar el \'Mapa del Delito\' de Lima Metropolitana para acciones adecuadas.',
          'Crear un Centro Metropolitano de entrenamiento y un registro único de Serenos.',
          'Implementar un servicio municipal de apoyo legal a víctimas de inseguridad ciudadana.',
        ],
        'Visión País': [
          'Ser una capital turística vertebradora del sistema de ciudades turísticas del Perú.',
          'Impulsar un turismo diversificado en cultura, gastronomía y negocios como nuevos motores.',
          'Exigir y coordinar con el gobierno central la transferencia de funciones de Gobierno Regional.',
          'Crear la oficina de internacionalización para posicionar la capital en el mapa mundial.',
          'Garantizar el acceso de ciudadanos a servicios municipales a través de medios digitales (Gobierno Electrónico).',
        ],
        'Educación': [
          'Información no disponible en el plan municipal. Plan nacional 2026 en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible en el plan municipal. Plan nacional 2026 en proceso de carga.',
        ],
      },
    ),
    'ahora_nacion': PlanGobierno(
      partidoId: 'ahora_nacion',
      partidoNombre: 'Ahora Nación',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Política económica estable que aliente el crecimiento a través de inversión privada y pública.',
          'Aumentar la inversión pública y privada. Mantener la libertad cambiaria y de comercio exterior.',
          'Mantener el equilibrio de cuentas fiscales y la autonomía de la política monetaria.',
          'Acumular reservas en ciclos positivos para aplicar política fiscal contracíclica si es necesario.',
          'Impulsar la formalización y emprendimiento con un modelo de \'Capitalismo Ético\'.',
          'Modernizar y simplificar la gestión pública; mejorar la confiabilidad de la información estadística.',
        ],
        'Educación': [
          'Invertir el 6% del PBI en educación con énfasis en la primera infancia y educación técnica.',
          'Fortalecer la educación técnico-productiva para generar mano de obra cualificada.',
          'Implementar la \'Universidad y el Tecnológico sin fronteras\' para acceso global al conocimiento.',
          'Priorizar el desarrollo de las habilidades cognitivas y blandas desde la primera infancia.',
          'Reformar la carrera pública magisterial para atraer a los mejores talentos y retenerlos.',
          'Promover la investigación científica y tecnológica con incentivos en universidades públicas y privadas.',
        ],
        'Salud': [
          'Lograr la cobertura universal de salud con el Seguro Integral de Salud (SIS) como eje principal.',
          'Reestructurar y modernizar la red de atención primaria y hospitalaria a nivel nacional.',
          'Reducir las brechas de personal médico y paramédico especializado en las regiones.',
          'Promover la Telemedicina para llevar servicios de salud a zonas remotas y de menor acceso.',
          'Crear un programa nacional para combatir la anemia y la desnutrición crónica infantil.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción y el crimen organizado transnacional (tráfico, minería ilegal).',
          'Fortalecer la capacidad operativa, logística y de inteligencia de la Policía Nacional del Perú.',
          'Reforma integral del sistema de justicia penal para lograr celeridad y eficacia contra el delito.',
          'Promover la \'Justicia de Paz\' y mecanismos alternativos de solución de conflictos.',
          'Implementar un plan de seguridad ciudadana con participación vecinal y tecnología integrada.',
        ],
        'Visión País': [
          'Promover la \'Gran Unidad Nacional\' basada en el consenso y el diálogo político.',
          'Reformar la Constitución y el sistema político para lograr una gobernabilidad estable.',
          'Establecer una política exterior soberana que defienda los intereses económicos y comerciales.',
          'Lucha contra la corrupción priorizando la ética en la función pública y la meritocracia.',
          'Implementar la descentralización fiscal para mayor autonomía y gestión de los gobiernos locales.',
          'Garantizar la protección del medio ambiente y la gestión sostenible de los recursos naturales.',
        ],
      },
    ),
    'avanza_pais': PlanGobierno(
      partidoId: 'avanza_pais',
      partidoNombre: 'Avanza País - Partido de Integración Social',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Preservar fortaleza macroeconómica y grado de inversión; continuar política fiscal y monetaria expansiva.',
          'Regresar a la senda de crecimiento alto (5-6% anual) para generar empleo y reducir pobreza.',
          'Formalizar el capital físico e intelectual del sector informal para desarrollar su potencial.',
          'Crear un fondo soberano de riqueza para invertir en infraestructura y capital semilla.',
          'Modificar ley laboral para fomentar empleo juvenil e incentivar la formación en el empleo.',
          'Formalizar propiedades de peruanos para crear capital, atraer inversión y reducir riesgos.',
          'Reactivar 4 proyectos paralizados y relanzar proyectos especiales de inversión.',
        ],
        'Educación': [
          'Incrementar y mejorar la infraestructura educativa y su equipamiento.',
          'Impulsar reforma curricular y desarrollar un modelo para garantizar calidad educativa.',
          'Formación y evaluación frecuente de profesores; mejorar condiciones remunerativas.',
        ],
        'Salud': [
          'Aumentar progresivamente el presupuesto en Salud hasta niveles latinoamericanos.',
          'Lograr cobertura no menor al 90% de la población con servicios públicos de salud.',
          'Implementar una política pública para enfrentar calamidades sanitarias (ej. pandemias).',
        ],
        'Seguridad': [
          'Fortalecer la actuación multinivel (Ejecutivo, Regiones, Locales) contra la delincuencia.',
          'Modernizar Fuerzas Armadas y Policía Nacional para la eficiencia y eficacia de su misión.',
          'Adecuar la legislación vigente para afrontar riesgos y amenazas a la seguridad nacional.',
        ],
        'Visión País': [
          'Derribar muros que separan a los peruanos informales de los formales (Integración Social).',
          'Simplificar la ley: reingeniería legal para facilitar el ingreso legal al mundo empresarial.',
          'Luchar contra la corrupción eliminando la anonimidad en la contratación pública.',
          'Implementar sistema de mejora regulatoria para optimizar las regulaciones públicas.',
          'Designar jueces y fiscales con base en la experiencia previa en función jurisdiccional.',
          'Reforma del sistema previsional: cuentas individuales y pensión digna para todos.',
        ],
      },
    ),
    'batalla_peru': PlanGobierno(
      partidoId: 'batalla_peru',
      partidoNombre: 'Batalla Perú',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Estabilidad jurídica y promoción de la inversión para un desarrollo económico inclusivo.',
          'Implementar un plan de reactivación que priorice el consumo interno y la producción regional.',
          'Impulsar Proyectos de Inversión Estratégica (PEI) para conectar al país con mercados globales.',
          'Creación de zonas económicas especiales con incentivos fiscales para atraer inversiones.',
          'Fortalecer la micro y pequeña empresa (MYPE) con acceso a crédito y capacitación técnica.',
          'Desarrollo de corredores logísticos y multimodales de clase mundial.',
        ],
        'Educación': [
          'Invertir en la mejora de la infraestructura y equipamiento educativo a nivel nacional.',
          'Desarrollo de currículos regionales adaptados a las necesidades productivas de cada zona.',
          'Capacitación continua y mejora de las condiciones laborales de los docentes.',
          'Impulso a la educación tecnológica y formación dual para la inserción laboral.',
          'Búsqueda de la universalización del acceso a internet en los centros educativos.',
        ],
        'Salud': [
          'Fortalecimiento de los sistemas de atención primaria y medicina preventiva en regiones.',
          'Modernización y equipamiento de hospitales regionales y postas médicas.',
          'Aumento del personal de salud especializado y mejora de sus remuneraciones.',
          'Implementar un sistema de salud descentralizado y articulado para la atención de emergencias.',
        ],
        'Seguridad': [
          'Articulación de esfuerzos entre la Policía Nacional, serenazgo y juntas vecinales.',
          'Implementación de tecnología para la vigilancia y prevención del delito (cámaras, drones).',
          'Reestructuración y modernización de la Policía Nacional con énfasis en inteligencia.',
          'Plan integral de prevención de la violencia juvenil en zonas de alto riesgo.',
          'Reforma del sistema penitenciario para la reinserción social y productiva de internos.',
        ],
        'Visión País': [
          'Descentralización real con transferencia de competencias y presupuestos a las regiones.',
          'Promover una gestión pública eficiente, moderna y orientada a resultados.',
          'Fortalecimiento de la unidad nacional basado en el diálogo y respeto a las identidades.',
          'Lucha frontal contra la corrupción con transparencia y rendición de cuentas.',
          'Reforma del Estado para mejorar la calidad de los servicios públicos en todos los niveles.',
        ],
      },
    ),
    'fe_peru': PlanGobierno(
      partidoId: 'fe_peru',
      partidoNombre: 'Fe en el Perú',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Impulsar inversión pública y privada con reglas claras y simplificación de trámites.',
          'Desarrollo de proyectos estratégicos de infraestructura (carreteras, puertos, digitalización).',
          'Fomentar la innovación y el desarrollo tecnológico con incentivos tributarios (I+D).',
          'Formalizar y fortalecer a MYPES, promoviendo cooperativas productivas.',
          'Plan Nacional de Agricultura Competitiva, riego tecnificado y acceso a mercados.',
          'Desarrollo de cadenas productivas en agroindustria, pesca, turismo y minería sostenible.',
        ],
        'Educación': [
          'Aumentar el presupuesto en educación para reducir brechas de calidad e infraestructura.',
          'Mejora de la infraestructura educativa y equipamiento con enfoque tecnológico.',
          'Revalorización de la carrera docente con formación continua, evaluación y mejores sueldos.',
          'Promover la educación técnico-productiva y la empleabilidad juvenil.',
          'Implementar currículo nacional que incluya educación cívica, ética y en valores.',
        ],
        'Salud': [
          'Fortalecer el primer nivel de atención y universalizar la atención primaria.',
          'Mejorar la infraestructura hospitalaria y dotar de equipamiento moderno.',
          'Asegurar el acceso a medicamentos de calidad a precios asequibles.',
          'Plan Nacional de lucha contra la anemia y la desnutrición crónica infantil.',
          'Desarrollo de la Telemedicina para acercar servicios a zonas rurales.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción y el crimen organizado.',
          'Modernización de la Policía Nacional: tecnología, capacitación y mejores condiciones.',
          'Implementar el control territorial con inteligencia y acción coordinada de Fuerzas Armadas y Policía.',
          'Fortalecer la seguridad ciudadana con un sistema integrado de videovigilancia nacional.',
          'Reforma del sistema penitenciario para la resocialización efectiva de internos.',
        ],
        'Visión País': [
          'Priorizar el principio \'Primero los que menos tienen\' para reducir brechas sociales.',
          'Lucha frontal contra la corrupción con transparencia y ética en la gestión pública.',
          'Descentralización efectiva con autonomía y transferencia de recursos a gobiernos regionales.',
          'Promover la participación ciudadana en la toma de decisiones y fiscalización.',
          'Reforma del sistema judicial para garantizar una justicia célere, honesta y confiable.',
          'Impulso del Gobierno Electrónico para servicios públicos más eficientes y transparentes.',
        ],
      },
    ),
    'fuerza_popular': PlanGobierno(
      partidoId: 'fuerza_popular',
      partidoNombre: 'Fuerza Popular',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Estabilidad macroeconómica y promover la inversión privada para la generación de empleo.',
          'Implementar un Plan de Rescate y Reconstrucción Nacional, con foco en el empleo juvenil.',
          'Reducir la informalidad laboral del 70% al 45% mediante incentivos y simplificación.',
          'Crear el \'Fondo de Estabilización y Rescate\' para proteger los empleos formales en crisis.',
          'Reestructurar y modernizar la gestión de las empresas estatales (Electroperú, Petroperú, etc.).',
          'Acelerar la inversión pública y ejecución de proyectos de infraestructura grandes y pequeños.',
          'Desarrollar una nueva ley de MYPES con incentivos tributarios y acceso a financiamiento.',
        ],
        'Educación': [
          'Invertir el 6% del PBI en educación con énfasis en la educación técnico-productiva.',
          'Modernizar la infraestructura educativa con acceso a internet y tecnología en zonas rurales.',
          'Revalorización de la carrera docente con meritocracia, capacitación y aumento salarial.',
          'Reforma curricular: más horas de matemática, comunicación, ética y educación cívica.',
          'Garantizar la alimentación escolar (Qali Warma) y el acceso a becas de estudio superior.',
        ],
        'Salud': [
          'Universalización del acceso a la salud con un Sistema Unificado de Salud (SIS-ESSALUD).',
          'Aumentar el presupuesto en salud hasta un 5% del PBI para infraestructura y recursos humanos.',
          'Priorizar la prevención y el primer nivel de atención de salud en todo el país.',
          'Creación de la \'Policía Sanitaria\' y el \'Sistema Nacional de Vigilancia Epidemiológica\'.',
          'Garantizar la disponibilidad de medicamentos asequibles y de calidad en todo el sector público.',
          'Mejorar las condiciones laborales, sueldos y capacitación del personal de salud.',
        ],
        'Seguridad': [
          'Reforma de la PNP con énfasis en inteligencia, tecnología y lucha contra el crimen organizado.',
          'Dotar a la PNP de recursos logísticos y de tecnología para la vigilancia y prevención del delito.',
          'Impulso del \'Plan Fronteras Seguras\' para el control de la migración y el crimen transnacional.',
          'Reforma del Código Penal y Procesal Penal para endurecer penas y asegurar la celeridad judicial.',
          'Sistema de control y vigilancia en cárceles para evitar la comisión de delitos desde el interior.',
          'Implementar un Plan Nacional contra la Trata de Personas, priorizando mujeres y niños.',
        ],
        'Visión País': [
          'Lucha frontal contra la corrupción, priorizando la meritocracia y la transparencia pública.',
          'Reforma del sistema de justicia para garantizar independencia, probidad y celeridad.',
          'Modernización del Estado y descentralización de competencias y presupuesto (Destrabe).',
          'Garantizar el respeto de la Constitución y las reglas de juego democráticas.',
          'Fomentar la inversión privada en proyectos de desarrollo social y de infraestructura.',
          'Promover acuerdos y entendimiento entre sectores minero, agrario y ambiental para reducir conflictos.',
        ],
      },
    ),
    'juntos_peru': PlanGobierno(
      partidoId: 'juntos_peru',
      partidoNombre: 'Juntos por el Perú',
      anio: '2019-2022',
      ambito: 'Regional - Arequipa',
      nota: 'Plan regional de Arequipa 2019-2022. Plan nacional 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Impulsar la cadena productiva agrícola, agroindustrial, y de la ganadería lechera en Arequipa.',
          'Promover la inversión en proyectos de infraestructura de riego y mejora de suelos agrícolas.',
          'Generar 6,000 nuevos puestos de trabajo formales en actividades productivas de la región.',
          'Crear un \'Fondo de Desarrollo Regional\' para financiar proyectos productivos.',
          'Fortalecer el turismo cultural, ecológico y gastronómico como motor económico regional.',
        ],
        'Educación': [
          'Mejorar la infraestructura educativa y dotación de TICs en zonas rurales y urbanas.',
          'Capacitar y evaluar constantemente a docentes para elevar la calidad educativa regional.',
          'Implementar programas de prevención de violencia escolar y embarazo adolescente.',
          'Promover la educación técnico-productiva y la empleabilidad de jóvenes.',
        ],
        'Salud': [
          'Fortalecer el primer nivel de atención y la prevención de enfermedades en la región.',
          'Mejorar y ampliar la infraestructura hospitalaria y el equipamiento médico.',
          'Implementar programas regionales para combatir la anemia y la desnutrición crónica infantil.',
          'Desarrollar la Telemedicina para la atención especializada en zonas alejadas.',
        ],
        'Seguridad': [
          'Articulación de esfuerzos entre el Gobierno Regional, Policía y municipios contra el crimen.',
          'Implementar un sistema regional de videovigilancia y comunicación unificada.',
          'Programas de prevención del delito y apoyo a jóvenes en riesgo social.',
        ],
        'Visión País': [
          'Lucha frontal contra la corrupción: instalar y fortalecer oficinas de integridad pública.',
          'Capacitación constante del personal del Gobierno Regional para la mejora continua.',
          'Descentralizar la presencia del Gobierno Regional en todas las provincias de Arequipa.',
          'Promover la participación ciudadana en la fiscalización de la gestión regional.',
        ],
      },
    ),
    'libertad_popular': PlanGobierno(
      partidoId: 'libertad_popular',
      partidoNombre: 'Libertad Popular',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Fomentar el emprendimiento empresarial y fortalecer asistencia técnica para PYMES.',
          'Reducir la informalidad a 30% en cinco años mediante incentivos y simplificación.',
          'Desarrollar la agricultura para garantizar la soberanía y seguridad alimentaria.',
          'Reformar el Sistema Nacional de Pensiones para asegurar una pensión básica universal.',
          'Combatir los monopolios y oligopolios, y fortalecer la Defensa del Consumidor.',
          'Establecer contratos laborales estables de media jornada e incentivos tributarios.',
        ],
        'Educación': [
          'Fomentar el emprendimiento desde la escuela y universidad (asistencia y financiamiento PYMES).',
          'Proveer infraestructura, salud y educación para integrar a la población al mercado.',
          'Mejorar la calidad educativa para alcanzar el nivel de ingreso del país.',
        ],
        'Salud': [
          'Erradicar la desnutrición y anemia infantil en el país.',
          'Extender los servicios públicos esenciales de salud a nivel nacional.',
          'Reducir en 50% la brecha de mortalidad infantil entre regiones.',
        ],
        'Seguridad': [
          'Modernizar el Estado para combatir el terror criminal y la delincuencia.',
          'Fortalecer el sistema penitenciario con reforma carcelaria (centros productivos y aislados).',
          'Controlar la delincuencia y fortalecer la seguridad ciudadana.',
          'Garantizar el derecho del efectivo policial a usar fuerza letal en legítima defensa.',
        ],
        'Visión País': [
          'Modernizar el Estado e implementar un nuevo modelo económico basado en la libertad.',
          'Restablecer el equilibrio de poderes y evitar el uso inadecuado de la vacancia.',
          'Impulsar programas de voluntariado cívico inspirados en Cooperación Popular.',
          'Luchar contra los extremos políticos de izquierda y derecha radical.',
        ],
      },
    ),
    'nuevo_peru': PlanGobierno(
      partidoId: 'nuevo_peru',
      partidoNombre: 'Nuevo Perú Por El Buen Vivir',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Reforma tributaria con enfoque de igualdad para resolver los problemas de la gente.',
          'Impulsar la \'Economía Popular\' con un nuevo Programa de Financiamiento para Todos.',
          'Revolución productiva en el agro, priorizando agricultura familiar y pequeña producción.',
          'Rediseño del Banco de la Nación como banca pública de desarrollo (Banca para el Buen Vivir).',
          'Implementar el Nuevo Modelo de Desarrollo Productivo-Ecológico y de Soberanía Alimentaria.',
          'Impulsar el Calendario Nacional de Fiestas y Festividades como circuitos macro-regionales.',
        ],
        'Educación': [
          'Invertir 6% del PBI en educación con énfasis en la educación intercultural y bilingüe.',
          'Garantizar la educación sexual integral (ESI) para prevenir violencia y enfermedades.',
          'Promover la formación superior en artes y educación artística (docentes y escuelas públicas).',
          'Fortalecer el Archivo General de la Nación y crear la Cinemateca y Fonoteca Nacional.',
          'Modificación de la Ley del Libro para la exoneración permanente del impuesto (IGV).',
        ],
        'Salud': [
          'Universalizar el derecho a la salud y fortalecer el primer nivel de atención (medicina preventiva).',
          'Garantizar el acceso a medicamentos y vacunas de forma gratuita.',
          'Revalorizar el conocimiento médico ancestral e incorporarlo al sistema público de salud.',
          'Implementar un Plan Nacional para el Buen Trato, contra la violencia y el maltrato.',
          'Crear el \'Sistema Nacional de Cuidados\' (infancia, discapacidad, vejez) para una vida digna.',
        ],
        'Seguridad': [
          'Seguridad ciudadana y lucha frontal contra la corrupción: \'Perú seguro, Perú honesto\'.',
          'Impulsar la \'Impundidad cero\' con promoción de la integridad pública y reforma anticorrupción.',
          'Implementar un sistema de justicia, reparación y memoria para una paz verdadera.',
          'Fortalecer a la Policía Comunitaria, el Serenazgo y las Juntas Vecinales organizadas.',
        ],
        'Visión País': [
          'Refundación de la Patria para el Allin Kawsay / Suma Qamaña (Buen Vivir).',
          'Un nuevo pacto social para un Perú justo, soberano e intercultural.',
          'Democracia social de los pueblos: una democracia sin mafias al servicio de la gente.',
          'Promover escaños reservados para pueblos originarios en el Congreso y espacios de elección.',
          'Impulsar la participación de pueblos indígenas en la dirección y gestión estatal (cuotas).',
          'Asegurar la soberanía y la defensa nacional ante toda forma de agresión (interna y externa).',
        ],
      },
    ),
    'aprista': PlanGobierno(
      partidoId: 'aprista',
      partidoNombre: 'Partido Aprista Peruano',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Estabilizar la economía y generar 2 millones de empleos en 5 años (Plan de Emergencia Productiva).',
          'Impulsar la inversión privada, mantener estabilidad jurídica y simplificar trámites (Destrabe).',
          'Reformar la legislación laboral para incentivar la formalización y el empleo juvenil.',
          'Promover la asociatividad de productores agrarios y MYPES para aumentar exportaciones.',
          'Implementar un \'Plan Nacional de Infraestructura\' para cerrar brechas de conectividad.',
          'Fomentar la \'Economía Popular\' con microcréditos y promoción de cooperativas.',
        ],
        'Educación': [
          'Invertir 6% del PBI en educación y aumentar el sueldo de los maestros al nivel de un suboficial.',
          'Universalizar el acceso a internet y tecnología para la educación en zonas rurales.',
          'Implementar el bachillerato técnico y carreras universitarias ligadas a la demanda productiva.',
          'Fomentar la investigación científica y tecnológica con financiamiento e incentivos.',
          'Promover una educación cívica y en valores para la formación de ciudadanos.',
        ],
        'Salud': [
          'Universalizar el acceso a la salud con un sistema integrado y articulado (MINSA, ESSALUD).',
          'Aumentar el presupuesto en salud y priorizar la atención primaria y preventiva.',
          'Garantizar el acceso a medicamentos genéricos de calidad a precios asequibles.',
          'Mejorar la infraestructura hospitalaria y las postas médicas en todo el país.',
          'Fortalecer la carrera del personal de salud con mejores remuneraciones y capacitación.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción y el crimen organizado transnacional.',
          'Reforma integral de la Policía Nacional: tecnología, inteligencia y equipamiento.',
          'Reestructuración del INPE y del sistema penitenciario para la reinserción y control.',
          'Implementar el \'Patrullaje sin Fronteras\' entre distritos y Policía Nacional.',
          'Agilizar los procesos judiciales en materia penal para reducir la impunidad.',
        ],
        'Visión País': [
          'Reforma Política y del Estado para fortalecer la gobernabilidad y el sistema de partidos.',
          'Descentralización efectiva con transferencia de funciones, recursos y autonomía regional.',
          'Reorganizar el sector ambiental y mejorar la coordinación en gestión de controversias.',
          'Garantizar la Zonificación Ecológica Económica (ZEE) para el ordenamiento territorial.',
          'Impulsar la meritocracia y la transparencia en la función pública para luchar contra la corrupción.',
        ],
      },
    ),
    'civico_obras': PlanGobierno(
      partidoId: 'civico_obras',
      partidoNombre: 'Partido Cívico Obras',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Promover una economía social de mercado libre de monopolios y oligopolios.',
        ],
        'Educación': [
          'Lograr una educación pública gratuita, de calidad y obligatoria para todos.',
        ],
        'Salud': [
          'Asegurar la prestación de servicios de salud universal, de calidad, y prioritaria.',
        ],
        'Seguridad': [
          'Proponer la no prescripción de los delitos contra el Estado.',
        ],
        'Visión País': [
          'Funcionarios sentenciados por delitos contra el Estado serán inhabilitados a perpetuidad.',
          'Promover una televisión con valores y con sanciones severas a quien incumpla la Ley del Menor.',
          'Asegurar que los medios difundan la cultura y distribuyan equitativamente publicidad estatal.',
        ],
      },
    ),
    'buen_gobierno': PlanGobierno(
      partidoId: 'buen_gobierno',
      partidoNombre: 'Del Buen Gobierno',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Identificación y solución de los desafíos que enfrenta el Perú con integridad y ética.',
          'Desarrollar propuestas de gobierno sólidas que fomenten el diálogo intergeneracional.',
          'Implementar cambios urgentes para edificar un orden político que asegure una vida digna.',
        ],
      },
    ),
    'pte_peru': PlanGobierno(
      partidoId: 'pte_peru',
      partidoNombre: 'Partido de los Trabajadores y Emprendedores PTE-Perú',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Promover la participación política de trabajadores y emprendedores del Perú.',
        ],
      },
    ),
    'democrata_unido': PlanGobierno(
      partidoId: 'democrata_unido',
      partidoNombre: 'Partido Demócrata Unido Perú',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Transformar al Perú en un país líder en tecnología, industria y comercio internacional.',
          'Promover la educación técnica, productiva y empresarial para la competitividad.',
        ],
        'Educación': [
          'Promover una educación técnica y productiva que fomente investigación y la innovación.',
          'Inculcar valores y principios en cada ciudadano para un desarrollo integral.',
        ],
        'Salud': [
          'Implementar políticas que aseguren la justicia social y la igualdad de oportunidades.',
        ],
        'Seguridad': [
          'Combatir la corrupción y promover la transparencia en todos los niveles de gobierno.',
        ],
        'Visión País': [
          'Democracia Participativa - Descentralista con Justicia Social e Identidad Nacional.',
          'Proteger los recursos naturales y el medio ambiente para un desarrollo sostenible.',
          'Fomentar una administración pública descentralizada que responda a necesidades locales.',
          'Incentivar la participación activa de la ciudadanía en la toma de decisiones democráticas.',
        ],
      },
    ),
    'democrata_verde': PlanGobierno(
      partidoId: 'democrata_verde',
      partidoNombre: 'Partido Demócrata Verde',
      anio: '2023-2026',
      ambito: 'Regional - Tacna',
      nota: 'Plan regional de Tacna 2023-2026. Plan nacional 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Generar un Polo de Desarrollo en la Frontera Sur del Perú (Región Tacna).',
          'Impulsar Proyectos Prioritarios interregionales con cofinanciamiento central e inversión extranjera.',
          'Cofinanciar proyectos de impacto regional con el gobierno central, regional y gobiernos locales.',
          'Desarrollar la Zona Norte de Tacna y la zona Sur-Oeste de la Región Puno.',
        ],
        'Educación': [
          'Información no disponible en el plan regional. Plan nacional 2026 en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible en el plan regional. Plan nacional 2026 en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible en el plan regional. Plan nacional 2026 en proceso de carga.',
        ],
        'Visión País': [
          'Transformar Tacna en una Región Fuerte y Pujante con un futuro promisorio.',
          'Lograr que la región Tacna viva en armonía y de manera saludable.',
          'Promover la conciencia en los Objetivos Estratégicos para evitar obstáculos al Desarrollo.',
          'Establecer una alianza con la Región Puno para el desarrollo mutuo.',
        ],
      },
    ),
    'democratico_federal': PlanGobierno(
      partidoId: 'democratico_federal',
      partidoNombre: 'Partido Democrático Federal',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Impulsar un modelo de organización democrático y federal para el Perú.',
        ],
      },
    ),
    'somos_peru': PlanGobierno(
      partidoId: 'somos_peru',
      partidoNombre: 'Partido Democrático Somos Perú',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Impulsar reformas para un crecimiento económico estable, descentralizado y sostenible.',
          'Promover la inversión y el empleo formal, especialmente en regiones.',
          'Fomentar la digitalización y la innovación en micro y pequeñas empresas (MYPE).',
        ],
        'Educación': [
          'Asegurar el acceso universal a servicios de educación de calidad e inclusiva.',
          'Impulsar la formación técnica y profesional con enfoque en la demanda del mercado.',
          'Implementar la educación bilingüe e intercultural respetando la diversidad.',
        ],
        'Salud': [
          'Fortalecer el sistema de salud con enfoque en la atención primaria y prevención.',
          'Garantizar el acceso universal a medicamentos y servicios de salud de calidad.',
          'Mejorar la infraestructura y equipamiento hospitalario a nivel nacional.',
        ],
        'Seguridad': [
          'Fortalecer la seguridad ciudadana con acción integrada de la Policía y gobiernos locales.',
          'Modernizar la Policía Nacional con capacitación y tecnología para combatir el crimen.',
          'Lucha frontal contra el crimen organizado, la delincuencia y la corrupción.',
        ],
        'Visión País': [
          'Poner la acción del Estado al servicio de las personas y sus familias.',
          'Priorizar la justicia, la igualdad y el bienestar con enfoque de sostenibilidad.',
          'Impulsar grandes reformas para dejar atrás flagelos históricos y la desigualdad.',
          'Asegurar desarrollo y bienestar para esta y las futuras generaciones.',
        ],
      },
    ),
    'esperanza_2021': PlanGobierno(
      partidoId: 'esperanza_2021',
      partidoNombre: 'Frente de la Esperanza 2021',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Economía social de mercado con fin del abuso oligopólico.',
          'Reactivación de la economía productiva y autosuficiencia alimentaria.',
          'Reducir drásticamente la informalidad laboral en el Perú.',
          'Competitividad con inversión en infraestructura y reducción de sobrecostos.',
          'Revalorización del trabajo digno y la mano de obra calificada.',
          'Reforma Tributaria, fiscalizando la evasión y elusión de impuestos.',
        ],
        'Educación': [
          'Educación como expresión de justicia social e igualdad de oportunidades.',
          'Priorizar la formación técnica y científica para el desarrollo nacional.',
          'Reforzar el sistema de becas y la educación superior de calidad.',
          'Incorporar educación cívica y formación ciudadana en el currículo escolar.',
        ],
        'Salud': [
          'Universalización de la salud para toda la población peruana.',
          'Fortalecer la atención primaria y la infraestructura de salud en regiones.',
          'Garantizar el acceso a medicamentos de calidad a precios justos.',
          'Incrementar el presupuesto público destinado al sector salud.',
        ],
        'Seguridad': [
          'Derecho a la seguridad ciudadana y respeto irrestricto al orden y la ley.',
          'Lucha frontal contra la corrupción para recuperar valores cívicos y morales.',
          'Fortalecer la institucionalidad y profesionalizar las fuerzas del orden.',
        ],
        'Visión País': [
          'Refundar el Perú y poner fin al sistema de corrupción.',
          'Nuevo pacto social con rescate de valores milenarios.',
          'Afirmación del sistema democrático con mecanismos de democracia directa.',
          'Descentralización con planificación y desarrollo de polos competitivos.',
          'Defensa de la familia como célula básica de la sociedad.',
        ],
      },
    ),
    'integridad_democratica': PlanGobierno(
      partidoId: 'integridad_democratica',
      partidoNombre: 'Integridad Democrática',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Fomentar la formalización y crecimiento de MYPES a través de incentivos tributarios y crediticios.',
          'Promover la inversión responsable, priorizando la tecnología y el valor agregado nacional.',
          'Impulsar la economía popular y solidaria con apoyo técnico y acceso a mercados.',
          'Garantizar la estabilidad macroeconómica con política fiscal y monetaria prudente.',
        ],
        'Educación': [
          'Asegurar el acceso a una educación de calidad e inclusiva a nivel nacional.',
          'Reformar la currícula escolar con énfasis en valores, tecnología, emprendimiento y medio ambiente.',
          'Mejorar la infraestructura educativa y la capacitación de docentes de manera constante.',
        ],
        'Salud': [
          'Fortalecer el primer nivel de atención de salud con enfoque preventivo y comunitario.',
          'Asegurar la universalización del acceso a servicios y medicamentos esenciales de calidad.',
          'Mejorar la infraestructura hospitalaria y las condiciones laborales del personal de salud.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción con Comisión Nacional Independiente de Integridad Pública.',
          'Modernizar el sistema de justicia y seguridad para una respuesta rápida y efectiva.',
          'Descentralizar la PNP y fortalecer la inteligencia para combatir el crimen organizado.',
          'Promover la participación ciudadana en la fiscalización y seguridad local.',
        ],
        'Visión País': [
          'Garantizar la plena vigencia de la democracia y los derechos fundamentales.',
          'Descentralización efectiva que fortalezca la autonomía regional y local.',
          'Modernización digital del Estado para procesos más eficientes y transparentes.',
          'Fomentar la participación ciudadana activa y el presupuesto participativo.',
        ],
      },
    ),
    'partido_morado': PlanGobierno(
      partidoId: 'partido_morado',
      partidoNombre: 'Partido Morado',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Estabilidad, predictibilidad y prudencia en el manejo macroeconómico.',
          'Promoción de la inversión privada nacional y extranjera con reglas claras.',
          'Aumentar la eficacia y calidad de la inversión y el gasto público.',
          'Reforma tributaria progresiva para financiar la agenda social.',
          'Impulsar la formalización laboral y de emprendimientos.',
          'Fortalecer la economía social, solidaria y circular.',
        ],
        'Educación': [
          'Asegurar la educación básica de calidad con énfasis en habilidades digitales y ciudadanas.',
          'Revalorizar la carrera docente con meritocracia y mejores condiciones salariales.',
          'Asegurar la calidad universitaria y superior técnica, enfocada en la innovación.',
          'Cerrar la brecha de infraestructura educativa a nivel nacional.',
        ],
        'Salud': [
          'Reforma y fortalecimiento del primer nivel de atención y prevención.',
          'Universalización del acceso a servicios de salud de calidad e integrales.',
          'Fortalecer la capacidad de respuesta ante emergencias y pandemias.',
          'Mejorar la infraestructura hospitalaria y el acceso a medicamentos esenciales.',
        ],
        'Seguridad': [
          'Fortalecer la seguridad ciudadana con un enfoque de inteligencia y prevención.',
          'Reforma y modernización de la Policía Nacional, mejorando su capacidad operativa.',
          'Lucha frontal contra el crimen organizado y la minería ilegal.',
          'Reforma estructural de la administración de justicia para un sistema confiable.',
        ],
        'Visión País': [
          'Reinstalar la honestidad y la ética en la política y la gestión pública.',
          'Impulsar un nuevo pacto social y la reforma del Estado con descentralización efectiva.',
          'Promover la participación ciudadana y la transparencia gubernamental.',
          'Gobierno abierto y digital para trámites más simples y eficientes.',
        ],
      },
    ),
    'pais_todos': PlanGobierno(
      partidoId: 'pais_todos',
      partidoNombre: 'Partido País para Todos',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Impulsar el liberalismo económico con énfasis en la libertad de mercado.',
          'Reducir drásticamente la intervención y el tamaño del Estado en la economía.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Fomentar el orden y la autoridad con propuestas de \'mano dura\' contra el crimen.',
          'Fortalecer el Estado frente al crimen organizado y la delincuencia.',
        ],
        'Visión País': [
          'Propuesta política de ruptura con el statu quo y la política tradicional (antisistema).',
          'Enfatizar el conservadurismo en temas sociales y la defensa del orden.',
        ],
      },
    ),
    'patriotico_peru': PlanGobierno(
      partidoId: 'patriotico_peru',
      partidoNombre: 'Partido Patriótico del Perú',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Impulsar la descentralización económica para promover el crecimiento regional sostenible.',
          'Aumentar la productividad del agro y la pequeña minería responsable.',
          'Fortalecer la formalización de MYPES mediante el apoyo tecnológico y crediticio.',
          'Desarrollo de infraestructura sostenible: saneamiento, conectividad e internet.',
        ],
        'Educación': [
          'Modernización de la educación con énfasis en ciencia, tecnología e innovación (CTI).',
          'Asegurar el acceso universal a la educación y cerrar la brecha de infraestructura.',
          'Revalorización de la carrera docente con capacitación continua y salarios dignos.',
          'Currícula con enfoque en valores, civismo, patriotismo y habilidades digitales.',
        ],
        'Salud': [
          'Universalización del acceso a servicios de salud y medicamentos de calidad.',
          'Fortalecer el primer nivel de atención y la prevención de enfermedades.',
          'Mejorar la infraestructura de salud y el equipamiento médico a nivel nacional.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción con reformas estructurales en el sistema de justicia.',
          'Fortalecer la seguridad ciudadana con el uso de tecnología e inteligencia policial.',
          'Modernizar la Policía Nacional y mejorar su capacidad de respuesta inmediata.',
        ],
        'Visión País': [
          'Promover una renovación moral del liderazgo político y la ética profesional.',
          'Garantizar el respeto irrestricto a los derechos humanos y la igualdad ante la ley.',
          'Priorizar el interés nacional sobre intereses particulares, partidarios o de grupos de poder.',
          'Gobierno con enfoque de inclusión, incorporando a pueblos originarios y grupos vulnerables.',
        ],
      },
    ),
    'cooperacion_popular': PlanGobierno(
      partidoId: 'cooperacion_popular',
      partidoNombre: 'Partido Político Cooperación Popular',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Promover la inversión y el empleo formal fortaleciendo la pequeña y mediana empresa (PYME).',
          'Impulsar la soberanía alimentaria con tecnificación y apoyo a la agricultura familiar.',
          'Asegurar el uso sostenible de los recursos naturales y la lucha contra actividades ilegales.',
          'Implementar un Plan Nacional de Inversiones que priorice infraestructura clave.',
        ],
        'Educación': [
          'Asegurar el acceso universal a la educación con enfoque en ciencia y tecnología.',
          'Promover programas educativos sobre cambio climático y sostenibilidad ambiental.',
          'Mejorar la calidad educativa con capacitación docente y mejor infraestructura.',
        ],
        'Salud': [
          'Garantizar la universalización de la salud y el acceso a medicinas de calidad.',
          'Fortalecer el sistema de atención primaria y los programas de prevención.',
          'Crear centros de servicios de atención integral a víctimas de violencia.',
        ],
        'Seguridad': [
          'Lucha frontal contra la corrupción con auditorías independientes y sanciones severas.',
          'Fortalecer la seguridad ciudadana con coordinación entre Policía, municipios y sociedad civil.',
          'Implementar programas comunitarios para jóvenes en riesgo para prevenir el crimen.',
          'Promover una cultura de respeto, tolerancia y paz social.',
        ],
        'Visión País': [
          'Construir un Estado más justo, transparente, participativo y eficiente.',
          'Democratizar el Estado con Consejos de Participación y fiscalización ciudadana en tiempo real.',
          'Fomentar la participación ciudadana mediante presupuesto participativo vinculante.',
          'Gobierno austero y responsable, priorizando el gasto social.',
        ],
      },
    ),
    'peru_libre': PlanGobierno(
      partidoId: 'peru_libre',
      partidoNombre: 'Partido Político Nacional Perú Libre',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Fomentar la producción nacional y el consumo interno para generar empleo.',
          'Incentivar la formalización de la MYPE con apoyo crediticio y programas de fomento.',
          'Impulsar la inversión pública en infraestructura vial y productiva estratégica.',
          'Fortalecer la actividad agraria con asistencia técnica, riego tecnificado y créditos.',
          'Promover el desarrollo de la economía popular y solidaria.',
        ],
        'Educación': [
          'Acceso universal y gratuito a la educación en todos los niveles.',
          'Mejorar la infraestructura educativa, equipamiento tecnológico y conectividad.',
          'Revalorizar la carrera docente con capacitación continua y mejores salarios.',
          'Fomentar la educación técnica productiva y la investigación científica.',
        ],
        'Salud': [
          'Universalización de la salud con un sistema único, integrado y descentralizado.',
          'Fortalecer el primer nivel de atención y la prevención de enfermedades.',
          'Asegurar el acceso a medicamentos y equipos médicos de calidad.',
          'Mejorar las condiciones laborales y salariales del personal de salud.',
        ],
        'Seguridad': [
          'Lucha frontal contra la delincuencia y el crimen organizado a nivel nacional.',
          'Fortalecer la Policía Nacional con capacitación, equipamiento y moralización.',
          'Mejorar el sistema penitenciario y promover la reinserción social de internos.',
          'Promover la participación vecinal y las juntas de seguridad ciudadana.',
        ],
        'Visión País': [
          'Promover una nueva Constitución Política para un cambio de modelo de Estado.',
          'Descentralización efectiva con transferencia de funciones y recursos a regiones.',
          'Lucha contra la corrupción y fortalecimiento de la transparencia estatal.',
          'Sistema de rendición de cuentas descentralizado con participación pública.',
        ],
      },
    ),
    'fuerza_moderna': PlanGobierno(
      partidoId: 'fuerza_moderna',
      partidoNombre: 'Partido Político Fuerza Moderna',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Digitalizar procesos administrativos, reducir burocracia y agilizar trámites.',
          'Apoyar a micro, pequeñas y medianas empresas (PYMES) y fomentar el emprendimiento local.',
          'Promover la atracción de inversiones nacionales e internacionales.',
          'Priorizar el gasto nacional en salud, educación e infraestructura.',
          'Impulsar la integración comercial y una economía regional competitiva.',
          'Crear un nuevo pacto fiscal para que regiones reciban más recursos.',
        ],
        'Educación': [
          'Modernizar la infraestructura escolar.',
          'Impulsar la formación continua de docentes.',
          'Establecer incentivos para la excelencia académica.',
          'Implementar programas de intercambio académico.',
          'Apuesta por una educación de primera para todos.',
        ],
        'Salud': [
          'Crear un Sistema Único de Salud (MINSA, EsSalud, Gob. Regionales) para cobertura universal.',
          'Fortalecer la infraestructura sanitaria.',
          'Digitalizar la salud (historia clínica electrónica, telemedicina).',
          'Enfatizar programas preventivos, salud mental y enfermedades crónicas.',
          'Mejorar la gestión de recursos para reducir desabastecimiento de medicamentos.',
        ],
        'Seguridad': [
          'Reforma del sistema judicial para mayor eficiencia e independencia.',
          'Mano dura contra el sicariato, la extorsión y el narcotráfico.',
          'Intervenciones focalizadas de las Fuerzas Armadas en zonas críticas.',
          'Profesionalización y meritocracia en la administración pública.',
          'Fortalecimiento de la fiscalía y reemplazo de jueces/fiscales provisionales.',
          'Promover gobierno abierto para transparencia judicial.',
        ],
        'Visión País': [
          'Reconstruir la confianza promoviendo gestión pública ética, técnica y eficiente.',
          'Garantizar la participación ciudadana activa y consciente en la vida política.',
          'Promover la transparencia y la rendición de cuentas en la gestión pública.',
          'Implementar descentralización real y mayor autonomía para regiones.',
          'Fomentar la sostenibilidad ambiental y el uso responsable de recursos.',
          'Impulsar la innovación y la creatividad institucional.',
        ],
      },
    ),
    'peru_accion': PlanGobierno(
      partidoId: 'peru_accion',
      partidoNombre: 'Partido Político Perú Acción',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Realizar una \'verdadera revolución pacífica\' en el país.',
          'Pagar la deuda social que el Estado tiene con millones de peruanos postergados.',
        ],
      },
    ),
    'peru_primero': PlanGobierno(
      partidoId: 'peru_primero',
      partidoNombre: 'Partido Político Perú Primero',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Construir un país próspero, desarrollado y justo.',
          'Asegurar acceso a derechos y oportunidades para todos.',
          'Sustentar la ideología en principios humanistas y democráticos.',
          'Guiar el accionar por la premisa de poner a \'Perú Primero\'.',
        ],
      },
    ),
    'peruanos_unidos': PlanGobierno(
      partidoId: 'peruanos_unidos',
      partidoNombre: 'Partido Político Peruanos Unidos: ¡Somos Libres!',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Buscar la reconciliación y unidad del pueblo peruano.',
          'Derrotar la inseguridad ciudadana y la corrupción.',
        ],
        'Visión País': [
          'Forjar un país moderno, seguro, competitivo y próspero.',
          'Establecer una democracia plena y desarrollo integral (económico, social y cultural).',
          'Proveer seguridad y estabilidad institucional.',
          'Propiciar oportunidades y empleos dignos.',
          'Utilizar los recursos de manera eficiente, transparente y sostenible.',
          'Basar las decisiones de gobierno en planificación estratégica para reducir brechas.',
        ],
      },
    ),
    'voces_pueblo': PlanGobierno(
      partidoId: 'voces_pueblo',
      partidoNombre: 'Partido Político Popular Voces del Pueblo',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Combatir la desigualdad, los abusos y los privilegios.',
          'Impulsar la integración nacional, priorizando la conectividad física y virtual.',
          'Salvaguardar y proteger el cultivo y la producción tradicional de la hoja de coca.',
        ],
        'Educación': [
          'Asegurar el acceso a la educación con un grado de calidad superior.',
        ],
        'Salud': [
          'Asegurar el acceso a la salud con un grado de calidad superior.',
        ],
        'Seguridad': [
          'Contribuir en la construcción de un estado transparente y libre de corrupción.',
          'Combatir toda forma de discriminación.',
          'Buscar la reconciliación y unidad del pueblo peruano.',
          'Asegurar el acceso a la justicia con un grado de calidad superior.',
        ],
        'Visión País': [
          'Trabajar en función de las normas vigentes para la reforma total de la Constitución.',
          'Asegurar el acceso a vivienda, pensiones y transporte de calidad superior.',
          'Desarrollar un programa nacional de construcción de viviendas populares.',
          'Compromiso con un Perú democrático, plurinacional, feminista y ambientalista.',
        ],
      },
    ),
    'prin': PlanGobierno(
      partidoId: 'prin',
      partidoNombre: 'Partido Político PRIN',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Desarrollar la infraestructura necesaria (carreteras, puertos, aeropuertos, etc.).',
          'Desarrollar servicios básicos (agua y desagüe) para mejorar la competitividad.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Desarrollar programas para eliminar la anemia infantil.',
          'Desarrollar programas para eliminar la desnutrición infantil.',
        ],
        'Seguridad': [
          'Reformar el Sistema Judicial.',
          'Reformar el Código Penal para mitigar la delincuencia.',
          'Reformar el Código Penal para mitigar el crimen organizado.',
        ],
        'Visión País': [
          'Representar el regionalismo y la descentralización.',
          'Rechazar todo tipo de dictadura, autoritarismo y caudillismo.',
          'Moralización del sector público y gobierno austero.',
          'Promover el derecho a la revocatoria, iniciativa y control ciudadano.',
          'Promover políticas públicas para enfrentar las consecuencias del cambio climático.',
        ],
      },
    ),
    'ppc': PlanGobierno(
      partidoId: 'ppc',
      partidoNombre: 'Partido Popular Cristiano - PPC',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Desarrollar infraestructura necesaria para mejorar la competitividad.',
          'Promover la construcción de carreteras y controlar el estado de las pistas.',
          'Desarrollar servicios básicos: agua y desagüe.',
          'Ampliar las medidas de seguridad en las carreteras.',
        ],
        'Educación': [
          'Capacitación permanente a profesores y maestros.',
          'Actualizar la currícula de estudios de acuerdo con la modernización actual.',
          'Implementar el uso del satélite para fines educativos en zonas alejadas.',
          'Garantizar la calidad educativa y el acceso a la educación virtual en todos los niveles.',
        ],
        'Salud': [
          'Promover una salud oportuna y eficiente para todos los peruanos.',
          'Asegurar el abastecimiento de equipos e instrumentos médicos.',
          'Provisión constante de medicamentos de buena calidad.',
          'Capacitación permanente al personal de salud.',
        ],
        'Seguridad': [
          'Promover una justicia cercana y eficiente a la comunidad.',
          'Mejorar los sistemas de patrullaje e intervenciones policiales.',
          'Depurar los malos elementos de la PNP y fomentar la profesionalización.',
          'Reformar el Sistema Judicial y el código penal.',
        ],
        'Visión País': [
          'Promover la dignidad humana, la familia y el bien común.',
          'Fundamentar la acción política en libertad, igualdad, justicia y solidaridad.',
          'Reformar la administración pública y castigar severamente la inmoralidad.',
          'Luchar contra la corrupción.',
          'Buscar un Estado moderno, eficiente, transparente y descentralizado.',
          'Aplicar enfoque basado en derechos humanos y enfoque de género.',
        ],
      },
    ),
    'sicreo': PlanGobierno(
      partidoId: 'sicreo',
      partidoNombre: 'Partido SíCreo',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Crear millones de nuevos puestos de trabajo formales mediante inversión privada.',
          'Romper el monopolio del Estado para llevar agua a todos los peruanos.',
          'Reducir la burocracia (licencias, permisos) que fomenta la extorsión.',
          'Crear puestos de trabajo formales y de calidad.',
          'Promover la infraestructura y conectividad para integrar a los peruanos.',
        ],
        'Educación': [
          'Alcanzar la educación de calidad respetando la libertad de elegir de las familias.',
          'Fomentar deporte al alcance de todos para un Perú sano y competitivo.',
        ],
        'Salud': [
          'Fomentar deporte al alcance de todos para un Perú sano.',
        ],
        'Seguridad': [
          'Revalorar a la Policía y Fuerzas Armadas para que defiendan al país.',
          'Lucha frontal contra la corrupción: Si nadie roba, el dinero alcanza.',
          'Construcción de seis penales de máxima seguridad.',
          'Aplicar \'mano dura\' al cabecilla criminal y \'mano blanda\' al trabajador honesto.',
          'Desarraigar a cabecillas criminales, trasladándolos a otro entorno (e.g., costa a sierra).',
          'Sacar a los delincuentes del Estado para luchar contra el crimen.',
        ],
        'Visión País': [
          'Lucha frontal contra la corrupción y el crimen.',
          'Reforma del Estado.',
          'Poner el Estado en tu celular con tecnología de punta para denuncias e información.',
          'Defender la soberanía nacional y no negociarla con las mafias.',
          'Guiarse por los valores de Valentía, Unidad y Cambio.',
          'Reconocer valores como la familia y derechos fundamentales (vida y libertad).',
        ],
      },
    ),
    'unidad_paz': PlanGobierno(
      partidoId: 'unidad_paz',
      partidoNombre: 'Partido Unidad y Paz',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Promover el trabajo digno mediante políticas de inversión pública.',
          'Otorgar facilidades y garantías jurídicas para la inversión privada nacional.',
          'Otorgar facilidades y garantías jurídicas para la inversión privada internacional.',
        ],
        'Educación': [
          'Asegurar provisión universal de servicios de educación de calidad y probidad.',
          'Fomentar la educación con desarrollo de capacidades y participación de los padres.',
          'Forjar una cultura cívica y democrática para formar ciudadanos capacitados.',
        ],
        'Salud': [
          'Asegurar la provisión universal de servicios de salud de calidad y probidad.',
        ],
        'Seguridad': [
          'Asegurar provisión universal de servicios de seguridad de calidad y probidad.',
          'Garantizar a FF.AA. y PNP debidamente equipadas y entrenadas.',
          'Fomentar la participación de todos los peruanos en la Defensa Nacional.',
          'Contribuir a preservar la paz, la libertad y la vigencia de los derechos humanos.',
        ],
        'Visión País': [
          'Contribuir al desarrollo nacional y la vigencia del sistema democrático.',
          'Asegurar la provisión universal de servicios públicos de calidad y probidad.',
          'Garantizar la separación y control entre poderes del Estado.',
          'Establecer criterios rígidos de control y fiscalización para un Estado eficiente.',
          'Garantizar la independencia, la soberanía y la integridad territorial de la República.',
        ],
      },
    ),
    'peru_moderno': PlanGobierno(
      partidoId: 'peru_moderno',
      partidoNombre: 'Perú Moderno',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Comprometerse con valores éticos en la gestión pública.',
          'Defender la democracia y la justicia social.',
          'Promover un país con libertad, democracia y respeto a los derechos humanos.',
        ],
      },
    ),
    'podemos_peru': PlanGobierno(
      partidoId: 'podemos_peru',
      partidoNombre: 'Podemos Perú',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Combatir la usura bancaria y fiscalizar las tasas de interés abusivas.',
          'Promover y fortalecer la aplicación del Código del Consumidor.',
          'Impulsar reformas en los sistemas de pensiones (AFP y ONP).',
          'Atender y legislar sobre la devolución de fondos del FONAVI.',
          'Impulsar reformas en el régimen laboral CAS.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Contribuir a construir un país más seguro para todos los peruanos.',
        ],
        'Visión País': [
          'Construir un país más próspero y justo para todos los peruanos.',
          'Compromiso con la \'Justicia Social y Libertad para mi pueblo\'.',
        ],
      },
    ),
    'primero_gente': PlanGobierno(
      partidoId: 'primero_gente',
      partidoNombre: 'Primero la Gente - Comunidad, Ecología, Libertad y Progreso',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Impulsar el desarrollo económico sostenible.',
          'Fomentar una economía impulsada por tecnología innovadora.',
          'Promover una economía impulsada por el progreso científico.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Renovar la política con valores, profesionalismo y vocación de servicio.',
          'Promover la gobernanza, fortaleciendo la ciudadanía y la sociedad civil.',
          'Extender las libertades de los ciudadanos (Eje Libertad).',
          'Construir un Perú ambientalmente responsable (Eje Ecología).',
          'Promover la solidaridad en el país.',
          'Construir un partido sin dueño (Eje Comunidad).',
        ],
      },
    ),
    'progresemos': PlanGobierno(
      partidoId: 'progresemos',
      partidoNombre: 'Progresemos',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Defensa de los derechos y bienestar de los animales (Animalista).',
          'Impulso de políticas de protección ambiental (Ecologista).',
          'Promoción de políticas para los jóvenes (Pro Joven).',
          'Defensa y apoyo al sector agrario y a los agricultores.',
        ],
      },
    ),
    'renovacion_popular': PlanGobierno(
      partidoId: 'renovacion_popular',
      partidoNombre: 'Renovación Popular',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Crear Planes de Empleo Masivo a Nivel Distrital.',
          'Dotar de agua a todos los peruanos a través de Planes de Empleo Masivo.',
        ],
        'Educación': [
          'Otorgar el programa Crédito 21 por Concurso Público Nacional.',
          'Beneficiar a los 10,000 mejores estudiantes con Crédito 21.',
        ],
        'Salud': [
          'Restablecer y potenciar las Postas Médicas.',
          'Restablecer y potenciar los Hospitales de la Solidaridad.',
          'Asegurar que Postas y Hospitales de la Solidaridad estén abiertos las 24 horas.',
        ],
        'Seguridad': [
          'Aplicar cárcel efectiva para los delitos de hurto y robo, sin importar el monto.',
          'Aplicar expulsión, incautación y cadena perpetua para la corrupción.',
          'Aplicar expulsión, incautación y cadena perpetua para las empresas corruptas y cómplices.',
        ],
        'Visión País': [
          'Combatir la hambruna y la desnutrición con alimentos peruanos (Hambre Cero).',
          'Aplicar \'Cero Corrupción\' en el país.',
        ],
      },
    ),
    'salvemos_peru': PlanGobierno(
      partidoId: 'salvemos_peru',
      partidoNombre: 'Salvemos al Perú',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
      },
    ),
    'camino_diferente': PlanGobierno(
      partidoId: 'camino_diferente',
      partidoNombre: 'Un Camino Diferente',
      anio: '2026',
      ambito: 'Nacional',
      categorias: {
        'Economía': [
          'Fortalecer las economías regionales con programas de capacitación.',
          'Fortalecer las economías regionales con acceso al mercado.',
          'Optimizar los recursos públicos para garantizar obras y servicios sin derroche.',
          'Desarrollar infraestructura urbana que priorice la seguridad y calidad de vida.',
        ],
        'Educación': [
          'Asegurar servicios de educación de calidad.',
          'Impulsar una formación práctica enfocada en la empleabilidad.',
          'Impulsar una formación moderna enfocada en valores.',
        ],
        'Salud': [
          'Asegurar servicios de salud de calidad.',
          'Promover campañas de salud preventiva y comunitaria.',
          'Asegurar acceso a servicios médicos en zonas más necesitadas.',
        ],
        'Seguridad': [
          'Asegurar servicios de seguridad de calidad.',
          'Priorizar un sistema de justicia rápido y accesible.',
          'Garantizar un sistema de justicia que respete las leyes.',
          'Luchar contra la corrupción.',
        ],
        'Visión País': [
          'Defender la igualdad, la libertad y el estado de derecho.',
          'Convertir al país en uno donde los ciudadanos se desarrollen plenamente.',
          'Integrar tecnología y sostenibilidad para enfrentar retos globales.',
          'Crear programas integrales que fortalezcan el rol de las familias.',
          'Incentivar programas que apoyen a jóvenes en emprendimientos y liderazgo.',
          'Empoderar a los ciudadanos para liderar el cambio desde sus comunidades.',
        ],
      },
    ),
    'ciudadanos_peru': PlanGobierno(
      partidoId: 'ciudadanos_peru',
      partidoNombre: 'Ciudadanos Por El Perú',
      anio: '2026',
      ambito: 'Nacional',
      nota: 'Plan de gobierno 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Participar democráticamente en los asuntos públicos de la República del Perú.',
          'Regirse por la Constitución, leyes de organizaciones políticas y sus estatutos internos.',
        ],
      },
    ),
    'fia': PlanGobierno(
      partidoId: 'fia',
      partidoNombre: 'Frente Popular Agrícola FIA del Perú (FREPAP)',
      anio: '2019-2022',
      ambito: 'Municipal - Arequipa',
      nota: 'Plan municipal de Arequipa 2019-2022. Plan nacional 2026 en proceso de carga.',
      categorias: {
        'Economía': [
          'Promover la inversión pública y privada en la provincia, priorizando el empleo local.',
          'Facilitar el desarrollo de mercados y ferias distritales para el comercio minorista.',
          'Impulsar la formalización de la micro y pequeña empresa (MYPE) en la provincia.',
          'Promover el turismo sostenible, mejorando la infraestructura y servicios para visitantes.',
          'Desarrollo de proyectos de infraestructura básica y productiva que incentiven la economía.',
        ],
        'Educación': [
          'Impulsar programas de capacitación técnica y vocacional para jóvenes y adultos.',
          'Promover el uso de TICs en la educación y la conectividad en centros educativos locales.',
        ],
        'Salud': [
          'Coordinar con el sector salud para fortalecer el primer nivel de atención y postas médicas.',
          'Implementar campañas de salud preventiva y nutricional en zonas vulnerables.',
        ],
        'Seguridad': [
          'Articulación de seguridad ciudadana entre el Gobierno Provincial, distritos y Policía Nacional.',
          'Implementar un plan integral para combatir la inseguridad ciudadana y la inseguridad vial.',
          'Fortalecer el Serenazgo con mayor capacitación, equipamiento y tecnología de vigilancia.',
          'Promover la participación activa de juntas vecinales y rondas urbanas en la seguridad.',
        ],
        'Visión País': [
          'Promover la planificación provincial vinculante con Universidades y Colegios Profesionales.',
          'Reorganizar la estructura del Gobierno Provincial y capacitar al personal por méritos.',
          'Aumentar la productividad del Gobierno Provincial en un 100% con nueva gestión.',
          'Implementar asambleas trimestrales para rendición de cuentas y atención de observaciones.',
        ],
      },
    ),
  };

  // Obtener plan de gobierno por ID de partido
  static PlanGobierno? getPlanByPartidoId(String partidoId) {
    return _planes[partidoId];
  }

  // Verificar si un partido tiene plan de gobierno
  static bool hasPlan(String partidoId) {
    return _planes.containsKey(partidoId);
  }

  // Obtener plan de gobierno por defecto (para partidos sin datos)
  static PlanGobierno getDefaultPlan(String partidoId, String partidoNombre) {
    return PlanGobierno(
      partidoId: partidoId,
      partidoNombre: partidoNombre,
      categorias: {
        'Economía': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Educación': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Salud': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Seguridad': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
        'Visión País': [
          'Información no disponible. Plan de gobierno en proceso de carga.',
        ],
      },
    );
  }
}
