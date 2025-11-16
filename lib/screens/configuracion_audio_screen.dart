import 'package:flutter/material.dart';
import '../models/tts_config.dart';
import '../services/tts_service_advanced.dart';

class ConfiguracionAudioScreen extends StatefulWidget {
  const ConfiguracionAudioScreen({super.key});

  @override
  State<ConfiguracionAudioScreen> createState() => _ConfiguracionAudioScreenState();
}

class _ConfiguracionAudioScreenState extends State<ConfiguracionAudioScreen> {
  final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
  late TtsConfig _config;

  @override
  void initState() {
    super.initState();
    _config = _ttsService.config;
  }

  Future<void> _aplicarCambios() async {
    await _ttsService.updateConfig(_config);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada'),
          backgroundColor: Color(0xFFE53935),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _probarVoz() async {
    await _ttsService.speak('Hola, esta es una prueba de la voz seleccionada para las elecciones 2026');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Configuración de Audio'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ajusta la velocidad y el volumen de la lectura de voz para una mejor experiencia.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Velocidad
            _buildSeccionTitulo('Velocidad de Lectura'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lenta',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${(_config.speechRate * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      const Text(
                        'Rápida',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFFE53935),
                      inactiveTrackColor: const Color(0xFFE53935).withOpacity(0.2),
                      thumbColor: const Color(0xFFE53935),
                      overlayColor: const Color(0xFFE53935).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                    ),
                    child: Slider(
                      value: _config.speechRate,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      onChanged: (value) {
                        setState(() {
                          _config = _config.copyWith(speechRate: value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Volumen
            _buildSeccionTitulo('Volumen'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.volume_mute, color: Colors.grey),
                      Text(
                        '${(_config.volume * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Color(0xFFE53935)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFFE53935),
                      inactiveTrackColor: const Color(0xFFE53935).withOpacity(0.2),
                      thumbColor: const Color(0xFFE53935),
                      overlayColor: const Color(0xFFE53935).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                    ),
                    child: Slider(
                      value: _config.volume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _config = _config.copyWith(volume: value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón probar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _probarVoz,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Probar Voz'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(color: Color(0xFFE53935), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botón guardar con efecto 3D
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _aplicarCambios,
                  icon: const Icon(Icons.check),
                  label: const Text('Guardar Configuración'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }
}
