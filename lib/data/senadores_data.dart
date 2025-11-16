import '../models/senador.dart';

class SenadoresData {
  static List<Senador> getPrecandidatos() {
    return [
      // ACCIÓN POPULAR
      Senador(
        id: 'ap_s1',
        nombre: 'María Fernanda Quiroz',
        edad: 49,
        profesion: 'Abogada constitucionalista',
        biografia: 'Experta en reformas políticas con 20 años de trayectoria.',
        propuestas: [
          'Reforma del sistema de justicia',
          'Impulso a la transparencia pública',
          'Fortalecimiento del Estado de derecho',
        ],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'ap_s2',
        nombre: 'Luis Alberto Ramos',
        edad: 54,
        profesion: 'Economista',
        biografia: 'Especialista en economía pública y gestión estatal.',
        propuestas: [
          'Reducción de trámites burocráticos',
          'Modernización del gasto público',
          'Eficiencia en la administración pública',
        ],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'ap_s3',
        nombre: 'Carolina Mendoza',
        edad: 42,
        profesion: 'Profesora universitaria',
        biografia: 'Docente y activista por la mejora en la educación pública.',
        propuestas: [
          'Mejora magisterial',
          'Acceso equitativo a educación de calidad',
          'Inversión en investigación científica',
        ],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
      ),

      // FUERZA POPULAR
      Senador(
        id: 'fp_s1',
        nombre: 'Gabriel Soto',
        edad: 50,
        profesion: 'Administrador',
        biografia: 'Analista político con énfasis en gestión pública.',
        propuestas: [
          'Impulso a la inversión extranjera',
          'Programas de empleo juvenil',
          'Desarrollo económico sostenible',
        ],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'fp_s2',
        nombre: 'Andrea Chacón',
        edad: 45,
        profesion: 'Ingeniera industrial',
        biografia: 'Experiencia en proyectos de infraestructura nacional.',
        propuestas: [
          'Modernización del transporte',
          'Inversión en infraestructura educativa',
          'Desarrollo de carreteras nacionales',
        ],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'fp_s3',
        nombre: 'Dario Gálvez',
        edad: 58,
        profesion: 'Abogado',
        biografia: 'Experto en derecho penal y políticas anticorrupción.',
        propuestas: [
          'Endurecimiento de penas por corrupción',
          'Ley de protección al denunciante',
          'Reforma del sistema judicial',
        ],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
      ),

      // ALIANZA PARA EL PROGRESO
      Senador(
        id: 'app_s1',
        nombre: 'Silvia Benavides',
        edad: 47,
        profesion: 'Médica cirujana',
        biografia: 'Defensora de políticas de salud pública.',
        propuestas: [
          'Mejora en hospitales regionales',
          'Acceso universal a medicinas esenciales',
          'Fortalecimiento del sistema de salud',
        ],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'app_s2',
        nombre: 'Julio Pacheco',
        edad: 52,
        profesion: 'Empresario',
        biografia: 'Promotor de iniciativas de desarrollo regional.',
        propuestas: [
          'Apoyo a pequeñas empresas',
          'Incentivos tributarios a emprendedores',
          'Fomento del comercio local',
        ],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'app_s3',
        nombre: 'Rosa Quispe',
        edad: 43,
        profesion: 'Socióloga',
        biografia: 'Investigadora de temas sociales y equidad.',
        propuestas: [
          'Lucha contra la violencia de género',
          'Inclusión social a nivel nacional',
          'Programas de desarrollo comunitario',
        ],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
      ),

      // RENOVACIÓN POPULAR
      Senador(
        id: 'rp_s1',
        nombre: 'Ricardo Morales',
        edad: 55,
        profesion: 'Empresario',
        biografia: 'Defensor de la libre empresa y el mercado.',
        propuestas: [
          'Reducción del tamaño del Estado',
          'Libertad económica',
          'Simplificación tributaria',
        ],
        partido: 'Renovación Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'rp_s2',
        nombre: 'Patricia Vargas',
        edad: 48,
        profesion: 'Abogada',
        biografia: 'Especialista en derecho empresarial.',
        propuestas: [
          'Seguridad jurídica para inversiones',
          'Protección de la propiedad privada',
          'Modernización del código civil',
        ],
        partido: 'Renovación Popular',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'rp_s3',
        nombre: 'Fernando Castro',
        edad: 51,
        profesion: 'Ingeniero',
        biografia: 'Experto en infraestructura y desarrollo urbano.',
        propuestas: [
          'Desarrollo de ciudades inteligentes',
          'Inversión privada en infraestructura',
          'Modernización del transporte público',
        ],
        partido: 'Renovación Popular',
        estado: EstadoSenador.precandidato,
      ),

      // PARTIDO MORADO
      Senador(
        id: 'pm_s1',
        nombre: 'Daniela Torres',
        edad: 44,
        profesion: 'Politóloga',
        biografia: 'Activista por la reforma política y la transparencia.',
        propuestas: [
          'Reforma del sistema electoral',
          'Transparencia en el financiamiento político',
          'Participación ciudadana efectiva',
        ],
        partido: 'Partido Morado',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'pm_s2',
        nombre: 'Miguel Ángel Ruiz',
        edad: 46,
        profesion: 'Ingeniero de sistemas',
        biografia: 'Promotor de la transformación digital del Estado.',
        propuestas: [
          'Gobierno digital',
          'Modernización tecnológica del Estado',
          'Ciberseguridad nacional',
        ],
        partido: 'Partido Morado',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'pm_s3',
        nombre: 'Lucía Fernández',
        edad: 41,
        profesion: 'Economista',
        biografia: 'Especialista en políticas públicas y desarrollo social.',
        propuestas: [
          'Reducción de la desigualdad',
          'Programas sociales eficientes',
          'Desarrollo económico inclusivo',
        ],
        partido: 'Partido Morado',
        estado: EstadoSenador.precandidato,
      ),

      // AVANZA PAÍS
      Senador(
        id: 'avp_s1',
        nombre: 'Jorge Ramírez',
        edad: 53,
        profesion: 'Economista',
        biografia: 'Experto en políticas económicas liberales.',
        propuestas: [
          'Apertura comercial',
          'Reducción de barreras burocráticas',
          'Fomento de la competitividad',
        ],
        partido: 'Avanza País – Partido de Integración Social',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'avp_s2',
        nombre: 'Elena Gutiérrez',
        edad: 47,
        profesion: 'Abogada',
        biografia: 'Defensora de los derechos de propiedad.',
        propuestas: [
          'Formalización de la propiedad',
          'Acceso al crédito',
          'Seguridad jurídica',
        ],
        partido: 'Avanza País – Partido de Integración Social',
        estado: EstadoSenador.precandidato,
      ),
      Senador(
        id: 'avp_s3',
        nombre: 'Carlos Mendoza',
        edad: 50,
        profesion: 'Empresario',
        biografia: 'Promotor del emprendimiento y la innovación.',
        propuestas: [
          'Apoyo a startups',
          'Incentivos a la innovación',
          'Desarrollo del ecosistema emprendedor',
        ],
        partido: 'Avanza País – Partido de Integración Social',
        estado: EstadoSenador.precandidato,
      ),
    ];
  }

  static List<Senador> getCandidatosOficiales() {
    return [];
  }
}
