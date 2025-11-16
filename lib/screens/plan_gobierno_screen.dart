import 'dart:io';
import 'package:flutter/material.dart';
import '../models/partido_politico.dart';
import '../models/plan_gobierno.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';
import '../services/gamificacion_service.dart';
import '../widgets/tts_config_dialog.dart';

class PlanGobiernoScreen extends StatefulWidget {
  const PlanGobiernoScreen({super.key});

  @override
  State<PlanGobiernoScreen> createState() => _PlanGobiernoScreenState();
}

class _PlanGobiernoScreenState extends State<PlanGobiernoScreen> {
  PartidoPolitico? _selectedPartido;
  PlanGobierno? _planGobierno;
  int _selectedCategoryIndex = 0;
  final List<PartidoPolitico> _partidos = PartidoPolitico.getPartidos();
  List<PartidoPolitico> _filteredPartidos = [];
  List<String> _categories = [];
  final TextEditingController _searchController = TextEditingController();
  
  // TTS
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  double _progress = 0.0;

  bool get _isReading => _ttsService.isPlaying;
  bool get _isPaused => _ttsService.isPaused;
  
  // Gamificación
  final GamificacionService _gamificacionService = GamificacionService();
  bool _primerPlanLeido = false;

  @override
  void initState() {
    super.initState();
    _filteredPartidos = _partidos;
    _ttsService.initialize();
    
    _ttsService.onStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };

    _ttsService.onProgress = (current, total) {
      if (mounted) {
        setState(() {
          _progress = current / total;
        });
      }
    };
    
    _searchController.addListener(_filterPartidos);
    _cargarEstadoLogro();
  }
  
  Future<void> _cargarEstadoLogro() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _primerPlanLeido = puntos.logros.any((l) => l.id == 'primer_plan_leido');
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _ttsService.onStateChanged = null;
    _ttsService.onProgress = null;
    _ttsService.stop();
    super.dispose();
  }

  void _filterPartidos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPartidos = _partidos;
      } else {
        _filteredPartidos = _partidos.where((partido) {
          return partido.nombre.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  
  Future<void> _otorgarLogroPrimerPlan() async {
    try {
      await _gamificacionService.agregarPuntos(
        puntos: GamificacionService.PUNTOS_LEER_PLAN,
        descripcion: 'Leíste tu primer plan de gobierno',
        logroId: 'primer_plan_leido',
        logroTitulo: '📖 Primer Plan Leído',
        logroDescripcion: 'Lee tu primer plan de gobierno completo',
        logroIcono: '📖',
      );
      
      setState(() {
        _primerPlanLeido = true;
      });
      
      // Mostrar diálogo de logro y esperar a que se cierre
      if (mounted) {
        await _mostrarDialogoLogro(
          icono: '📖',
          titulo: '¡Logro desbloqueado!',
          descripcion: 'Primer Plan Leído',
          puntos: GamificacionService.PUNTOS_LEER_PLAN,
        );
      }
    } catch (e) {
      print('Error al otorgar logro: $e');
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
                Colors.green[400]!,
                Colors.teal[400]!,
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
                  foregroundColor: Colors.teal[700],
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

  void _showConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => TtsConfigDialog(
        currentConfig: _ttsService.config,
        onConfigChanged: (newConfig) async {
          await _ttsService.updateConfig(newConfig);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Configuración de voz guardada'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  void _toggleReadAll() async {
    if (_isReading && !_isPaused) {
      await _ttsService.pause();
    } else if (_isPaused) {
      await _ttsService.resume();
    } else {
      _readCurrentCategory();
    }
  }

  void _stopReading() async {
    await _ttsService.stop();
  }

  void _readCurrentCategory() {
    if (_planGobierno == null) return;
    
    final category = _categories[_selectedCategoryIndex];
    final proposals = _planGobierno!.getPropuestas(category);
    
    _ttsService.speakPageContent(
      titulo: 'Plan de Gobierno de ${_selectedPartido!.nombre}',
      subtitulo: 'Categoría: $category',
      contenido: proposals.join('. '),
    );
  }

  List<String> _getCurrentProposals() {
    if (_planGobierno == null) return [];
    final category = _categories[_selectedCategoryIndex];
    return _planGobierno!.getPropuestas(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: _selectedPartido != null
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  _ttsService.stop();
                  
                  // Otorgar logro si es la primera vez
                  if (!_primerPlanLeido) {
                    await _otorgarLogroPrimerPlan();
                  }
                  
                  setState(() {
                    _selectedPartido = null;
                  });
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.how_to_vote,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Elecciones 2026',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_voice),
                  color: const Color(0xFFE53935),
                  onPressed: _showConfigDialog,
                  tooltip: 'Configurar voz',
                ),
                if (_isReading)
                  IconButton(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    color: const Color(0xFFE53935),
                    onPressed: _toggleReadAll,
                    tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                  ),
                if (_isReading)
                  IconButton(
                    icon: const Icon(Icons.stop_circle),
                    color: Colors.red,
                    onPressed: _stopReading,
                    tooltip: 'Detener lectura',
                  ),
              ],
            )
          : null,
      body: _selectedPartido == null ? _buildPartidosList() : _buildPlanDetalle(),
      floatingActionButton: _selectedPartido != null
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: _isReading
                  ? Row(
                      key: const ValueKey('reading'),
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: 'pause_plan',
                          onPressed: _toggleReadAll,
                          backgroundColor: _isPaused ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                          tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                          child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          heroTag: 'stop_plan',
                          onPressed: _stopReading,
                          backgroundColor: const Color(0xFFD32F2F),
                          tooltip: 'Detener',
                          child: const Icon(Icons.stop),
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      key: const ValueKey('not-reading'),
                      onPressed: _toggleReadAll,
                      backgroundColor: const Color(0xFFE53935),
                      icon: const Icon(Icons.volume_up),
                      label: Text('Leer ${_categories[_selectedCategoryIndex]}'),
                    ),
            )
          : null,
    );
  }

  Widget _buildPartidosList() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          // Header con gradiente rojo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE53935), // Rojo principal
                  Color(0xFFEF5350), // Rojo más claro
                ],
              ),
            ),
            child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Barra superior con título
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Planes de Gobierno',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance para el back button
                    ],
                  ),
                ),
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFD32F2F).withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD32F2F).withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar partido político...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFD32F2F),
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFFD32F2F),
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Lista de partidos
        Expanded(
          child: _filteredPartidos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron partidos',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredPartidos.length,
                  itemBuilder: (context, index) {
                    return _buildPartidoCard(_filteredPartidos[index]);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartidoCard(PartidoPolitico partido) {
    final plan = PlanGobierno.getPlanByPartidoId(partido.id);
    
    // Determinar el estado del plan
    String estadoTexto;
    IconData estadoIcono;
    Color estadoColor;
    
    if (plan == null) {
      estadoTexto = 'Sin información';
      estadoIcono = Icons.error_outline;
      estadoColor = Colors.red;
    } else {
      switch (plan.estadoPlan) {
        case 'completo':
          estadoTexto = 'Plan 2026 disponible';
          estadoIcono = Icons.check_circle;
          estadoColor = Colors.green;
          break;
        case 'antiguo':
          estadoTexto = 'Plan desactualizado';
          estadoIcono = Icons.history;
          estadoColor = Colors.orange;
          break;
        case 'incompleto':
          estadoTexto = 'Información parcial';
          estadoIcono = Icons.info_outline;
          estadoColor = Colors.amber;
          break;
        default:
          estadoTexto = 'Plan en proceso';
          estadoIcono = Icons.info_outline;
          estadoColor = Colors.grey;
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPartido = partido;
              _planGobierno = plan ?? PlanGobierno.getDefaultPlan(partido.id, partido.nombre);
              _categories = _planGobierno!.getCategorias();
              _selectedCategoryIndex = 0;
            });
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFFD32F2F).withOpacity(0.3),
          highlightColor: const Color(0xFFD32F2F).withOpacity(0.2),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD32F2F).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD32F2F).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Logo del partido
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: _buildPartidoImage(partido.logoPath),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Información del partido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partido.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              estadoIcono,
                              size: 14,
                              color: estadoColor,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                estadoTexto,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: estadoColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Flecha
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFD32F2F),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDetalle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con logo y nombre del partido
          Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE53935),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildPartidoImage(_selectedPartido!.logoPath),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedPartido!.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Plan de Gobierno 2026',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Barra de progreso TTS
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isReading
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isPaused ? const Color(0xFFFF6F00) : const Color(0xFFE53935),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.fast_rewind, color: Colors.white),
                              onPressed: () => _ttsService.skipBackward(),
                              tooltip: 'Retroceder',
                              iconSize: 20,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isPaused ? Icons.pause_circle : Icons.volume_up,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _isPaused 
                                          ? 'En pausa - ${(_progress * 100).toInt()}%' 
                                          : 'Leyendo... ${(_progress * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.fast_forward, color: Colors.white),
                              onPressed: () => _ttsService.skipForward(),
                              tooltip: 'Avanzar',
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 3,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // Advertencia según el estado del plan
        if (_planGobierno != null && _planGobierno!.estadoPlan != 'completo')
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _planGobierno!.estadoPlan == 'antiguo' 
                  ? Colors.orange[50] 
                  : Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _planGobierno!.estadoPlan == 'antiguo'
                    ? Colors.orange[200]!
                    : Colors.amber[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _planGobierno!.estadoPlan == 'antiguo' 
                      ? Icons.history 
                      : Icons.info_outline,
                  color: _planGobierno!.estadoPlan == 'antiguo'
                      ? Colors.orange[700]
                      : Colors.amber[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _planGobierno!.mensajeAdvertencia ?? 
                        (_planGobierno!.estadoPlan == 'antiguo'
                            ? 'Este plan corresponde a ${_planGobierno!.anio} - ${_planGobierno!.ambito}. Plan nacional 2026 en proceso de carga.'
                            : 'Este partido aún no ha publicado su plan de gobierno completo para 2026.'),
                    style: TextStyle(
                      color: _planGobierno!.estadoPlan == 'antiguo'
                          ? Colors.orange[900]
                          : Colors.amber[900],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Category Chips
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(_categories[index], index == _selectedCategoryIndex, index),
              );
            },
          ),
        ),

        // Proposals List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _getCurrentProposals().length,
            itemBuilder: (context, index) {
              final propuesta = _getCurrentProposals()[index];
              return _buildProposalItem('${index + 1}. $propuesta');
            },
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildPartidoImage(String path) {
    return FutureBuilder<bool>(
      future: _checkImageExists(path),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultLogo();
            },
          );
        }
        return _buildDefaultLogo();
      },
    );
  }

  Future<bool> _checkImageExists(String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildDefaultLogo() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.account_balance,
        size: 35,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFE53935).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProposalItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, size: 20),
            color: const Color(0xFFE53935),
            onPressed: () => _readProposal(text),
            tooltip: 'Leer propuesta',
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  void _readProposal(String text) async {
    await _ttsService.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    
    _ttsService.speakPageContent(
      titulo: 'Propuesta de ${_selectedPartido!.nombre}',
      contenido: text,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFE53935),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Videos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
