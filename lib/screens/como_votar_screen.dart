import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ComoVotarScreen extends StatelessWidget {
  const ComoVotarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text(
          'Cómo Votar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Introducción
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE53935).withOpacity(0.1),
                  const Color(0xFFD32F2F).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE53935).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.how_to_vote,
                  size: 48,
                  color: const Color(0xFFE53935),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aprende a Votar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Conoce el proceso de votación presencial y virtual para ejercer tu derecho al voto de manera informada',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Tutorial 1: Voto Presencial
          _buildTutorialCard(
            context: context,
            titulo: '🗳️ Voto Presencial',
            descripcion: 'Aprende el proceso paso a paso para votar en tu local de votación',
            videoId: 'OWV2XDu0BZ0',
            color: const Color(0xFFE53935),
          ),

          const SizedBox(height: 20),

          // Tutorial 2: Voto Virtual
          _buildTutorialCard(
            context: context,
            titulo: '💻 Voto Virtual',
            descripcion: 'Conoce cómo funciona el voto electrónico y sus ventajas',
            videoId: 'tg0UXVd14pc',
            color: const Color(0xFF1976D2),
          ),

          const SizedBox(height: 32),

          // Información adicional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[300]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.amber[800], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Recuerda llevar tu DNI vigente el día de las elecciones. El voto es obligatorio para mayores de 18 años.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required String videoId,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
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

          // Botón para ver video
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoId: videoId,
                        titulo: titulo,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_outline, size: 28),
                label: const Text(
                  'Ver Tutorial',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String titulo;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.titulo,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        captionLanguage: 'es',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.titulo,
          style: const TextStyle(fontSize: 16),
        ),
        elevation: 0,
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFFE53935),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFFE53935),
            handleColor: Color(0xFFE53935),
          ),
          onReady: () {
            print('Player is ready.');
          },
        ),
      ),
    );
  }
}
