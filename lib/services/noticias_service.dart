import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/noticia.dart';

class NoticiasService {
  // URLs de El Comercio para noticias electorales
  static const String _baseUrl = 'https://elcomercio.pe';
  static const String _politicaUrl = '$_baseUrl/politica';
  static const String _eleccionesUrl = '$_baseUrl/elecciones';
  static const String _elecciones2026Url = '$_baseUrl/politica/elecciones/elecciones-2026';
  static const String _politicaEleccionesUrl = '$_baseUrl/politica/elecciones';
  
  // URLs de partidos políticos específicos
  static const List<String> _urlsPartidos = [
    '$_baseUrl/noticias/fuerza-popular',
    '$_baseUrl/noticias/peru-libre',
    '$_baseUrl/noticias/accion-popular',
    '$_baseUrl/noticias/alianza-para-el-progreso',
    '$_baseUrl/noticias/renovacion-popular',
    '$_baseUrl/noticias/avanza-pais',
    '$_baseUrl/noticias/somos-peru',
    '$_baseUrl/noticias/podemos-peru',
    '$_baseUrl/noticias/juntos-por-el-peru',
  ];
  
  // Palabras clave para filtrar noticias electorales
  static const List<String> _palabrasClaveElectorales = [
    'elecciones',
    'electoral',
    'candidato',
    'candidatos',
    'candidata',
    'candidatas',
    'presidencial',
    'presidente',
    'presidenta',
    'votación',
    'votar',
    'sufragio',
    'jne',
    'onpe',
    'reniec',
    'partido político',
    'partidos políticos',
    'partido',
    'partidos',
    'campaña',
    'debate',
    'segunda vuelta',
    'primera vuelta',
    'comicios',
    'urnas',
    'mesa de sufragio',
    'padrón electoral',
    'inscripción',
    'plan de gobierno',
    'plancha',
    'plancha presidencial',
    'postulante',
    'postulantes',
    'vicepresidente',
    'vicepresidenta',
    'congresista',
    'congreso',
    'alianza',
    'coalición',
    '2026',
    // Partidos políticos principales
    'ahora nación',
    'fuerza popular',
    'perú libre',
    'acción popular',
    'alianza para el progreso',
    'renovación popular',
    'avanza país',
    'somos perú',
    'podemos perú',
    'juntos por el perú',
    'partido morado',
    'frente amplio',
    'partido nacionalista',
    'apra',
    'partido aprista',
    'unión por el perú',
    'victoria nacional',
    'contigo',
    'democracia directa',
    // Líderes políticos conocidos
    'keiko fujimori',
    'rafael lópez aliaga',
    'verónika mendoza',
    'george forsyth',
    'hernando de soto',
    'yonhy lescano',
    'césar acuña',
    'antauro humala',
    'daniel urresti',
    'alberto fujimori',
    'ollanta humala',
    'pedro castillo',
  ];

  // Obtener noticias con refresh
  Future<List<Noticia>> obtenerNoticias() async {
    List<Noticia> todasLasNoticias = [];
    
    try {
      // Lista de futures para todas las fuentes
      final futures = <Future<List<Noticia>>>[
        // Fuentes principales de elecciones
        _obtenerNoticiasDeElecciones2026(),
        _obtenerNoticiasDePoliticaElecciones(),
        _obtenerNoticiasDePolitica(),
        _obtenerNoticiasDeElecciones(),
        
        // Búsquedas específicas
        _obtenerNoticiasDeBusqueda('elecciones 2026'),
        _obtenerNoticiasDeBusqueda('candidatos presidenciales'),
        _obtenerNoticiasDeBusqueda('plancha presidencial'),
      ];
      
      // Agregar fuentes de partidos políticos (solo los primeros 5 para no saturar)
      for (var i = 0; i < _urlsPartidos.length && i < 5; i++) {
        futures.add(_obtenerNoticiasDeUrl(_urlsPartidos[i], 'Partido${i + 1}'));
      }
      
      final resultados = await Future.wait(
        futures,
        eagerError: false,
      );
      
      // Combinar todas las noticias
      for (var noticias in resultados) {
        todasLasNoticias.addAll(noticias);
      }
      
      // Filtrar solo noticias electorales
      todasLasNoticias = _filtrarNoticiasElectorales(todasLasNoticias);
      
      // Eliminar duplicados por título similar
      todasLasNoticias = _eliminarDuplicados(todasLasNoticias);
      
      // Ordenar por fecha
      todasLasNoticias.sort((a, b) => b.fechaPublicacion.compareTo(a.fechaPublicacion));
      
      return todasLasNoticias.isNotEmpty 
          ? todasLasNoticias.take(50).toList() 
          : _obtenerNoticiasEjemplo();
    } catch (e) {
      return _obtenerNoticiasEjemplo();
    }
  }
  
  Future<List<Noticia>> _obtenerNoticiasDeElecciones2026() async {
    try {
      final response = await http.get(
        Uri.parse(_elecciones2026Url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, 'Elecciones2026');
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  Future<List<Noticia>> _obtenerNoticiasDePoliticaElecciones() async {
    try {
      final response = await http.get(
        Uri.parse(_politicaEleccionesUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, 'PoliticaElecciones');
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  Future<List<Noticia>> _obtenerNoticiasDePolitica() async {
    try {
      final response = await http.get(
        Uri.parse(_politicaUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, 'Política');
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  Future<List<Noticia>> _obtenerNoticiasDeElecciones() async {
    try {
      final response = await http.get(
        Uri.parse(_eleccionesUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, 'Elecciones');
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  Future<List<Noticia>> _obtenerNoticiasDeBusqueda(String query) async {
    try {
      final searchUrl = '$_baseUrl/buscar/$query';
      final response = await http.get(
        Uri.parse(searchUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, 'Búsqueda');
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  Future<List<Noticia>> _obtenerNoticiasDeUrl(String url, String seccion) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parsearNoticias(response.body, seccion);
      }
    } catch (e) {
      // Ignorar errores
    }
    return [];
  }
  
  List<Noticia> _filtrarNoticiasElectorales(List<Noticia> noticias) {
    return noticias.where((noticia) {
      final textoCompleto = '${noticia.titulo} ${noticia.descripcion} ${noticia.url}'.toLowerCase();
      
      // Verificar si contiene alguna palabra clave electoral
      final contieneClaveElectoral = _palabrasClaveElectorales.any((palabra) => 
        textoCompleto.contains(palabra.toLowerCase())
      );
      
      // O si la URL contiene rutas electorales
      final urlElectoral = noticia.url.contains('/elecciones') || 
                          noticia.url.contains('/elecciones-2026') ||
                          noticia.url.contains('/candidato');
      
      return contieneClaveElectoral || urlElectoral;
    }).toList();
  }
  
  List<Noticia> _eliminarDuplicados(List<Noticia> noticias) {
    final noticiasUnicas = <String, Noticia>{};
    
    for (var noticia in noticias) {
      // Usar las primeras 50 caracteres del título como clave
      final clave = noticia.titulo.toLowerCase().substring(
        0, 
        noticia.titulo.length > 50 ? 50 : noticia.titulo.length
      );
      
      if (!noticiasUnicas.containsKey(clave)) {
        noticiasUnicas[clave] = noticia;
      }
    }
    
    return noticiasUnicas.values.toList();
  }

  List<Noticia> _parsearNoticias(String html, String seccion) {
    final document = html_parser.parse(html);
    final noticias = <Noticia>[];

    try {
      // Buscar artículos de noticias con múltiples selectores
      final selectores = [
        'article',
        '.story-item',
        '.news-item',
        '.story',
        '.nota',
        '.card-news',
        '[class*="story"]',
        '[class*="article"]',
      ];
      
      var articulos = <dynamic>[];
      for (var selector in selectores) {
        final elementos = document.querySelectorAll(selector);
        if (elementos.isNotEmpty) {
          articulos.addAll(elementos);
          if (articulos.length > 50) break;
        }
      }

      for (var i = 0; i < articulos.length && i < 50; i++) {
        final articulo = articulos[i];
        
        // Extraer título con múltiples selectores
        final tituloSelectores = [
          'h2', 'h3', 'h4',
          '.story-item__title',
          '.title',
          '[class*="title"]',
          '[class*="headline"]',
        ];
        
        String titulo = '';
        for (var selector in tituloSelectores) {
          final element = articulo.querySelector(selector);
          if (element != null && element.text.trim().isNotEmpty) {
            titulo = element.text.trim();
            break;
          }
        }
        
        if (titulo.isEmpty || titulo.length < 10) continue;

        // Extraer URL
        final linkElement = articulo.querySelector('a');
        var url = linkElement?.attributes['href'] ?? '';
        if (url.isEmpty) continue;
        
        if (!url.startsWith('http')) {
          url = _baseUrl + (url.startsWith('/') ? url : '/$url');
        }

        // Extraer descripción
        final descripcionSelectores = [
          'p',
          '.story-item__subtitle',
          '.description',
          '.summary',
          '[class*="description"]',
          '[class*="summary"]',
        ];
        
        String descripcion = '';
        for (var selector in descripcionSelectores) {
          final element = articulo.querySelector(selector);
          if (element != null && element.text.trim().isNotEmpty) {
            descripcion = element.text.trim();
            break;
          }
        }
        
        if (descripcion.isEmpty) {
          descripcion = titulo;
        }

        // Extraer imagen
        final imgElement = articulo.querySelector('img');
        String? imagenUrl;
        if (imgElement != null) {
          imagenUrl = imgElement.attributes['src'] ?? 
                     imgElement.attributes['data-src'] ?? 
                     imgElement.attributes['data-lazy-src'] ??
                     imgElement.attributes['data-original'];
          
          // Si la imagen es relativa, hacerla absoluta
          if (imagenUrl != null && !imagenUrl.startsWith('http')) {
            imagenUrl = _baseUrl + (imagenUrl.startsWith('/') ? imagenUrl : '/$imagenUrl');
          }
        }

        noticias.add(Noticia(
          id: 'noticia_${seccion}_$i',
          titulo: titulo,
          descripcion: descripcion,
          url: url,
          imagenUrl: imagenUrl,
          fechaPublicacion: DateTime.now().subtract(Duration(minutes: i * 15)),
          fuente: 'El Comercio',
        ));
      }
    } catch (e) {
      // Si falla el parseo, retornar lista vacía
      return [];
    }

    return noticias;
  }

  // Noticias de ejemplo para cuando no se puede conectar
  List<Noticia> _obtenerNoticiasEjemplo() {
    return [
      Noticia(
        id: '1',
        titulo: 'Elecciones 2026: Todo lo que debes saber sobre el proceso electoral',
        descripcion: 'Conoce las fechas importantes, requisitos y procedimientos para las próximas elecciones presidenciales en Perú.',
        url: '$_baseUrl/politica/elecciones-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(hours: 2)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '2',
        titulo: 'JNE inicia proceso de inscripción de candidatos presidenciales para elecciones 2026',
        descripcion: 'El Jurado Nacional de Elecciones anunció el inicio del periodo de inscripción para candidatos a la presidencia.',
        url: '$_baseUrl/politica/jne-inscripcion-candidatos-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(hours: 5)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '3',
        titulo: 'ONPE presenta nuevo sistema de votación electrónica para comicios 2026',
        descripcion: 'La Oficina Nacional de Procesos Electorales mostró las mejoras tecnológicas que se implementarán en las elecciones.',
        url: '$_baseUrl/politica/onpe-sistema-votacion',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(hours: 8)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '4',
        titulo: 'Partidos políticos presentan sus planes de gobierno para elecciones presidenciales',
        descripcion: 'Los principales partidos políticos han comenzado a presentar sus propuestas para el periodo presidencial 2026-2031.',
        url: '$_baseUrl/politica/planes-gobierno-partidos',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(hours: 12)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '5',
        titulo: 'Cronograma electoral 2026: fechas clave para las elecciones presidenciales',
        descripcion: 'Revisa el calendario completo del proceso electoral, desde la inscripción de candidatos hasta la segunda vuelta.',
        url: '$_baseUrl/politica/cronograma-electoral-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 1)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '6',
        titulo: 'Debate presidencial 2026: conoce las fechas y formato de los debates electorales',
        descripcion: 'El JNE confirmó las fechas de los debates presidenciales que se realizarán antes de la primera vuelta electoral.',
        url: '$_baseUrl/politica/debates-presidenciales-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '7',
        titulo: 'Padrón electoral 2026: verifica si estás habilitado para votar en las elecciones',
        descripcion: 'RENIEC publicó el padrón electoral actualizado. Conoce cómo verificar tu local de votación y mesa de sufragio.',
        url: '$_baseUrl/politica/padron-electoral-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 2)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '8',
        titulo: 'Encuestas electorales 2026: últimas mediciones de intención de voto presidencial',
        descripcion: 'Conoce los resultados de las últimas encuestas sobre las preferencias electorales para las elecciones presidenciales.',
        url: '$_baseUrl/politica/encuestas-electorales-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '9',
        titulo: 'Miembros de mesa electoral 2026: conoce tus derechos y obligaciones',
        descripcion: 'Si fuiste sorteado como miembro de mesa, aquí te explicamos todo lo que necesitas saber para el día de las elecciones.',
        url: '$_baseUrl/politica/miembros-mesa-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 3)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '10',
        titulo: 'Voto electrónico en elecciones 2026: ¿en qué distritos se implementará?',
        descripcion: 'La ONPE anunció los distritos donde se probará el sistema de voto electrónico en las próximas elecciones presidenciales.',
        url: '$_baseUrl/politica/voto-electronico-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 3, hours: 12)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '11',
        titulo: 'Candidatos presidenciales 2026: perfil de los postulantes inscritos',
        descripcion: 'Conoce a los candidatos que buscan llegar a la presidencia en las elecciones 2026 y sus principales propuestas.',
        url: '$_baseUrl/politica/candidatos-presidenciales-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 4)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '12',
        titulo: 'Financiamiento de campaña electoral: JNE establece límites para elecciones 2026',
        descripcion: 'El Jurado Nacional de Elecciones fijó los topes de gastos de campaña para los candidatos presidenciales.',
        url: '$_baseUrl/politica/financiamiento-campana-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 5)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '13',
        titulo: 'Fuerza Popular inscribe a su candidato presidencial para elecciones 2026',
        descripcion: 'El partido liderado por Keiko Fujimori presentó oficialmente su plancha presidencial ante el JNE.',
        url: '$_baseUrl/politica/fuerza-popular-candidato-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 6)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '14',
        titulo: 'Renovación Popular anuncia alianza estratégica para elecciones presidenciales',
        descripcion: 'Rafael López Aliaga confirmó conversaciones con otros partidos para formar una coalición electoral.',
        url: '$_baseUrl/politica/renovacion-popular-alianza-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 7)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '15',
        titulo: 'Acción Popular presenta su plan de gobierno para el periodo 2026-2031',
        descripcion: 'El partido fundado por Fernando Belaúnde Terry dio a conocer sus principales propuestas electorales.',
        url: '$_baseUrl/politica/accion-popular-plan-gobierno-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 8)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '16',
        titulo: 'Alianza para el Progreso confirma participación en elecciones 2026',
        descripcion: 'César Acuña anunció que su partido presentará candidato presidencial para los próximos comicios.',
        url: '$_baseUrl/politica/app-elecciones-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 9)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '17',
        titulo: 'Partidos políticos inician campaña de afiliación para elecciones 2026',
        descripcion: 'Las agrupaciones políticas buscan sumar militantes para cumplir con los requisitos del JNE.',
        url: '$_baseUrl/politica/afiliacion-partidos-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 10)),
        fuente: 'El Comercio',
      ),
      Noticia(
        id: '18',
        titulo: 'Somos Perú evalúa candidatos para representar al partido en elecciones presidenciales',
        descripcion: 'La dirigencia del partido realiza consultas internas para definir su plancha presidencial.',
        url: '$_baseUrl/politica/somos-peru-candidatos-2026',
        imagenUrl: null,
        fechaPublicacion: DateTime.now().subtract(const Duration(days: 11)),
        fuente: 'El Comercio',
      ),
    ];
  }

  // Buscar noticias por palabra clave
  Future<List<Noticia>> buscarNoticias(String query) async {
    final noticias = await obtenerNoticias();
    return noticias.where((noticia) {
      return noticia.titulo.toLowerCase().contains(query.toLowerCase()) ||
             noticia.descripcion.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
