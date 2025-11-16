import 'package:flutter/material.dart';
import '../models/candidato.dart';
import '../models/partido_politico.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';
import '../services/gamificacion_service.dart';
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
  
  // Gamificación
  final GamificacionService _gamificacionService = GamificacionService();
  bool _primerCandidatoVisto = false;

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
    
    _cargarEstadoLogro();
  }

  @override
  void dispose() {
    _ttsService.onStateChanged = null;
    _ttsService.onProgress = null;
    _ttsService.stop();
    super.dispose();
  }
  
  Future<void> _cargarEstadoLogro() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _primerCandidatoVisto = puntos.logros.any((l) => l.id == 'explorador_politico');
      });
      print('DEBUG: Primer candidato visto: $_primerCandidatoVisto');
    }
  }
  
  Future<void> _otorgarLogroPrimerCandidato() async {
    try {
      print('DEBUG: Otorgando logro...');
      await _gamificacionService.agregarPuntos(
        puntos: GamificacionService.PUNTOS_VER_CANDIDATO,
        descripcion: 'Conociste a tu primer candidato',
        logroId: 'explorador_politico',
        logroTitulo: '🔍 Explorador Político',
        logroDescripcion: 'Conoce a tu primer candidato',
        logroIcono: '🔍',
      );
      
      print('DEBUG: Logro otorgado, mostrando diálogo...');
      
      if (mounted) {
        setState(() {
          _primerCandidatoVisto = true;
        });
        
        // Mostrar diálogo de logro y esperar a que se cierre
        await _mostrarDialogoLogro(
          icono: '🔍',
          titulo: '¡Logro desbloqueado!',
          descripcion: 'Explorador Político',
          puntos: GamificacionService.PUNTOS_VER_CANDIDATO,
        );
        
        print('DEBUG: Diálogo cerrado');
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
                Colors.blue[400]!,
                Colors.purple[400]!,
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
                  foregroundColor: Colors.purple[700],
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
          onPressed: () async {
            print('DEBUG: Botón retroceso presionado. Primer candidato visto: $_primerCandidatoVisto');
            
            // Otorgar logro si es la primera vez
            if (!_primerCandidatoVisto) {
              print('DEBUG: Intentando otorgar logro...');
              // Esperar a que se muestre y cierre el diálogo
              await _otorgarLogroPrimerCandidato();
            } else {
              print('DEBUG: Logro ya obtenido, no se muestra');
            }
            
            // Cerrar la pantalla después de mostrar el diálogo
            if (mounted) {
              Navigator.pop(context);
            }
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
              color: const Color(0xFFD32F2F),
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
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.candidato.cargo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
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
                        color: const Color(0xFFE53935),
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
                        color: const Color(0xFFE53935),
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
                    backgroundColor: _isPaused ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                    tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                    child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: 'stop',
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
