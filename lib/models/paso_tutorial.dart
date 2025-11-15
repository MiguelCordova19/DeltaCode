class PasoTutorial {
  final String titulo;
  final String descripcion;
  final String? detalle;
  final String? consejo;
  final List<String>? subpasos;
  final String? imagenUrl;

  PasoTutorial({
    required this.titulo,
    required this.descripcion,
    this.detalle,
    this.consejo,
    this.subpasos,
    this.imagenUrl,
  });
}

class EtapaElectoral {
  final String nombre;
  final String descripcion;
  final String horario;
  final List<PasoTutorial> pasos;
  final String icono;

  EtapaElectoral({
    required this.nombre,
    required this.descripcion,
    required this.horario,
    required this.pasos,
    required this.icono,
  });
}

class TutorialMiembroMesa {
  static final List<EtapaElectoral> etapas = [
    // ETAPA 1: INSTALACIÓN
    EtapaElectoral(
      nombre: 'Instalación de la Mesa',
      descripcion: 'Preparación y apertura de la mesa electoral',
      horario: '7:00 AM - 8:00 AM',
      icono: '🏁',
      pasos: [
        PasoTutorial(
          titulo: 'Llega temprano al local',
          descripcion: 'Debes estar en el local de votación a las 7:00 AM',
          detalle: 'Es importante llegar con anticipación para preparar todo antes de las 8:00 AM cuando inicia la votación.',
          consejo: '💡 Lleva tu DNI, algo de comer y agua para el día.',
          subpasos: [
            'Identifícate con tu DNI ante el personal de la ONPE',
            'Ubica tu mesa asignada',
            'Preséntate con los otros miembros de mesa',
          ],
        ),
        PasoTutorial(
          titulo: 'Recibe los materiales electorales',
          descripcion: 'El personal de la ONPE te entregará el ánfora y los documentos',
          detalle: 'Verifica que todos los materiales estén completos y en buen estado.',
          subpasos: [
            'Ánfora electoral (urna)',
            'Cédulas de sufragio',
            'Actas electorales',
            'Lista de electores',
            'Hoja de control de asistencia',
            'Útiles de escritorio',
          ],
          consejo: '⚠️ Si falta algo, repórtalo inmediatamente al coordinador.',
        ),
        PasoTutorial(
          titulo: 'Verifica el ánfora vacía',
          descripcion: 'Muestra a los electores presentes que el ánfora está vacía',
          detalle: 'Esto garantiza la transparencia del proceso. Abre el ánfora y muéstrala a todos los presentes.',
          consejo: '👀 Invita a los personeros y electores a verificar.',
        ),
        PasoTutorial(
          titulo: 'Sella el ánfora',
          descripcion: 'Cierra y sella el ánfora con las cintas de seguridad',
          detalle: 'Una vez verificada vacía, cierra el ánfora y coloca los precintos de seguridad.',
          subpasos: [
            'Cierra bien la tapa del ánfora',
            'Coloca las cintas de seguridad',
            'Anota los números de los precintos en el acta',
          ],
        ),
        PasoTutorial(
          titulo: 'Firma el Acta de Instalación',
          descripcion: 'Los tres miembros deben firmar el acta',
          detalle: 'El acta de instalación certifica que la mesa se instaló correctamente a las 8:00 AM.',
          consejo: '✍️ Verifica que todos los datos estén correctos antes de firmar.',
        ),
      ],
    ),

    // ETAPA 2: SUFRAGIO
    EtapaElectoral(
      nombre: 'Sufragio (Votación)',
      descripcion: 'Proceso de votación de los electores',
      horario: '8:00 AM - 4:00 PM',
      icono: '🗳️',
      pasos: [
        PasoTutorial(
          titulo: 'Verifica la identidad del elector',
          descripcion: 'Revisa que el DNI coincida con la lista de electores',
          detalle: 'El elector debe estar en la lista de tu mesa para poder votar.',
          subpasos: [
            'Solicita el DNI al elector',
            'Busca su nombre en la lista de electores',
            'Verifica que la foto y datos coincidan',
            'Confirma que no haya votado antes',
          ],
          consejo: '⚠️ Solo pueden votar electores de tu mesa con DNI vigente.',
        ),
        PasoTutorial(
          titulo: 'Registra al elector',
          descripcion: 'Marca su asistencia en la lista de electores',
          detalle: 'Coloca una marca o firma junto al nombre del elector en la lista.',
          consejo: '✓ Usa un check o tu firma para registrar.',
        ),
        PasoTutorial(
          titulo: 'Entrega la cédula de sufragio',
          descripcion: 'Dale la cédula al elector para que vote',
          detalle: 'Entrega UNA cédula de sufragio al elector. Él debe marcar su voto en secreto.',
          subpasos: [
            'Entrega una cédula limpia',
            'Indica dónde está la cámara secreta',
            'Espera a que vote en privado',
          ],
          consejo: '🔒 El voto es secreto, no veas cómo vota.',
        ),
        PasoTutorial(
          titulo: 'Recibe el voto',
          descripcion: 'El elector deposita su voto en el ánfora',
          detalle: 'El elector debe doblar su cédula y depositarla personalmente en el ánfora.',
          consejo: '👁️ Observa que deposite la cédula correctamente.',
        ),
        PasoTutorial(
          titulo: 'Firma el padrón',
          descripcion: 'El elector firma o coloca su huella digital',
          detalle: 'Después de votar, el elector debe firmar o poner su huella en el padrón electoral.',
        ),
        PasoTutorial(
          titulo: 'Repite el proceso',
          descripcion: 'Continúa con cada elector hasta las 4:00 PM',
          detalle: 'Mantén el orden y la paciencia. Todos los electores en cola a las 4:00 PM pueden votar.',
          consejo: '⏰ A las 4:00 PM cierra la cola, pero los que estén en fila pueden votar.',
        ),
      ],
    ),

    // ETAPA 3: ESCRUTINIO
    EtapaElectoral(
      nombre: 'Escrutinio (Conteo)',
      descripcion: 'Conteo de votos y cierre de la mesa',
      horario: '4:00 PM en adelante',
      icono: '📊',
      pasos: [
        PasoTutorial(
          titulo: 'Cierra la votación',
          descripcion: 'A las 4:00 PM no se admiten más electores',
          detalle: 'Los electores que estén en cola pueden votar, pero no se admiten nuevos.',
          consejo: '⏰ Anuncia en voz alta el cierre de la votación.',
        ),
        PasoTutorial(
          titulo: 'Abre el ánfora',
          descripcion: 'Retira los precintos y abre el ánfora',
          detalle: 'Corta los precintos de seguridad y abre el ánfora frente a todos los presentes.',
          subpasos: [
            'Anuncia que vas a abrir el ánfora',
            'Corta los precintos',
            'Abre la tapa del ánfora',
          ],
        ),
        PasoTutorial(
          titulo: 'Cuenta los votos',
          descripcion: 'Saca las cédulas una por una y cuenta los votos',
          detalle: 'Lee en voz alta cada voto y regístralo en el acta de escrutinio.',
          subpasos: [
            'Saca una cédula del ánfora',
            'Desdobla la cédula',
            'Lee en voz alta el voto',
            'Muestra la cédula a todos',
            'Registra el voto en el acta',
            'Repite con cada cédula',
          ],
          consejo: '📢 Lee cada voto en voz alta para transparencia.',
        ),
        PasoTutorial(
          titulo: 'Clasifica los votos',
          descripcion: 'Separa los votos válidos, nulos y en blanco',
          detalle: 'Organiza las cédulas en grupos según el tipo de voto.',
          subpasos: [
            'Votos válidos: marcados correctamente',
            'Votos nulos: marcados incorrectamente o con más de una opción',
            'Votos en blanco: sin marcar',
          ],
        ),
        PasoTutorial(
          titulo: 'Suma los resultados',
          descripcion: 'Cuenta el total de votos por cada candidato',
          detalle: 'Suma todos los votos de cada candidato y verifica que el total coincida.',
          consejo: '🔢 Verifica que la suma total sea correcta.',
        ),
        PasoTutorial(
          titulo: 'Llena el Acta de Escrutinio',
          descripcion: 'Registra los resultados en el acta',
          detalle: 'Escribe con letra clara y sin borrones los resultados del conteo.',
          subpasos: [
            'Anota los votos de cada candidato',
            'Registra votos nulos y en blanco',
            'Suma el total de votos',
            'Verifica que todo esté correcto',
          ],
          consejo: '✍️ Escribe con letra clara y sin errores.',
        ),
        PasoTutorial(
          titulo: 'Firman todos los miembros',
          descripcion: 'Los tres miembros firman el acta',
          detalle: 'Presidente, Secretario y Tercer Miembro deben firmar el acta de escrutinio.',
        ),
        PasoTutorial(
          titulo: 'Entrega los documentos',
          descripcion: 'Lleva las actas y materiales a la ODPE',
          detalle: 'Entrega todos los documentos al coordinador de la ONPE en el local.',
          subpasos: [
            'Acta de Escrutinio (original y copias)',
            'Acta de Instalación',
            'Lista de electores',
            'Cédulas de sufragio usadas',
            'Materiales electorales',
          ],
          consejo: '📦 Verifica que entregues todo completo.',
        ),
        PasoTutorial(
          titulo: '¡Felicitaciones!',
          descripcion: 'Has cumplido tu deber cívico',
          detalle: 'Gracias por tu participación en la democracia. Recuerda registrarte en la web de ONPE para recibir tu compensación de S/ 120.00',
          consejo: '🎉 ¡Excelente trabajo! La democracia te lo agradece.',
        ),
      ],
    ),
  ];

  static List<String> consejosGenerales = [
    '📱 Lleva tu celular cargado para emergencias',
    '🍎 Lleva comida y agua para todo el día',
    '⏰ Sé puntual, llega a las 7:00 AM',
    '📋 Revisa los materiales al recibirlos',
    '🤝 Trabaja en equipo con los otros miembros',
    '😊 Mantén la calma y sé amable con los electores',
    '📞 Ten a mano el número de la ODPE por si necesitas ayuda',
    '✍️ Escribe con letra clara en las actas',
    '👀 Mantén la transparencia en todo momento',
    '🔒 Respeta el secreto del voto',
  ];

  static String horarioCompleto = '''
7:00 AM - Llegada al local de votación
7:00 AM - 8:00 AM - Instalación de la mesa
8:00 AM - Inicio de la votación
8:00 AM - 4:00 PM - Proceso de sufragio
4:00 PM - Cierre de votación
4:00 PM en adelante - Escrutinio y conteo
Variable - Entrega de documentos
''';
}
