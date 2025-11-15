import '../models/local_votacion.dart';

class LocalesVotacionService {
  // Locales de votación en Chimbote (colegios reales con coordenadas verificadas)
  static final List<LocalVotacion> _localesChimbote = [
    // I.E. San Pedro - Colegio emblemático en el centro de Chimbote
    LocalVotacion(
      id: 'local_001',
      nombre: 'I.E. San Pedro',
      direccion: 'Av. José Pardo 850, Chimbote',
      distrito: 'Chimbote',
      latitud: -9.130164898870582,
      longitud: -78.58359912400053,
      referencia: 'A 2 cuadras del Mercado Modelo, centro de Chimbote',
      numeroMesas: 45,
      embedUrl: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126056.60580938209!2d-78.58359912400053!3d-9.130164898870582!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x91ab81440db16f15%3A0x6693a888d484f325!2sInstituci%C3%B3n%20Educativa%20San%20Pedro!5e0!3m2!1ses!2spe!4v1763194048181!5m2!1ses!2spe',
      googleMapsUrl: 'https://maps.app.goo.gl/REj9gQEzTEQeVu2P6',
    ),
    
    // I.E. Politécnico Nacional del Santa - Institución técnica reconocida
    LocalVotacion(
      id: 'local_002',
      nombre: 'Colegio Politécnico de Chimbote',
      direccion: 'Av. Pacífico 508, Chimbote',
      distrito: 'Chimbote',
      latitud: -9.081202793796377,
      longitud: -78.58480592423226,
      referencia: 'Zona industrial, cerca al puerto de Chimbote',
      numeroMesas: 52,
      embedUrl: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3939.8085052702168!2d-78.58480592423226!3d-9.081202793796377!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x91ab8146a4ffffff%3A0x4f789404390b9253!2sColegio%20Politecnico%20De%20Chimbote!5e0!3m2!1ses!2spe!4v1763194101035!5m2!1ses!2spe',
      googleMapsUrl: 'https://maps.app.goo.gl/asjSEQw1qcVNr5pw8',
    ),
    
    // Universidad César Vallejo - Ubicación exacta del mapa
    LocalVotacion(
      id: 'local_003',
      nombre: 'Universidad César Vallejo',
      direccion: 'Av. Guardia Civil 1840, Nuevo Chimbote',
      distrito: 'Nuevo Chimbote',
      latitud: -9.130824785227265,
      longitud: -78.50675546639617,
      referencia: 'Campus universitario, Nuevo Chimbote',
      numeroMesas: 55,
      embedUrl: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d13250.04396660213!2d-78.50675546639617!3d-9.130824785227265!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x91ab85b0459de1d7%3A0xfa78b4dba7db035a!2sUniversidad%20C%C3%A9sar%20Vallejo!5e0!3m2!1ses!2spe!4v1763193329059!5m2!1ses!2spe',
      googleMapsUrl: 'https://maps.app.goo.gl/u54XYJByU4P725Bt9',
    ),
  ];

  // Obtener todos los locales de votación
  Future<List<LocalVotacion>> obtenerLocales() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return _localesChimbote;
  }

  // Buscar local por ID
  Future<LocalVotacion?> obtenerLocalPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _localesChimbote.firstWhere((local) => local.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar locales por distrito
  Future<List<LocalVotacion>> obtenerLocalesPorDistrito(String distrito) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _localesChimbote
        .where((local) => local.distrito.toLowerCase() == distrito.toLowerCase())
        .toList();
  }

  // Buscar locales por nombre
  Future<List<LocalVotacion>> buscarLocales(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final queryLower = query.toLowerCase();
    return _localesChimbote.where((local) {
      return local.nombre.toLowerCase().contains(queryLower) ||
             local.direccion.toLowerCase().contains(queryLower);
    }).toList();
  }

  // Obtener local asignado al usuario (simulado)
  Future<LocalVotacion> obtenerLocalAsignado() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Por ahora retornamos un local aleatorio
    return _localesChimbote[0];
  }
}
