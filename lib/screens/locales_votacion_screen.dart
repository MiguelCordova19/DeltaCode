import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/local_votacion.dart';
import '../services/locales_votacion_service.dart';
import 'mapa_local_screen.dart';

class LocalesVotacionScreen extends StatefulWidget {
  const LocalesVotacionScreen({super.key});

  @override
  State<LocalesVotacionScreen> createState() => _LocalesVotacionScreenState();
}

class _LocalesVotacionScreenState extends State<LocalesVotacionScreen> {
  final LocalesVotacionService _service = LocalesVotacionService();
  List<LocalVotacion> _locales = [];
  List<LocalVotacion> _localesFiltrados = [];
  bool _isLoading = true;
  String _filtroDistrito = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarLocales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarLocales() async {
    setState(() => _isLoading = true);
    try {
      final locales = await _service.obtenerLocales();
      setState(() {
        _locales = locales;
        _localesFiltrados = locales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarLocales() {
    setState(() {
      _localesFiltrados = _locales.where((local) {
        final matchDistrito = _filtroDistrito == 'Todos' || 
                              local.distrito == _filtroDistrito;
        final matchBusqueda = _searchController.text.isEmpty ||
                              local.nombre.toLowerCase().contains(
                                _searchController.text.toLowerCase()) ||
                              local.direccion.toLowerCase().contains(
                                _searchController.text.toLowerCase());
        return matchDistrito && matchBusqueda;
      }).toList();
    });
  }

  Future<void> _abrirEnMapa(LocalVotacion local, String app) async {
    try {
      final url = app == 'google' ? local.urlGoogleMaps : local.urlWaze;
      final uri = Uri.parse(url);
      
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir $app Maps'),
            backgroundColor: Colors.red,
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
  
  Future<void> _abrirDirecciones(LocalVotacion local) async {
    try {
      final uri = Uri.parse(local.urlGoogleMapsDirections);
      
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Google Maps'),
            backgroundColor: Colors.red,
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

  void _mostrarOpcionesMapa(LocalVotacion local) {
    // Si tiene embedUrl, ir directo a la pantalla del mapa
    if (local.embedUrl != null && local.embedUrl!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapaLocalScreen(local: local),
        ),
      );
    } else {
      // Si no tiene embedUrl, mostrar opciones
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                local.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                local.direccion,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.map, color: Colors.blue),
                ),
                title: const Text('Ver ubicación en Google Maps'),
                subtitle: const Text('Ver el lugar en el mapa'),
                onTap: () {
                  Navigator.pop(context);
                  _abrirEnMapa(local, 'google');
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions, color: Colors.green),
                ),
                title: const Text('Cómo llegar (Google Maps)'),
                subtitle: const Text('Iniciar navegación paso a paso'),
                onTap: () {
                  Navigator.pop(context);
                  _abrirDirecciones(local);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.navigation, color: Colors.cyan),
                ),
                title: const Text('Abrir en Waze'),
                subtitle: const Text('Navegación en tiempo real'),
                onTap: () {
                  Navigator.pop(context);
                  _abrirEnMapa(local, 'waze');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final distritos = ['Todos', 'Chimbote', 'Nuevo Chimbote'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Locales de Votación'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con búsqueda y filtros
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
                    onChanged: (_) => _filtrarLocales(),
                    decoration: InputDecoration(
                      hintText: 'Buscar local...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF7C4DFF)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filtrarLocales();
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
                // Filtro de distrito
                Row(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: distritos.map((distrito) {
                            final isSelected = _filtroDistrito == distrito;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(distrito),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _filtroDistrito = distrito;
                                    _filtrarLocales();
                                  });
                                },
                                backgroundColor: Colors.white.withOpacity(0.2),
                                selectedColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de locales
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C4DFF),
                    ),
                  )
                : _localesFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron locales',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _localesFiltrados.length,
                        itemBuilder: (context, index) {
                          final local = _localesFiltrados[index];
                          return _LocalCard(
                            local: local,
                            onTap: () => _mostrarOpcionesMapa(local),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _LocalCard extends StatelessWidget {
  final LocalVotacion local;
  final VoidCallback onTap;

  const _LocalCard({
    required this.local,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: Color(0xFF7C4DFF),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            local.direccion,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (local.referencia != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        local.referencia!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            local.distrito,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.how_to_vote, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${local.numeroMesas} mesas',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF7C4DFF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
