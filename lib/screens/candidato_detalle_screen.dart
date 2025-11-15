import 'package:flutter/material.dart';
import '../models/candidato.dart';
import '../models/partido_politico.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';
import '../widgets/tts_config_dialog.dart';

class CandidatoDetalleScreen extends StatefulWidget {
  final Candidato candidato;
  final PartidoPolitico partido;

  const CandidatoDetalleScreen({
    super.key,
    required this.candidato,
    required this.partido,
  });

  @override
  State<CandidatoDetalleScreen> createState() => _CandidatoDetalleScreenState();
}

class _CandidatoDetalleScreenState extends State<CandidatoDetalleScreen> {
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  double _progress = 0.0;

  bool get _isReading => _ttsService.isPlaying;
  bool get _isPaused => _ttsService.isPaused;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    
    // Escuchar cambios de estado del TTS
    _ttsService.onStateChanged = () {
      if (mounted) {
        setState(() {
          // Forzar rebuild cuando cambia el estado del TTS
        });
      }
    };

    // Escuchar progreso de lectura
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
    print('_toggleReadAll: _isReading=$_isReading, _isPaused=$_isPaused');
    
    if (_isReading && !_isPaused) {
      // Pausar
      print('Pausando...');
      await _ttsService.pause();
    } else if (_isPaused) {
      // Reanudar desde donde se quedó
      print('Reanudando...');
      await _ttsService.resume();
    } else {
      // Iniciar lectura
      print('Iniciando lectura...');
      _ttsService.speakPageContent(
        titulo: '${widget.candidato.cargo}: ${widget.candidato.nombre}',
        subtitulo: 'Partido político: ${widget.partido.nombre}',
        contenido: 'Hoja de Vida: ${widget.candidato.hojaVida}. Biografía: ${widget.candidato.biografia}',
      );
    }
  }

  void _stopReading() async {
    print('Deteniendo completamente...');
    await _ttsService.stop();
  }

  void _readSection(String title, String content) async {
    print('Leyendo sección: $title');
    await _ttsService.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    
    _ttsService.speakPageContent(
      titulo: title,
      contenido: content,
    );
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
          onPressed: () => Navigator.pop(context),
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
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto grande del candidato
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: _buildCandidatoImage(widget.candidato.fotoPath),
            ),

            // Indicador de lectura con animación y progreso
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
                                // Botón saltar atrás
                                IconButton(
                                  icon: const Icon(Icons.fast_rewind, color: Colors.white),
                                  onPressed: () => _ttsService.skipBackward(),
                                  tooltip: 'Retroceder',
                                  iconSize: 20,
                                ),
                                
                                // Estado
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
                                
                                // Botón saltar adelante
                                IconButton(
                                  icon: const Icon(Icons.fast_forward, color: Colors.white),
                                  onPressed: () => _ttsService.skipForward(),
                                  tooltip: 'Avanzar',
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ),
                          
                          // Barra de progreso
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge del cargo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.candidato.cargo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre del candidato
                  Text(
                    widget.candidato.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Partido político
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildPartidoImage(widget.partido.logoPath),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.partido.nombre,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Hoja de Vida
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hoja de Vida',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 20),
                        color: const Color(0xFF7C4DFF),
                        onPressed: () => _readSection('Hoja de Vida', widget.candidato.hojaVida),
                        tooltip: 'Leer hoja de vida',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.candidato.hojaVida,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Biografía
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Biografía',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 20),
                        color: const Color(0xFF7C4DFF),
                        onPressed: () => _readSection('Biografía', widget.candidato.biografia),
                        tooltip: 'Leer biografía',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.candidato.biografia,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
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
                    heroTag: 'pause',
                    onPressed: _toggleReadAll,
                    backgroundColor: _isPaused ? Colors.green : const Color(0xFF7C4DFF),
                    tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                    child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: 'stop',
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
                label: const Text('Leer todo'),
              ),
      ),
    );
  }

  Widget _buildCandidatoImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultPersonImage();
      },
    );
  }

  Widget _buildPartidoImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultPartidoLogo();
      },
    );
  }

  Widget _buildDefaultPersonImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.person,
          size: 120,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDefaultPartidoLogo() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.account_balance,
        size: 25,
        color: Colors.grey,
      ),
    );
  }
}
