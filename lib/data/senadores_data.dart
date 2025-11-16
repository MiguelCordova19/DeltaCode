import '../models/senador.dart';

class SenadoresData {
  static List<Senador> getPrecandidatosNacionales() {
    return [
      // ACCIÓN POPULAR
      Senador(
        id: 'ap_sn1',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'ap_sn2',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'ap_sn3',
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
        tipo: TipoSenador.nacional,
      ),

      // FUERZA POPULAR
      Senador(
        id: 'fp_sn1',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'fp_sn2',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'fp_sn3',
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
        tipo: TipoSenador.nacional,
      ),

      // ALIANZA PARA EL PROGRESO
      Senador(
        id: 'app_sn1',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'app_sn2',
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
        tipo: TipoSenador.nacional,
      ),
      Senador(
        id: 'app_sn3',
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
        tipo: TipoSenador.nacional,
      ),
    ];
  }

  static List<Senador> getPrecandidatosRegionales() {
    return [
      // AMAZONAS
      Senador(
        id: 'amazonas_1',
        nombre: 'Raúl Medina Tafur',
        propuestas: ['Desarrollo regional', 'Infraestructura local'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Amazonas',
      ),
      Senador(
        id: 'amazonas_2',
        nombre: 'Lucía Torres Huamán',
        propuestas: ['Educación rural', 'Salud comunitaria'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Amazonas',
      ),
      Senador(
        id: 'amazonas_3',
        nombre: 'Kevin Bravo Salaverry',
        propuestas: ['Turismo sostenible', 'Agricultura familiar'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Amazonas',
      ),

      // ÁNCASH
      Senador(
        id: 'ancash_1',
        nombre: 'Marcos Lázaro Castillo',
        propuestas: ['Minería responsable', 'Desarrollo sostenible'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Áncash',
      ),
      Senador(
        id: 'ancash_2',
        nombre: 'Yesenia Huerta Silva',
        propuestas: ['Protección ambiental', 'Turismo de aventura'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Áncash',
      ),
      Senador(
        id: 'ancash_3',
        nombre: 'Diego Cervantes Rivas',
        propuestas: ['Infraestructura vial', 'Conectividad regional'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Áncash',
      ),

      // APURÍMAC
      Senador(
        id: 'apurimac_1',
        nombre: 'Leandro Ccorahua Mita',
        propuestas: ['Agricultura andina', 'Desarrollo rural'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Apurímac',
      ),
      Senador(
        id: 'apurimac_2',
        nombre: 'Brenda Cotrina Huayta',
        propuestas: ['Educación bilingüe', 'Cultura ancestral'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Apurímac',
      ),
      Senador(
        id: 'apurimac_3',
        nombre: 'Paul Huamán Quispe',
        propuestas: ['Ganadería sostenible', 'Acceso a mercados'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Apurímac',
      ),

      // AREQUIPA
      Senador(
        id: 'arequipa_1',
        nombre: 'Mauricio Ibáñez Salcedo',
        propuestas: ['Desarrollo industrial', 'Innovación tecnológica'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Arequipa',
      ),
      Senador(
        id: 'arequipa_2',
        nombre: 'Cindy Flores Barreda',
        propuestas: ['Emprendimiento juvenil', 'Educación superior'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Arequipa',
      ),
      Senador(
        id: 'arequipa_3',
        nombre: 'Frank Zúñiga Núñez',
        propuestas: ['Turismo cultural', 'Patrimonio histórico'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Arequipa',
      ),

      // AYACUCHO
      Senador(
        id: 'ayacucho_1',
        nombre: 'Julián Huayllasco Cárdenas',
        propuestas: ['Paz y reconciliación', 'Desarrollo comunitario'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Ayacucho',
      ),
      Senador(
        id: 'ayacucho_2',
        nombre: 'Rosa Poma Flores',
        propuestas: ['Artesanía local', 'Comercio justo'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Ayacucho',
      ),
      Senador(
        id: 'ayacucho_3',
        nombre: 'Diego Gutiérrez Álvarez',
        propuestas: ['Agricultura familiar', 'Seguridad alimentaria'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Ayacucho',
      ),

      // LIMA METROPOLITANA
      Senador(
        id: 'lima_1',
        nombre: 'Sebastián Torres Maldonado',
        propuestas: ['Transporte público', 'Movilidad urbana'],
        partido: 'Acción Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Lima Metropolitana',
      ),
      Senador(
        id: 'lima_2',
        nombre: 'Patricia Díaz Ramos',
        propuestas: ['Seguridad ciudadana', 'Espacios públicos'],
        partido: 'Fuerza Popular',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Lima Metropolitana',
      ),
      Senador(
        id: 'lima_3',
        nombre: 'Eduardo Sánchez Villa',
        propuestas: ['Desarrollo urbano', 'Vivienda social'],
        partido: 'Alianza para el Progreso',
        estado: EstadoSenador.precandidato,
        tipo: TipoSenador.regional,
        region: 'Lima Metropolitana',
      ),
    ];
  }

  static List<Senador> getCandidatosOficiales() {
    return [];
  }

  // Obtener todas las regiones únicas
  static List<String> getRegiones() {
    final regionales = getPrecandidatosRegionales();
    return regionales.map((s) => s.region!).toSet().toList()..sort();
  }
}
