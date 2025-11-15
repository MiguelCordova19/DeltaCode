import 'package:flutter/material.dart';
import '../models/informacion_electoral.dart';
import '../services/tts_service_advanced.dart';
import '../models/tts_config.dart';
import '../widgets/tts_config_dialog.dart';

class InformacionElectoralScreen extends StatefulWidget {
  const InformacionElectoralScreen({super.key});

  @override
  State<InformacionElectoralScreen> createState() =>
      _InformacionElectoralScreenState();
}

class _InformacionElectoralScreenState
    extends State<InformacionElectoralScreen> {
  final List<InformacionElectoral> _informacion =
      InformacionElectoralData.getInformacion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Información Electoral'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _informacion.length,
        itemBuilder: (context, index) {
          return _buildInfoCard(_informacion[index]);
        },
      ),
    );
  }

  Widget _buildInfoCard(InformacionElectoral info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InformacionDetalleScreen(informacion: info),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    info.iconoEmoji ?? '📋',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.categoria,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${info.secciones.length} secciones',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Flecha
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de detalle con tarjetas deslizables y TTS
class InformacionDetalleScreen extends StatefulWidget {
  final InformacionElectoral informacion;

  const InformacionDetalleScreen({
    super.key,
    required this.informacion,
  });

  @override
  State<InformacionDetalleScreen> createState() =>
      _InformacionDetalleScreenState();
}

class _InformacionDetalleScreenState extends State<InformacionDetalleScreen> {
  final PageController _pageController = PageController();
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  int _currentPage = 0;
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
    _pageController.dispose();
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
      _readCurrentCard();
    }
  }

  void _stopReading() async {
    await _ttsService.stop();
  }

  void _readCurrentCard() {
    final seccion = widget.informacion.secciones[_currentPage];
    final contenido = StringBuffer();

    if (seccion.descripcion != null) {
      contenido.write(seccion.descripcion!);
      contenido.write('. ');
    }

    for (var punto in seccion.puntos) {
      contenido.write(punto);
      contenido.write('. ');
    }

    _ttsService.speakPageContent(
      titulo: widget.informacion.titulo,
      subtitulo: seccion.titulo,
      contenido: contenido.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: Text(widget.informacion.titulo),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_voice),
            onPressed: _showConfigDialog,
            tooltip: 'Configurar voz',
          ),
          if (_isReading)
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _toggleReadAll,
              tooltip: _isPaused ? 'Reanudar' : 'Pausar',
            ),
          if (_isReading)
            IconButton(
              icon: const Icon(Icons.stop_circle),
              color: Colors.white,
              onPressed: _stopReading,
              tooltip: 'Detener lectura',
            ),
        ],
      ),
      body: Column(
        children: [
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.fast_rewind,
                                    color: Colors.white),
                                onPressed: () => _ttsService.skipBackward(),
                                tooltip: 'Retroceder',
                                iconSize: 20,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isPaused
                                          ? Icons.pause_circle
                                          : Icons.volume_up,
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
                                icon: const Icon(Icons.fast_forward,
                                    color: Colors.white),
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
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Indicador de página
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_currentPage + 1} / ${widget.informacion.secciones.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Tarjetas deslizables
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _ttsService.stop();
              },
              itemCount: widget.informacion.secciones.length,
              itemBuilder: (context, index) {
                return _buildSeccionCard(
                    widget.informacion.secciones[index], index);
              },
            ),
          ),

          // Indicadores de puntos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.informacion.secciones.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF7C4DFF)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                    heroTag: 'pause_info',
                    onPressed: _toggleReadAll,
                    backgroundColor:
                        _isPaused ? Colors.green : const Color(0xFF7C4DFF),
                    tooltip: _isPaused ? 'Reanudar' : 'Pausar',
                    child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: 'stop_info',
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
                label: const Text('Leer Tarjeta'),
              ),
      ),
    );
  }

  Widget _buildSeccionCard(SeccionInfo seccion, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.informacion.iconoEmoji ?? '📋',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    seccion.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7C4DFF),
                    ),
                  ),
                ),
              ],
            ),
            if (seccion.descripcion != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        seccion.descripcion!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[900],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Puntos
            ...seccion.puntos.asMap().entries.map((entry) {
              return _buildPunto(entry.value, entry.key);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPunto(String punto, int index) {
    // Detectar si es un punto con emoji o símbolo especial
    final tieneEmoji = punto.contains('✅') ||
        punto.contains('❌') ||
        punto.contains('📞') ||
        punto.contains('🗳️');

    final esNumero = RegExp(r'^\d+\.').hasMatch(punto);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!tieneEmoji && !esNumero)
            Container(
              margin: const EdgeInsets.only(top: 4, right: 12),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF7C4DFF),
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Text(
              punto,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
