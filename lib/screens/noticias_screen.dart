import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/noticia.dart';
import '../services/noticias_service.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiasService _noticiasService = NoticiasService();
  List<Noticia> _noticias = [];
  List<Noticia> _noticiasFiltradas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarNoticias();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Noticias Electorales'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con búsqueda
          Container(
            color: const Color(0xFF7C4DFF),
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
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF7C4DFF)),
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
                      color: Color(0xFF7C4DFF),
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
                        color: const Color(0xFF7C4DFF),
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
                      color: const Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      noticia.fuente,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C4DFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF7C4DFF),
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
