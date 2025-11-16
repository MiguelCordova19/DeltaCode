import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/paso_tutorial.dart';
import '../services/gamificacion_service.dart';

class TutorialMiembroMesaScreen extends StatefulWidget {
  const TutorialMiembroMesaScreen({super.key});

  @override
  State<TutorialMiembroMesaScreen> createState() => _TutorialMiembroMesaScreenState();
}

class _TutorialMiembroMesaScreenState extends State<TutorialMiembroMesaScreen> {
  int _etapaActual = 0;
  int _pasoActual = 0;
  late YoutubePlayerController _youtubeController;
  late FlutterTts _flutterTts;
  bool _mostrarVideo = true;
  bool _isReading = false;
  final GamificacionService _gamificacionService = GamificacionService();
  bool _tutorialCompletado = false;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _initializeTts();
    _cargarEstadoLogro();
  }
  
  Future<void> _cargarEstadoLogro() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _tutorialCompletado = puntos.logros.any((l) => l.id == 'miembro_mesa_preparado');
      });
    }
  }

  void _initializeYoutubePlayer() {
    const videoUrl = 'https://www.youtube.com/watch?v=DW5-XnnNSjo';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        captionLanguage: 'es',
      ),
    );
  }

  Future<void> _initializeTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage('es-ES');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isReading = false;
      });
    });
  }

  Future<void> _leerPaso() async {
    if (_isReading) {
      await _flutterTts.stop();
      setState(() {
        _isReading = false;
      });
    } else {
      final etapa = TutorialMiembroMesa.etapas[_etapaActual];
      final paso = etapa.pasos[_pasoActual];
      
      String textoCompleto = '${paso.titulo}. ${paso.descripcion}';
      if (paso.detalle != null) {
        textoCompleto += '. ${paso.detalle}';
      }
      if (paso.subpasos != null && paso.subpasos!.isNotEmpty) {
        textoCompleto += '. Pasos a seguir: ${paso.subpasos!.join('. ')}';
      }
      if (paso.consejo != null) {
        textoCompleto += '. Consejo: ${paso.consejo}';
      }
      
      setState(() {
        _isReading = true;
      });
      
      await _flutterTts.speak(textoCompleto);
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Tutorial Miembro de Mesa'),
        elevation: 0,
        actions: [
          if (!_mostrarVideo)
            IconButton(
              icon: Icon(_isReading ? Icons.stop : Icons.volume_up),
              onPressed: _leerPaso,
              tooltip: _isReading ? 'Detener lectura' : 'Escuchar paso',
            ),
          if (!_mostrarVideo)
            IconButton(
              icon: const Icon(Icons.video_library),
              onPressed: () {
                setState(() {
                  _mostrarVideo = true;
                });
              },
              tooltip: 'Ver video tutorial',
            ),
        ],
      ),
      body: _mostrarVideo ? _buildVideoIntro() : _buildTutorialPasos(),
    );
  }

  Widget _buildVideoIntro() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Video de YouTube
                YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFFE53935),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        playedColor: Color(0xFFE53935),
                        handleColor: Color(0xFFE53935),
                      ),
                    ),
                    RemainingDuration(),
                    const PlaybackSpeedButton(),
                    FullScreenButton(),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📺 Video Tutorial Oficial',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mira este video oficial de la ONPE para conocer todo sobre ser miembro de mesa.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text('💡', style: TextStyle(fontSize: 24)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '¿Qué aprenderás?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '• Cómo instalar la mesa electoral\n'
                              '• Proceso de votación paso a paso\n'
                              '• Cómo realizar el escrutinio\n'
                              '• Tus derechos y obligaciones\n'
                              '• Consejos prácticos para el día',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Botón para continuar al tutorial paso a paso
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _mostrarVideo = false;
                  });
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Continuar al Tutorial Paso a Paso',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialPasos() {
    return Column(
      children: [
        // Indicador de progreso
        _buildProgressIndicator(),
        
        // Contenido
        Expanded(
          child: _buildContenido(),
        ),
        
        // Botones de navegación
        _buildNavegacion(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFE53935),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final isActive = index == _etapaActual;
              final isCompleted = index < _etapaActual;
              
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TutorialMiembroMesa.etapas[index].icono,
                      style: TextStyle(
                        fontSize: 24,
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TutorialMiembroMesa.etapas[index].nombre.split(' ')[0],
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    final etapa = TutorialMiembroMesa.etapas[_etapaActual];
    final paso = etapa.pasos[_pasoActual];
    final totalPasos = etapa.pasos.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la etapa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      etapa.icono,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            etapa.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            etapa.horario,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Número de paso (corregido para empezar en 1)
          Text(
            'Paso ${_pasoActual + 1} de $totalPasos',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // Título del paso
          Text(
            paso.titulo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Descripción
          Text(
            paso.descripcion,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          if (paso.detalle != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Text(
                paso.detalle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],

          // Subpasos
          if (paso.subpasos != null && paso.subpasos!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Pasos a seguir:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...paso.subpasos!.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],

          // Consejo
          if (paso.consejo != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      paso.consejo!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavegacion() {
    final etapa = TutorialMiembroMesa.etapas[_etapaActual];
    final isFirstStep = _etapaActual == 0 && _pasoActual == 0;
    final isLastStep = _etapaActual == TutorialMiembroMesa.etapas.length - 1 &&
        _pasoActual == etapa.pasos.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!isFirstStep)
              Expanded(
                child: OutlinedButton(
                  onPressed: _anteriorPaso,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Anterior',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            if (!isFirstStep) const SizedBox(width: 12),
            Expanded(
              flex: isFirstStep ? 1 : 1,
              child: ElevatedButton(
                onPressed: isLastStep ? _finalizarTutorial : _siguientePaso,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastStep ? 'Finalizar' : 'Siguiente',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _siguientePaso() {
    setState(() {
      final etapa = TutorialMiembroMesa.etapas[_etapaActual];
      
      if (_pasoActual < etapa.pasos.length - 1) {
        _pasoActual++;
      } else if (_etapaActual < TutorialMiembroMesa.etapas.length - 1) {
        _etapaActual++;
        _pasoActual = 0;
      }
    });
  }

  void _anteriorPaso() {
    setState(() {
      if (_pasoActual > 0) {
        _pasoActual--;
      } else if (_etapaActual > 0) {
        _etapaActual--;
        _pasoActual = TutorialMiembroMesa.etapas[_etapaActual].pasos.length - 1;
      }
    });
  }

  Future<void> _finalizarTutorial() async {
    // Otorgar logro si es la primera vez
    if (!_tutorialCompletado) {
      await _otorgarLogroMiembroMesa();
    } else {
      // Mostrar diálogo normal
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡Tutorial Completado! 🎉'),
          content: const Text(
            '¡Felicitaciones! Ahora conoces todos los pasos para ser un excelente miembro de mesa.\n\n'
            'Recuerda: Tu participación es fundamental para la democracia.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }
  
  Future<void> _otorgarLogroMiembroMesa() async {
    try {
      await _gamificacionService.agregarPuntos(
        puntos: 75,
        descripcion: 'Completaste el tutorial de miembro de mesa',
        logroId: 'miembro_mesa_preparado',
        logroTitulo: '🗳️ Miembro de Mesa Preparado',
        logroDescripcion: 'Completa el tutorial de miembro de mesa',
        logroIcono: '🗳️',
      );
      
      setState(() {
        _tutorialCompletado = true;
      });
      
      if (mounted) {
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
                    Colors.amber[600]!,
                    Colors.orange[600]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          child: const Center(
                            child: Text(
                              '🗳️',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '¡Logro desbloqueado!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Miembro de Mesa Preparado',
                    style: TextStyle(
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
                    child: const Text(
                      '+75 puntos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange[700],
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
    } catch (e) {
      print('Error al otorgar logro: $e');
    }
  }
}
