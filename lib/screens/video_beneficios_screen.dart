import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoBeneficiosScreen extends StatefulWidget {
  const VideoBeneficiosScreen({super.key});

  @override
  State<VideoBeneficiosScreen> createState() => _VideoBeneficiosScreenState();
}

class _VideoBeneficiosScreenState extends State<VideoBeneficiosScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    
    // Extraer el ID del video de YouTube
    const videoUrl = 'https://www.youtube.com/watch?v=BS89O78Jod0';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        captionLanguage: 'es',
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Beneficios de ser Miembro de Mesa'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video de YouTube
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFF7C4DFF),
              onReady: () {
                _isPlayerReady = true;
              },
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Color(0xFF7C4DFF),
                    handleColor: Color(0xFF7C4DFF),
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
                  // Título
                  const Text(
                    '🎁 Beneficios de ser Miembro de Mesa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Como miembro de mesa, recibes importantes beneficios por tu participación en el proceso electoral:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Beneficio 1: Compensación
                  _buildBeneficioCard(
                    icono: '💰',
                    titulo: 'Compensación Económica',
                    descripcion: 'Recibes S/ 120.00 por cumplir tu cargo como miembro de mesa.',
                    color: Colors.green,
                  ),

                  const SizedBox(height: 16),

                  // Beneficio 2: Permiso laboral
                  _buildBeneficioCard(
                    icono: '📅',
                    titulo: 'Permiso Laboral Remunerado',
                    descripcion: 'Tu empleador debe darte permiso el día de las elecciones sin descuento de sueldo.',
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 16),

                  // Beneficio 3: Experiencia cívica
                  _buildBeneficioCard(
                    icono: '🏆',
                    titulo: 'Experiencia Cívica',
                    descripcion: 'Participas activamente en la democracia y contribuyes al proceso electoral.',
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 16),

                  // Beneficio 4: Capacitación
                  _buildBeneficioCard(
                    icono: '📚',
                    titulo: 'Capacitación Gratuita',
                    descripcion: 'Recibes capacitación de la ONPE sobre el proceso electoral.',
                    color: const Color(0xFF7C4DFF),
                  ),

                  const SizedBox(height: 16),

                  // Beneficio 5: Constancia
                  _buildBeneficioCard(
                    icono: '📜',
                    titulo: 'Constancia de Participación',
                    descripcion: 'Recibes una constancia oficial que puede ser útil para tu currículum.',
                    color: Colors.teal,
                  ),

                  const SizedBox(height: 24),

                  // Cómo recibir la compensación
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
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
                                '¿Cómo recibir tu compensación?',
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
                          '1. Cumple tu cargo el día de las elecciones\n'
                          '2. Regístrate en la plataforma de ONPE\n'
                          '3. Elige tu modalidad de pago:\n'
                          '   • Depósito en cuenta bancaria\n'
                          '   • Billetera digital (Yape, Plin)\n'
                          '   • Cobro en Banco de la Nación\n'
                          '4. Recibe tu pago en 15 días aprox.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón para más información
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver a Información'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeneficioCard({
    required String icono,
    required String titulo,
    required String descripcion,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icono,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
