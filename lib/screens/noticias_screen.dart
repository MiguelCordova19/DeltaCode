import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/noticia.dart';
import '../services/noticias_service.dart';
import '../services/gamificacion_service.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiasService _noticiasService = NoticiasService();
  final GamificacionService _gamificacionService = GamificacionService();
  List<Noticia> _noticias = [];
  List<Noticia> _noticiasFiltradas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _primeraNoticiaLeida = false;

  @override
  void initState() {
    super.initState();
    _cargarNoticias();
    _cargarEstadoLogro();
  }
  
  Future<void> _cargarEstadoLogro() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _primeraNoticiaLeida = puntos.logros.any((l) => l.id == 'ciudadano_informado');
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarNoticias() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final noticias = await _noticiasService.obtenerNoticias();
      setState(() {
        _noticias = noticias;
        _noticiasFiltradas = noticias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar noticias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filtrarNoticias(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _noticiasFiltradas = _noticias;
      } else {
        _noticiasFiltradas = _noticias.where((noticia) {
          return noticia.titulo.toLowerCase().contains(query.toLowerCase()) ||
                 noticia.descripcion.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _abrirNoticia(String url) async {
    try {
      final uri = Uri.parse(url);
      
      // Otorgar logro si es la primera noticia
      if (!_primeraNoticiaLeida) {
        await _otorgarLogroPrimeraNoticia();
      }
      
      // Intentar abrir directamente sin verificar primero
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir: $url'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Copiar',
              textColor: Colors.white,
              onPressed: () {
                // Aquí podrías copiar al portapapeles si agregas el paquete
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _otorgarLogroPrimeraNoticia() async {
    try {
      await _gamificacionService.agregarPuntos(
        puntos: GamificacionService.PUNTOS_LEER_NOTICIA,
        descripcion: 'Leíste tu primera noticia electoral',
        logroId: 'ciudadano_informado',
        logroTitulo: '📰 Ciudadano Informado',
        logroDescripcion: 'Lee tu primera noticia electoral',
        logroIcono: '📰',
      );
      
      setState(() {
        _primeraNoticiaLeida = true;
      });
      
      if (mounted) {
        await _mostrarDialogoLogro(
          icono: '📰',
          titulo: '¡Logro desbloqueado!',
          descripcion: 'Ciudadano Informado',
          puntos: GamificacionService.PUNTOS_LEER_NOTICIA,
        );
      }
    } catch (e) {
      print('Error al otorgar logro: $e');
    }
  }
  
  Future<void> _abrirCanalWhatsApp() async {
    const url = 'https://www.whatsapp.com/channel/0029Va43BaoDJ6GxDREkbp3k';
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('No se pudo abrir el canal de WhatsApp'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error al abrir WhatsApp: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
  
  Future<void> _mostrarDialogoLogro({
    required String icono,
    required String titulo,
    required String descripcion,
    required int puntos,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo[400]!,
                Colors.blue[400]!,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono animado
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          icono,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                descripcion,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$puntos puntos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Noticias Electorales'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
            tooltip: 'Canal de WhatsApp',
            onPressed: () => _abrirCanalWhatsApp(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con búsqueda
          Container(
            color: const Color(0xFFE53935),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Barra de búsqueda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filtrarNoticias,
                    decoration: InputDecoration(
                      hintText: 'Buscar noticias...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFE53935)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filtrarNoticias('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Info de actualización
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fuente: El Comercio',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _cargarNoticias,
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                      label: const Text(
                        'Actualizar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de noticias
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE53935),
                    ),
                  )
                : _noticiasFiltradas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.newspaper,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No hay noticias disponibles'
                                  : 'No se encontraron noticias',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _cargarNoticias,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _cargarNoticias,
                        color: const Color(0xFFE53935),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _noticiasFiltradas.length,
                          itemBuilder: (context, index) {
                            final noticia = _noticiasFiltradas[index];
                            return _NoticiaCard(
                              noticia: noticia,
                              onTap: () => _abrirNoticia(noticia.url),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onTap;

  const _NoticiaCard({
    required this.noticia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen si existe
              if (noticia.imagenUrl != null && noticia.imagenUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    noticia.imagenUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 48),
                      );
                    },
                  ),
                ),
              if (noticia.imagenUrl != null && noticia.imagenUrl!.isNotEmpty)
                const SizedBox(height: 12),

              // Título
              Text(
                noticia.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Descripción
              Text(
                noticia.descripcion,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer con fuente
              Row(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      noticia.fuente,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFFE53935),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
