class Candidato {
  final String nombre;
  final String cargo; // 'Representante Legal', 'Presidente', 'Vicepresidente 1', 'Vicepresidente 2', etc.
  final String fotoPath;
  final String hojaVida;
  final String biografia;
  final int? orden; // Para ordenar múltiples candidatos del mismo cargo

  Candidato({
    required this.nombre,
    required this.cargo,
    required this.fotoPath,
    required this.hojaVida,
    required this.biografia,
    this.orden,
  });

  // Helper para generar el nombre del archivo de foto
  static String getFotoPath(String partidoId, String cargo, {int? numero}) {
    String cargoKey;
    switch (cargo.toLowerCase()) {
      case 'representante legal':
        cargoKey = 'representante';
        break;
      case 'presidente':
        cargoKey = 'presidente';
        break;
      case 'vicepresidente 1':
      case 'primer vicepresidente':
        cargoKey = 'vice1';
        break;
      case 'vicepresidente 2':
      case 'segundo vicepresidente':
        cargoKey = 'vice2';
        break;
      case 'vicepresidente 3':
      case 'tercer vicepresidente':
        cargoKey = 'vice3';
        break;
      default:
        cargoKey = cargo.toLowerCase().replaceAll(' ', '_');
    }
    
    // Si hay número mayor a 1, agregarlo con guión bajo
    if (numero != null && numero > 1) {
      return 'assets/images/candidatos/${partidoId}_${cargoKey}_$numero.png';
    }
    
    return 'assets/images/candidatos/${partidoId}_$cargoKey.png';
  }

  // Biografías personalizadas por partido
  // INSTRUCCIONES: Para agregar biografías de un partido específico, copia la plantilla
  // y reemplaza los valores. Consulta GUIA_EDITAR_BIOGRAFIAS.md para más detalles.
  static Map<String, Map<String, Map<String, String>>> getBiografiasPersonalizadas() {
    return {
      // ACCIÓN POPULAR
      'accion_popular': {
        'Presidente': {
          'nombre': 'Mesías Antonio Guevara Amasifuén',
          'hojaVida': '• Estudios en Ingeniería Electrónica en la Universidad Nacional de Ingeniería (UNI)\n• Egresado de la Segunda Especialización en Formulación y Evaluación de Proyectos de Inversión (UNI)\n• Docente en escuelas de posgrado (UNFV, UNMSM, UPU) y ejecutivo senior en empresas multinacionales de tecnología (Lucent Technologies)\n• Congresista de la República por Cajamarca (2011-2016) y Gobernador Regional de Cajamarca (2019-2022)\n• Presidente del partido Acción Popular (2014-2023)',
          'biografia': 'Mesías Antonio Guevara Amasifuén es un ingeniero, académico y político peruano. Nació en Chiclayo, Lambayeque, el 13 de junio de 1963. Su formación profesional se centra en la ingeniería electrónica, egresado de la UNI, y ha complementado su carrera con experiencia en el sector tecnológico como ejecutivo en empresas multinacionales (como Lucent Technologies) y como profesor universitario.\n\nSu trayectoria política está profundamente ligada al partido Acción Popular, del cual fue miembro y Presidente Nacional por un extenso periodo (2014-2023). Fue elegido Congresista de la República por Cajamarca (2011-2016) y posteriormente Gobernador Regional de Cajamarca (2019-2022).\n\nDurante su gestión como gobernador, se le atribuyen logros como la reducción de la conflictividad social en la región, lo que permitió un incremento en la inversión pública y privada. Además, impulsó mejoras en los sistemas de salud y educación, y creó la Agencia Regional de Desarrollo para fomentar el desarrollo agrario y forestal. Un logro destacado fue el pago de la deuda social a profesores por un monto de aproximadamente 410 millones de soles.\n\nSu visión para el país se basa en la necesidad de construir una nación democrática, con pleno respeto a la diversidad cultural e igualdad de oportunidades. Sus propuestas hacen énfasis en la lucha contra la corrupción, el desempleo y la pobreza, y la urgencia de establecer un sistema de innovación nacional que promueva el conocimiento científico y tecnológico. También ha abogado por la defensa de la institucionalidad y la necesidad de que la política sea un arte de servir sin condición alguna.',
        },
        'Presidente_2': {
          'nombre': 'Isaac Alfredo Barnechea García',
          'hojaVida': '• Periodista. Bachiller en Letras por la Pontificia Universidad Católica del Perú (1968-1972)\n• Maestría en Ciencias Políticas por la London School of Economics and Political Science (1974-1976)\n• Profesor de Economía y Finanzas Internacionales en la Escuela de Gobierno y Políticas Públicas (2005-2010); Periodista en El Comercio (2002-2004)\n• Diputado de la República por Lima (1985-1990), elegido inicialmente por el APRA. Asesor de la Comisión de Defensa del Consumidor (2011)\n• Candidato presidencial por Acción Popular en las elecciones de 2016. Postuló a la Alcaldía de Lima en 1983. Reconocido escritor con obras como "La República embrujada"',
          'biografia': 'Isaac Alfredo Barnechea García (Ica, 1952) es un escritor, periodista y político peruano con una extensa trayectoria en el ámbito público y académico. Se formó en Letras en la Pontificia Universidad Católica del Perú y obtuvo una Maestría en Ciencias Políticas en la prestigiosa London School of Economics and Political Science.\n\nSu carrera política comenzó en el Partido Aprista Peruano (APRA), con el que postuló sin éxito a la Alcaldía de Lima en 1983 y fue electo Diputado de la República por Lima para el periodo 1985-1990. Renunció al APRA en 1987 debido a discrepancias con la política de estatización de la banca, pasando a ser un político independiente y cercano a figuras como Mario Vargas Llosa y Javier Pérez de Cuéllar. Posteriormente, se integró a las filas de Acción Popular, partido por el que fue candidato presidencial en las elecciones de 2016, siendo uno de los principales referentes del partido.\n\nSu visión política dentro de Acción Popular se alinea con la doctrina acciopopulista, buscando impulsar el desarrollo nacional con énfasis en la reducción de la informalidad, el fomento del emprendimiento (especialmente para PYMES), la reforma carcelaria y la mitigación de la violencia familiar. Durante su campaña de 2016, resaltó propuestas de gran alcance como la masificación del gas natural en los hogares peruanos. Barnechea se ha comprometido con la visión de la organización de tomar decisiones basadas en los grandes intereses nacionales, desterrando la corrupción y promoviendo la moralización del sector público.',
        },
        'Presidente_3': {
          'nombre': 'Víctor Andrés García Belaúnde',
          'hojaVida': '• Abogado (Universidad Nacional Mayor de San Marcos, 1968-1974) y Antropólogo (Universidad Nacional Mayor de San Marcos, 1967-1971)\n• Maestría en Sociología (Pontificia Universidad Católica del Perú, 1974-1976) y Doctorado en Derecho (Universidad de San Martín de Porres, 2011)\n• Docente universitario desde 1975 en diversas universidades. Ha ejercido como periodista y Director/Gerente de Radio Cutivalú (2000-2005)\n• Diputado (1985-1992). Congresista de la República en tres periodos (2006-2019). Fue Secretario del Consejo de Ministros (1980-1985)\n• Figura histórica de Acción Popular y acérrimo opositor al régimen fujimorista tras el autogolpe de 1992. Secretario General del partido (2014-2015). Promotor del pensamiento belaundista',
          'biografia': 'Víctor Andrés García Belaúnde (Lima, 1949) es un abogado, antropólogo y doctor en derecho, además de ser una figura central en la política peruana y un miembro histórico de Acción Popular. Su carrera política se caracteriza por una profunda lealtad a la doctrina belaundista y un marcado espíritu fiscalizador y opositor.\n\nInició su trayectoria como secretario personal del expresidente Fernando Belaúnde Terry en 1980, asumiendo luego el cargo de Secretario del Consejo de Ministros. Ejerció como Diputado (1985-1992) y posteriormente fue electo Congresista de la República por tres periodos consecutivos (2006-2019), consolidándose como uno de los políticos con mayor experiencia parlamentaria. Su mandato como diputado fue interrumpido por el autogolpe de 1992, lo que lo convirtió en un fuerte crítico de la dictadura fujimorista.\n\nDentro de Acción Popular, ha ocupado la Secretaría General Nacional y es un activo promotor de la formación de nuevos líderes, insistiendo en la necesidad de recuperar la ética en el ejercicio del poder y la vigencia del pensamiento de Fernando Belaúnde (lema de su partido, "Volver a Belaúnde"). En cuanto a propuestas y visión, se ha pronunciado consistentemente sobre temas de gran calado, como la lucha contra la criminalidad —señalando que es un problema social, económico y político complejo que no se soluciona solo con leyes—, y ha apoyado reformas institucionales como la bicameralidad para mejorar la calidad del Parlamento. También ha expresado su postura sobre el sistema de pensiones, sugiriendo que la afiliación no debería ser obligatoria. Su postura se enfoca en la necesidad de restituir la institucionalidad del partido y combatir la corrupción, diferenciándose de las facciones cuestionadas dentro de Acción Popular.',
        },
        'Presidente_4': {
          'nombre': 'Julio Abraham Chávez Chiong',
          'hojaVida': '• Abogado (Universidad de San Martín de Porres)\n• Abogado en Perú Lycra S.A.C. (desde 2016 - actualidad); Asesor en el Congreso de la República (2015-2016)\n• Alcalde Distrital de San Martín de Porres (2019-2022)\n• Actual Presidente del partido Acción Popular (periodo 2024-2028)\n• Impulsó importantes obras de infraestructura en su gestión municipal (Plaza de Armas Juan Pablo Vizcardo y Guzmán, Complejo Deportivo San Diego, etc.)',
          'biografia': 'Julio Abraham Chávez Chiong (Callao, 1981) es un abogado y político peruano con una trayectoria de más de 20 años de militancia en Acción Popular. Su carrera pública y partidaria lo ha posicionado como una de las figuras principales del acciopopulismo en la actualidad.\n\nChávez Chiong ejerció como Alcalde Distrital de San Martín de Porres durante el periodo 2019-2022. Durante su gestión municipal, se enfocó en propuestas para modernizar el distrito y mejorar los servicios, logrando la ejecución de importantes obras de infraestructura urbana como el Complejo Deportivo San Diego y la remodelación de la Plaza de Armas Juan Pablo Vizcardo y Guzmán, respondiendo a necesidades largamente postergadas en el sector.\n\nEn el ámbito partidario, fue elegido Presidente Nacional de Acción Popular para el periodo 2024-2028. Su visión como líder se centra en la unidad, la disciplina partidaria y la consolidación institucional del partido de cara a las elecciones generales de 2026, con el objetivo de "devolverle al Perú el gobierno y liderazgo que merece".',
        },
      },
      
      // FUERZA POPULAR
      'fuerza_popular': {
        'Presidente': {
          'nombre': 'Keiko Sofía Fujimori Higuchi',
          'hojaVida': '• Administradora de Empresas, egresada de la Universidad de Boston (1997)\n• Primera Dama de la República del Perú (1994-2000)\n• Congresista de la República por Lima (2006-2011)\n• Presidenta del partido Fuerza Popular (fundado en 2010)\n• Ha llegado tres veces a la segunda vuelta de las elecciones presidenciales (2011, 2016 y 2021)',
          'biografia': 'Keiko Sofía Fujimori Higuchi es una administradora de empresas y la líder política del fujimorismo en Perú. Nació en Lima el 25 de mayo de 1975. Inició su vida pública a una edad temprana, asumiendo el rol protocolar de Primera Dama de la Nación entre 1994 y 2000. Posteriormente, fue elegida Congresista de la República por Lima (2006-2011). Es la fundadora y actual presidenta del partido Fuerza Popular.\n\nSu trayectoria política está marcada por su constante participación en la contienda electoral, siendo la única candidata en la historia reciente de Perú en alcanzar la segunda vuelta presidencial en tres ocasiones (2011, 2016, 2021). Su ideología se enmarca en la derecha a extrema derecha, con un fuerte enfoque en el Conservadurismo Social y la Economía Social de Mercado.\n\nLas propuestas principales de su plan de gobierno se centran en el "Plan Rescate" y tienen como visión un Perú que garantice el crecimiento económico y la seguridad ciudadana.\n\nEconomía: Propone una meta de crecimiento del 6% del PBI y la recuperación del empleo formal en dos años. En el ámbito empresarial, plantea una reforma tributaria orientada a incentivar la formalización de las micro y pequeñas empresas (MYPEs).\n\nSeguridad: Enfatiza el principio de autoridad eficiente y la lucha frontal contra la delincuencia y el narcoterrorismo, con apoyo decidido a la Policía Nacional y Fuerzas Armadas.\n\nSocial: Defiende la vida desde la concepción y a la familia como célula fundamental de la sociedad, y propone políticas contra la pobreza extrema.',
        },
      },
      
      // RENOVACIÓN POPULAR
      'renovacion_popular': {
        'Presidente': {
          'nombre': 'Rafael López Aliaga',
          'hojaVida': '• Empresario y político peruano\n• Ingeniero Industrial, Universidad de Lima\n• MBA, ESAN\n• Ex candidato a la alcaldía de Lima',
          'biografia': 'Empresario con amplia trayectoria en el sector privado. Fundador y líder del partido Renovación Popular. Propone un modelo económico liberal con reducción del Estado y promoción de la inversión privada. Su plan incluye reformas en educación, salud y seguridad ciudadana.',
        },
      },
      
      // PARTIDO MORADO
      'partido_morado': {
        'Presidente': {
          'nombre': 'Julio Guzmán Cáceres',
          'hojaVida': '• Economista, Universidad del Pacífico\n• Maestría en Políticas Públicas, Georgetown University\n• Ex funcionario del Banco Mundial\n• Fundador del Partido Morado',
          'biografia': 'Economista y político con experiencia en organismos internacionales. Fundador del Partido Morado, propone un modelo de desarrollo basado en la meritocracia, transparencia y lucha contra la corrupción. Su plan de gobierno enfatiza la reforma del Estado y la modernización de las instituciones.',
        },
      },
      
      // ALIANZA PARA EL PROGRESO
      'alianza_para_el_progreso': {
        'Presidente': {
          'nombre': 'César Acuña Peralta',
          'hojaVida': '• Educador y político peruano\n• Doctor en Educación\n• Ex Alcalde de Trujillo\n• Ex Gobernador Regional de La Libertad\n• Fundador de la Universidad César Vallejo',
          'biografia': 'Educador y político con amplia experiencia en gestión pública regional. Ha sido alcalde de Trujillo y gobernador regional de La Libertad. Fundador de la Universidad César Vallejo. Propone políticas de desarrollo regional con énfasis en educación, infraestructura y descentralización.',
        },
      },
      
      // AVANZA PAÍS
      'avanza_pais': {
        'Presidente': {
          'nombre': 'Hernando de Soto Polar',
          'hojaVida': '• Economista peruano de renombre internacional\n• Presidente del Instituto Libertad y Democracia (ILD)\n• Asesor de gobiernos en más de 20 países\n• Autor de "El Otro Sendero" y "El Misterio del Capital"',
          'biografia': 'Reconocido economista con prestigio internacional. Ha asesorado a gobiernos de diversos países en temas de formalización y derechos de propiedad. Propone un modelo de desarrollo basado en la formalización de la economía informal y el fortalecimiento de los derechos de propiedad como motor del crecimiento económico.',
        },
      },
      
      // JUNTOS POR EL PERÚ
      'juntos_por_el_peru': {
        'Presidente': {
          'nombre': 'Roberto Helbert Sánchez Palomino',
          'hojaVida': '• Psicólogo, egresado de la Universidad Nacional Mayor de San Marcos (UNMSM) en el año 2000\n• Egresado de la Maestría en la Universidad Nacional Mayor de San Marcos (UNMSM)\n• Gerente de Desarrollo Social en la Municipalidad Provincial de Huaral (2020)\n• Congresista de la República por Lima Metropolitana para el periodo 2021-2026\n• Ex Ministro de Comercio Exterior y Turismo (MINCETUR) durante el gobierno de Pedro Castillo (julio de 2021 - diciembre de 2022)\n• Presidente del partido Juntos por el Perú (desde 2017). Elegido congresista con 29,827 votos válidos en 2021',
          'biografia': 'Roberto Helbert Sánchez Palomino (nacido en Huaral, 1969) es un psicólogo y político peruano. Egresado de la Universidad Nacional Mayor de San Marcos (UNMSM), ha enfocado su carrera política en la izquierda del espectro.\n\nEs el actual Presidente del partido Juntos por el Perú (JP) desde 2017, formación que se define como de Socialismo Democrático y Socialdemocracia. Como líder de JP, su plataforma política para las elecciones de 2021, que lo llevó al Congreso, estuvo centrada en una visión de cambio profundo, igualdad de oportunidades y una crítica al centralismo. Una de sus propuestas destacadas en su postulación al Congreso fue la implementación de un centro de salud mental en cada distrito del país y dotar a los colegios de al menos tres psicólogos. Además, el partido Juntos por el Perú promueve la generación de políticas públicas para enfrentar el cambio climático y rechaza todo tipo de monopolio empresarial, oligopolios y abuso de posición de dominio.\n\nSánchez Palomino fue elegido Congresista de la República por Lima para el periodo 2021-2026. Tras el inicio del gobierno de Pedro Castillo, fue designado como Ministro de Comercio Exterior y Turismo (MINCETUR), cargo que ocupó durante todo el mandato de Castillo (julio de 2021 a diciembre de 2022).',
        },
      },
      
      // BUEN GOBIERNO (VICTORIA NACIONAL)
      'buen_gobierno': {
        'Representante Legal': {
          'nombre': 'Jorge Nieto Montesinos',
          'hojaVida': '• Bachiller en Ciencias Sociales con mención en Sociología por la Pontificia Universidad Católica del Perú (1982)\n• Maestría en Ciencias Sociales con mención en Sociología por la Facultad Latinoamericana de Ciencias Sociales (1984)\n• Presidente del Instituto Internacional para la Cultura Democrática SAC (desde 2011 hasta la actualidad)\n• Ministro de Defensa (2016-2018)\n• Ministro de Cultura (2016)\n• Autor de libros como "Izquierda y democracia en el Perú" y "Haya de la Torre o la política como obra civilizatoria"',
          'biografia': 'Jorge Nieto Montesinos es un sociólogo y político peruano nacido el 29 de octubre de 1951 en Arequipa. Es Bachiller en Ciencias Sociales y Magíster en Sociología, ambos grados obtenidos en la Pontificia Universidad Católica del Perú y la Facultad Latinoamericana de Ciencias Sociales, respectivamente. Ha desarrollado una carrera destacada como analista y consultor político, además de ser autor de varias publicaciones sobre política y cultura.\n\nEn el ámbito público, ha ocupado importantes cargos ministeriales durante el gobierno de Pedro Pablo Kuczynski: fue Ministro de Cultura en 2016 y posteriormente Ministro de Defensa desde 2016 hasta 2018. Su experiencia laboral también incluye ser Presidente del Instituto Internacional para la Cultura Democrática SAC desde 2011.\n\nSu visión política se ha enmarcado en la necesidad de un centro político, buscando la estabilidad macroeconómica del país como una "conquista cultural" que debe mantenerse. Sostiene que el modelo económico debe funcionar para todos y critica las prácticas donde las empresas "privatizan ganancias y socializan pérdidas". En cuanto a sus propuestas, ha enfatizado la necesidad de un Estado que sienta lo que siente la gente, y un compromiso con la lucha contra las desigualdades. Como Ministro de Cultura, su plan estratégico buscaba garantizar los derechos culturales, fortalecer al Estado para gestionar la diversidad cultural, y consolidar la cultura como un pilar del desarrollo e identidad nacional.\n\nSe encuentra postulando a la Presidencia por el partido Victoria Nacional.',
        },
      },
      
      // PODEMOS PERÚ
      'podemos_peru': {
        'Representante Legal': {
          'nombre': 'José León Luna Gálvez',
          'hojaVida': '• Economista y Doctor en Educación por la Universidad de San Martín de Porres (USMP)\n• Maestro en Economía con mención en Comercio y Finanzas Internacionales por la USMP (2004)\n• Asesor-Presidente del Directorio en Universidad Privada Telesup SAC (desde 2020) y fundador del emporio educativo Telesup (1996)\n• Congresista de la República en múltiples periodos, incluyendo el actual (2021-2026)\n• Presidente Fundador de Podemos Perú (fundado en 2017)\n• Lideró la lucha por la devolución de fondos de AFP, ONP y FONAVI para la clase trabajadora',
          'biografia': 'José Luna Gálvez es un empresario, economista y político peruano, nacido en Huancavelica. Es el fundador y líder del partido Podemos Perú. Cuenta con una sólida formación académica como Economista y Doctor en Educación por la Universidad de San Martín de Porres (USMP).\n\nEn el ámbito empresarial, su trayectoria es notable: fundó una pequeña academia que creció hasta convertirse en la Universidad Privada Telesup en 2004. Actualmente, se desempeña como Asesor-Presidente del Directorio en dicha universidad.\n\nEn la política, ha sido Congresista de la República en varios periodos, destacándose como una figura que ha promovido leyes a favor de la Economía Social de Mercado. Su plataforma política se centra en la justicia social, la inclusión y la lucha contra la corrupción. Luna Gálvez ha capitalizado su liderazgo en la causa por la devolución de los fondos previsionales (AFP, FONAVI, ONP), posicionándose como defensor de los derechos de los ciudadanos y la clase trabajadora. Su ideario busca asegurar la vigencia del sistema democrático, preservar la paz y la libertad, y fortalecer los sistemas de control interno en la Administración Pública.',
        },
      },
      
      // UNIÓN POR EL PERÚ
      'union_por_el_peru': {
        'Presidente': {
          'nombre': 'Ricardo Pablo Belmont Cassinelli',
          'hojaVida': '• Bachiller en Administración de Empresas por la Universidad de Lima (1966)\n• Conductor de Televisión en RED BICOLOR DE COMUNICACIONES SAA (2011-2016)\n• Alcalde Provincial de Lima (1993-1995) por el Movimiento Cívico Nacional Obras\n• Congresista de la República (Accesitario) (2009-2011)\n• Fundador del Movimiento Cívico Nacional Obras\n• Logros destacados: Ejecución de obras como el Trébol de Javier Prado, la Av. Universitaria y el Óvalo Higuereta',
          'biografia': 'Ricardo Pablo Belmont Cassinelli (nacido en 1945) es una figura prominente de la política y los medios de comunicación peruanos. Egresado como Bachiller en Administración de Empresas de la Universidad de Lima, desarrolló una larga carrera como comunicador y conductor de televisión antes de su incursión en la vida política.\n\nSu trayectoria política inició con la fundación de su propia agrupación, el Movimiento Cívico Nacional Obras. Su cargo público más importante fue el de Alcalde Provincial de Lima (1993-1995), donde su gestión fue reconocida por la realización de grandes obras de infraestructura, destacando el Intercambiador El Trébol de Javier Prado, la Avenida Universitaria y el Óvalo Higuereta. Posteriormente, fue Congresista de la República en calidad de accesitario.\n\nPara las Elecciones Generales de 2021, postuló a la Presidencia de la República por el partido Unión por el Perú (UPP). Su visión para el país se centra en una crítica al modelo económico actual y una fuerte postura anti-corrupción. En su plataforma, propone una reactivación económica y una distribución más justa de la riqueza nacional, especialmente proveniente de la actividad minera.',
        },
      },
      
      // AHORA NACIÓN
      'ahora_nacion': {
        'Presidente': {
          'nombre': 'Pablo Alfonso López Chau Nava',
          'hojaVida': '• Licenciado en Economía por la Universidad Nacional del Callao (1976)\n• Máster (1985) y Doctorado (2005) en Economía por la Universidad Nacional Autónoma de México (UNAM)\n• Rector de la Universidad Nacional de Ingeniería (UNI) desde 2021 hasta mayo de 2025. Renunció al cargo para dedicarse a la política\n• Director del Banco Central de Reserva del Perú (BCRP) de 2006 a 2012\n• Catedrático en la UNI, en el Doctorado de la UNMSM y en el Centro de Altos Estudios Nacionales (CAEN)\n• Líder y Fundador del partido político Ahora Nación (AN), afiliado desde el 13/05/2023\n• Fundó y dirigió la Revista Apertura (1992-1996)',
          'biografia': 'Pablo Alfonso López Chau Nava es un economista, académico y político peruano que postula a la Presidencia de la República para las Elecciones Generales de 2026 bajo la bandera del partido de centro-izquierda Ahora Nación. Su trayectoria destaca por su rol como Rector de la Universidad Nacional de Ingeniería (UNI) entre 2021 y 2025, cargo al que renunció para asumir el compromiso de su candidatura. Previamente, ejerció como Director del Banco Central de Reserva del Perú (BCRP) de 2006 a 2012. En el ámbito académico, posee un doctorado en Economía por la UNAM y ha sido catedrático en diversas instituciones.\n\nLópez Chau Nava se define como un socialdemócrata y centra su visión de país en la construcción de la nación peruana. Ha hecho oficial su intención de buscar la presidencia en junio de 2024. Entre sus principales propuestas, se encuentra la necesidad de una nueva Constitución (aunque manteniendo el modelo de economía social de mercado) y la idea de otorgar todo el poder a las regiones para impulsar la productividad y conquistar mercados internacionales.',
        },
      },
      
      // LIBERTAD POPULAR
      'libertad_popular': {
        'Presidente': {
          'nombre': 'Rafael Jorge Belaunde Llosa',
          'hojaVida': '• Fundador y Presidente de la organización política Libertad Popular (desde 14/11/2022)\n• Representante Legal de Libertad Popular (desde 08/03/2023)\n• Afiliado a Todos por el Perú (2020-2021)\n• Fundador y Representante del Partido Político Adelante (2005-2012)\n• Experiencia en liderazgo y fundación de partidos políticos',
          'biografia': 'Rafael Jorge Belaunde Llosa es un ciudadano con amplia experiencia en liderazgo y fundación de partidos políticos. Nació el 26 de diciembre de 1974 y reside en San Isidro, Lima.\n\nActualmente, es afiliado válido de Libertad Popular, organización política que él mismo fundó el 14 de noviembre de 2022 y de la cual es Presidente desde esa misma fecha. Además, ejerce como Representante Legal del partido desde el 8 de marzo de 2023. Libertad Popular es un partido político inscrito y de alcance nacional.\n\nSu trayectoria política incluye liderazgo en otras dos organizaciones nacionales: fue afiliado a Todos por el Perú (2020-2021) y, previamente, fue Fundador y Representante del Partido Político Adelante (2005-2012).',
        },
      },
      
      // PARTIDO APRISTA PERUANO
      'partido_aprista_peruano': {
        'Presidente': {
          'nombre': 'Magno Alfonso Mendoza Rodríguez',
          'hojaVida': '• Más de 13 años de trayectoria en el Partido Aprista Peruano\n• Afiliado al APRA desde 2008 hasta 2021\n• Reafiliado al partido desde el 7 de septiembre de 2022\n• Afiliado válido del Partido Aprista Peruano',
          'biografia': 'Magno Alfonso Mendoza Rodríguez es un ciudadano con una larga trayectoria en el Partido Aprista Peruano. Nació el 20 de enero de 1966 y mantiene su residencia en el Cercado de Lima.\n\nSu historial político se centra en su militancia en el APRA. Fue afiliado al partido desde 2008 hasta su cancelación en 2021, y se reafilió como Afiliado Válido en la nueva inscripción del partido el 7 de septiembre de 2022. Su experiencia política se contabiliza en más de 13 años dentro de la organización. Actualmente, es un afiliado válido sin cargos directivos vigentes en el partido.',
        },
        'Presidente_2': {
          'nombre': 'Nery Juana Quiroz Betetta',
          'hojaVida': '• Afiliada al Partido Aprista Peruano desde el 7 de septiembre de 2022\n• Reside en el distrito de San Antonio, provincia de Huarochirí, región Lima',
          'biografia': 'Nery Juana Quiroz Betetta, nacida el 29 de octubre de 1980, es una ciudadana con afiliación al Partido Aprista Peruano. Reside en el distrito de San Antonio, provincia de Huarochirí, en la región Lima.\n\nSu trayectoria política se centra en su militancia en el APRA, a la cual se afilió el 7 de septiembre de 2022. La organización fue inscrita el 24 de marzo de 2023. No registra afiliaciones anteriores a otros partidos políticos ni ocupa cargos de representación o dirección dentro del partido.',
        },
      },
      
      // Agrega más partidos aquí siguiendo el mismo formato...
      // Consulta GUIA_EDITAR_BIOGRAFIAS.md para instrucciones detalladas
    };
  }

  // Datos de candidatos por partido
  // Este método genera automáticamente candidatos basándose en los cargos estándar
  // Solo necesitas agregar las fotos con el nombre correcto
  static List<Candidato> getCandidatosPorPartido(String partidoId) {
    // Obtener biografías personalizadas si existen
    final biografiasPersonalizadas = getBiografiasPersonalizadas();
    final partidoBiografias = biografiasPersonalizadas[partidoId];
    List<Candidato> candidatos = [];
    
    // Definir todos los cargos posibles a verificar
    final cargosConfig = [
      {
        'cargo': 'Representante Legal',
        'titulo': 'Representante Legal',
        'hojaVida': '• Abogado especializado en derecho electoral\n• Secretario General del Partido\n• Más de 15 años de experiencia en derecho constitucional',
        'biografia': 'Representante legal del partido político con amplia trayectoria en derecho electoral y constitucional. Ha participado en múltiples procesos electorales como asesor legal.',
      },
      {
        'cargo': 'Presidente',
        'titulo': 'Candidato a Presidente',
        'hojaVida': '• Economista con maestría en políticas públicas\n• Ex Ministro de Economía y Finanzas\n• Docente universitario en economía\n• Consultor internacional',
        'biografia': 'Precandidato a la presidencia de la república con amplia experiencia en gestión pública y políticas económicas. Ha ocupado diversos cargos en el sector público y privado.',
      },
      {
        'cargo': 'Vicepresidente 1',
        'titulo': 'Primer Vicepresidente',
        'hojaVida': '• Profesional con experiencia en gestión pública\n• Ex Gobernador Regional\n• Especialista en desarrollo social',
        'biografia': 'Precandidato a primer vicepresidente con trayectoria en gestión regional y desarrollo de políticas sociales.',
      },
      {
        'cargo': 'Vicepresidente 2',
        'titulo': 'Segundo Vicepresidente',
        'hojaVida': '• Ingeniero con MBA\n• Ex Ministro de Transportes y Comunicaciones\n• Experiencia en infraestructura',
        'biografia': 'Precandidato a segundo vicepresidente con experiencia en gestión de infraestructura y desarrollo de proyectos de gran envergadura.',
      },
    ];
    
    // Para cada cargo, agregar el candidato base
    for (var config in cargosConfig) {
      // Verificar si hay biografía personalizada para este partido y cargo
      final cargoBiografia = partidoBiografias?[config['cargo'] as String];
      
      candidatos.add(Candidato(
        nombre: cargoBiografia?['nombre'] ?? (config['titulo'] as String),
        cargo: config['cargo'] as String,
        fotoPath: getFotoPath(partidoId, config['cargo'] as String),
        hojaVida: cargoBiografia?['hojaVida'] ?? (config['hojaVida'] as String),
        biografia: cargoBiografia?['biografia'] ?? (config['biografia'] as String),
        orden: 1,
      ));
      
      // Verificar si hay candidatos adicionales para este cargo (Presidente_2, Presidente_3, etc.)
      for (int i = 2; i <= 5; i++) {
        final cargoAdicional = '${config['cargo']}_$i';
        final biografiaAdicional = partidoBiografias?[cargoAdicional];
        
        if (biografiaAdicional != null) {
          candidatos.add(Candidato(
            nombre: biografiaAdicional['nombre'] ?? '${config['titulo']} $i',
            cargo: config['cargo'] as String,
            fotoPath: getFotoPath(partidoId, config['cargo'] as String, numero: i),
            hojaVida: biografiaAdicional['hojaVida'] ?? (config['hojaVida'] as String),
            biografia: biografiaAdicional['biografia'] ?? (config['biografia'] as String),
            orden: i,
          ));
        }
      }
    }
    
    // Verificar si hay múltiples candidatos del mismo cargo (vice1_1, vice1_2, etc.)
    // Para Vicepresidente 1
    for (int i = 2; i <= 5; i++) {
      candidatos.add(Candidato(
        nombre: 'Primer Vicepresidente $i',
        cargo: 'Vicepresidente 1',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 1', numero: i),
        hojaVida: '• Profesional con experiencia en gestión pública',
        biografia: 'Candidato a primer vicepresidente.',
        orden: i,
      ));
    }
    
    // Para Vicepresidente 2
    for (int i = 2; i <= 5; i++) {
      candidatos.add(Candidato(
        nombre: 'Segundo Vicepresidente $i',
        cargo: 'Vicepresidente 2',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 2', numero: i),
        hojaVida: '• Ingeniero con MBA\n• Ex Ministro de Transportes',
        biografia: 'Candidato a segundo vicepresidente.',
        orden: i,
      ));
    }
    
    return candidatos;
  }

  // Ejemplo con múltiples candidatos del mismo cargo
  static List<Candidato> getCandidatosConMultiples(String partidoId) {
    return [
      // Representante Legal
      Candidato(
        nombre: 'Roberto Martínez Flores',
        cargo: 'Representante Legal',
        fotoPath: getFotoPath(partidoId, 'Representante Legal'),
        hojaVida: '• Abogado especializado en derecho electoral',
        biografia: 'Representante legal del partido.',
        orden: 1,
      ),
      
      // Presidente
      Candidato(
        nombre: 'Juan Pérez García',
        cargo: 'Presidente',
        fotoPath: getFotoPath(partidoId, 'Presidente'),
        hojaVida: '• Economista con maestría en políticas públicas',
        biografia: 'Candidato a la presidencia.',
        orden: 1,
      ),
      
      // Primer Vicepresidente
      Candidato(
        nombre: 'María López Sánchez',
        cargo: 'Vicepresidente 1',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 1'),
        hojaVida: '• Abogada especializada en derechos humanos',
        biografia: 'Primera vicepresidenta.',
        orden: 1,
      ),
      
      // Segundo Vicepresidente
      Candidato(
        nombre: 'Carlos Rodríguez Torres',
        cargo: 'Vicepresidente 2',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 2'),
        hojaVida: '• Ingeniero Civil con MBA',
        biografia: 'Segundo vicepresidente.',
        orden: 1,
      ),
      
      // Tercer Vicepresidente (ejemplo adicional)
      Candidato(
        nombre: 'Ana Fernández Ruiz',
        cargo: 'Vicepresidente 3',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 3'),
        hojaVida: '• Médica especialista en salud pública',
        biografia: 'Tercera vicepresidenta.',
        orden: 1,
      ),
    ];
  }

  // Agrupar candidatos por cargo
  static Map<String, List<Candidato>> agruparPorCargo(List<Candidato> candidatos) {
    final Map<String, List<Candidato>> grupos = {};
    
    for (var candidato in candidatos) {
      if (!grupos.containsKey(candidato.cargo)) {
        grupos[candidato.cargo] = [];
      }
      grupos[candidato.cargo]!.add(candidato);
    }
    
    // Ordenar cada grupo por el campo 'orden'
    grupos.forEach((cargo, lista) {
      lista.sort((a, b) => (a.orden ?? 0).compareTo(b.orden ?? 0));
    });
    
    return grupos;
  }
}
