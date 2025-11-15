import 'package:flutter/material.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';

class TtsConfigDialog extends StatefulWidget {
  final TtsConfig currentConfig;
  final Function(TtsConfig) onConfigChanged;

  const TtsConfigDialog({
    super.key,
    required this.currentConfig,
    required this.onConfigChanged,
  });

  @override
  State<TtsConfigDialog> createState() => _TtsConfigDialogState();
}

class _TtsConfigDialogState extends State<TtsConfigDialog> {
  late TtsConfig _config;
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  List<VoiceOption> _voices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _config = widget.currentConfig;
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    await _ttsService.initialize();
    setState(() {
      _voices = _ttsService.availableVoices;
      _isLoading = false;
    });
  }

  void _testVoice() async {
    await _ttsService.applyConfig(_config);
    await _ttsService.speak('Hola, esta es una prueba de voz para las elecciones 2026');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Configuración de Voz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selector de voz
                      const Text(
                        'Seleccionar Voz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      if (_voices.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No se encontraron voces en español. Se usará la voz por defecto del sistema.',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _config.selectedVoice,
                              hint: const Text('Selecciona una voz'),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('🔊 Voz por defecto del sistema'),
                                ),
                                ..._voices.map((voice) {
                                  return DropdownMenuItem<String>(
                                    value: voice.name,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          voice.displayName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          voice.country,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _config = _config.copyWith(selectedVoice: value);
                                });
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Mostrar voz seleccionada
                      if (_config.selectedVoice != null && _voices.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF7C4DFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Voz seleccionada:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      _voices.firstWhere(
                                        (v) => v.name == _config.selectedVoice,
                                        orElse: () => VoiceOption(name: '', locale: ''),
                                      ).displayName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF7C4DFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Velocidad
                      const Text(
                        'Velocidad de Lectura',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 20),
                          Expanded(
                            child: Slider(
                              value: _config.speechRate,
                              min: 0.1,
                              max: 1.0,
                              divisions: 9,
                              label: _config.speechRate.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  _config = _config.copyWith(speechRate: value);
                                });
                              },
                            ),
                          ),
                          Text(_config.speechRate.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tono
                      const Text(
                        'Tono de Voz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.graphic_eq, size: 20),
                          Expanded(
                            child: Slider(
                              value: _config.pitch,
                              min: 0.5,
                              max: 2.0,
                              divisions: 15,
                              label: _config.pitch.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  _config = _config.copyWith(pitch: value);
                                });
                              },
                            ),
                          ),
                          Text(_config.pitch.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Volumen
                      const Text(
                        'Volumen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.volume_up, size: 20),
                          Expanded(
                            child: Slider(
                              value: _config.volume,
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              label: (_config.volume * 100).toInt().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _config = _config.copyWith(volume: value);
                                });
                              },
                            ),
                          ),
                          Text('${(_config.volume * 100).toInt()}%'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botón de prueba
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _testVoice,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Probar Voz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C4DFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.onConfigChanged(_config);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
