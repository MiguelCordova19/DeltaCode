import 'package:flutter/material.dart';
import '../services/tts_service.dart';

/// Widget reutilizable para agregar lectura por voz a cualquier texto
class TtsButton extends StatefulWidget {
  final String text;
  final String? title;
  final IconData icon;
  final Color? color;
  final double? iconSize;

  const TtsButton({
    super.key,
    required this.text,
    this.title,
    this.icon = Icons.volume_up,
    this.color,
    this.iconSize = 20,
  });

  @override
  State<TtsButton> createState() => _TtsButtonState();
}

class _TtsButtonState extends State<TtsButton> {
  final TtsService _ttsService = TtsService();
  bool _isReading = false;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  void _toggleReading() async {
    if (_isReading) {
      await _ttsService.stop();
      setState(() {
        _isReading = false;
      });
    } else {
      setState(() {
        _isReading = true;
      });
      
      await _ttsService.speakPageContent(
        titulo: widget.title,
        contenido: widget.text,
      );
      
      setState(() {
        _isReading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isReading ? Icons.stop_circle : widget.icon,
        size: widget.iconSize,
      ),
      color: _isReading ? Colors.red : (widget.color ?? const Color(0xFF7C4DFF)),
      onPressed: _toggleReading,
      tooltip: _isReading ? 'Detener lectura' : 'Leer texto',
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }
}
