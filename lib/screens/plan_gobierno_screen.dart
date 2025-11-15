import 'dart:io';
import 'package:flutter/material.dart';
import '../models/partido_politico.dart';
import '../models/plan_gobierno.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';
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
  List<String> _categories = [];
  
  // TTS
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  double _progress = 0.0;

  bool get _isReading => _ttsService.isPlaying;
  bool get _isPaused => _ttsService.isPaused;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _ttsService.onStateChanged = null;
    _ttsService.onProgress = null;
    _ttsService.stop();
    super.dispose();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_selectedPartido != null) {
              _ttsService.stop();
              setState(() {
                _selectedPartido = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C4DFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Elecciones 2026',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: _selectedPartido != null
            ? [
                IconButton(
                  icon: const Icon(Icons.settings_voice),
                  color: const Color(0xFF7C4DFF),
                  onPressed: _showConfigDialog,
                  tooltip: 'Configurar voz',
                ),
                if (_isReading)
                  IconButton(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    color: const Color(0xFF7C4DFF),
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
              ]
            : null,
      ),
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
                          backgroundColor: _isPaused ? Colors.green : const Color(0xFF7C4DFF),
                          tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                          child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          heroTag: 'stop_plan',
                          onPressed: _stopReading,
                          backgroundColor: Colors.red,
                          tooltip: 'Detener',
                          child: const Icon(Icons.stop),
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      key: const ValueKey('not-reading'),
                      onPressed: _toggleReadAll,
                      backgroundColor: const Color(0xFF7C4DFF),
                      icon: const Icon(Icons.volume_up),
                      label: Text('Leer ${_categories[_selectedCategoryIndex]}'),
                    ),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPartidosList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planes de Gobierno',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Selecciona un partido para ver su plan',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _partidos.length,
            itemBuilder: (context, index) {
              return _buildPartidoCard(_partidos[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartidoCard(PartidoPolitico partido) {
    final hasPlan = PlanGobierno.hasPlan(partido.id);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPartido = partido;
          _planGobierno = PlanGobierno.getPlanByPartidoId(partido.id) ??
              PlanGobierno.getDefaultPlan(partido.id, partido.nombre);
          _categories = _planGobierno!.getCategorias();
          _selectedCategoryIndex = 0;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo del partido
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPartidoImage(partido.logoPath),
              ),
            ),
            const SizedBox(width: 16),
            // Nombre del partido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partido.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        hasPlan ? Icons.check_circle : Icons.info_outline,
                        size: 14,
                        color: hasPlan ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasPlan ? 'Plan disponible' : 'Plan en proceso',
                        style: TextStyle(
                          fontSize: 13,
                          color: hasPlan ? Colors.green[700] : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Icono de flecha
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetalle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con logo y nombre del partido
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF7C4DFF).withOpacity(0.05),
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
                    color: const Color(0xFF7C4DFF),
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
                    color: _isPaused ? Colors.orange : const Color(0xFF7C4DFF),
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

        // Advertencia si el plan no es del 2026
        if (_planGobierno != null && !_planGobierno!.esActual)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _planGobierno!.mensajeAdvertencia ?? '',
                    style: TextStyle(
                      color: Colors.orange[900],
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
          color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
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
            color: const Color(0xFF7C4DFF),
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
      selectedItemColor: const Color(0xFF7C4DFF),
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
