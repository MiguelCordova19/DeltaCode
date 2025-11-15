import 'package:flutter_tts/flutter_tts.dart';
import '../models/tts_config.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  bool _isPaused = false;
  TtsConfig _config = TtsConfig();
  List<VoiceOption> _availableVoices = [];
  
  // Para manejar pausa/reanudar
  String _currentText = '';
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  
  // Callbacks para notificar cambios de estado
  Function()? onStateChanged;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  TtsConfig get config => _config;
  List<VoiceOption> get availableVoices => _availableVoices;

  Future<void> initialize() async {
    // Configuración inicial
    await applyConfig(_config);

    // Obtener voces disponibles
    await loadAvailableVoices();

    // Callbacks
    _flutterTts.setStartHandler(() {
      print('TTS: Iniciado');
      _isPlaying = true;
      _isPaused = false;
      onStateChanged?.call();
    });

    _flutterTts.setCompletionHandler(() {
      print('TTS: Completado chunk $_currentChunkIndex de ${_textChunks.length}');
      
      if (!_isPaused) {
        _currentChunkIndex++;
        
        if (_currentChunkIndex < _textChunks.length) {
          // Hay más chunks por leer
          _speakNextChunk();
        } else {
          // Terminó toda la lectura
          _isPlaying = false;
          _isPaused = false;
          _currentChunkIndex = 0;
          _textChunks.clear();
          onStateChanged?.call();
        }
      }
    });

    _flutterTts.setErrorHandler((msg) {
      print('TTS: Error - $msg');
      _isPlaying = false;
      _isPaused = false;
      onStateChanged?.call();
    });

    _flutterTts.setPauseHandler(() {
      print('TTS: Pausado');
      _isPaused = true;
      onStateChanged?.call();
    });

    _flutterTts.setContinueHandler(() {
      print('TTS: Continuado');
      _isPaused = false;
      onStateChanged?.call();
    });
  }

  Future<void> loadAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null && voices is List) {
        _availableVoices = voices
            .where((voice) {
              final locale = voice['locale']?.toString() ?? '';
              return locale.toLowerCase().startsWith('es'); // Solo voces en español
            })
            .map((voice) {
              final name = voice['name']?.toString() ?? 'Voz desconocida';
              final locale = voice['locale']?.toString() ?? 'es-ES';
              return VoiceOption(
                name: name,
                locale: locale,
              );
            })
            .toList();

        // Ordenar por país y luego por nombre
        _availableVoices.sort((a, b) {
          final countryCompare = a.country.compareTo(b.country);
          if (countryCompare != 0) return countryCompare;
          return a.displayName.compareTo(b.displayName);
        });
      }
    } catch (e) {
      print('Error al cargar voces: $e');
    }
  }

  Future<void> applyConfig(TtsConfig config) async {
    _config = config;
    await _flutterTts.setLanguage(config.language);
    await _flutterTts.setSpeechRate(config.speechRate);
    await _flutterTts.setVolume(config.volume);
    await _flutterTts.setPitch(config.pitch);
    
    if (config.selectedVoice != null) {
      await _flutterTts.setVoice({
        "name": config.selectedVoice!,
        "locale": config.language,
      });
    }
  }

  Future<void> updateConfig(TtsConfig newConfig) async {
    await applyConfig(newConfig);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      _currentText = text;
      _splitTextIntoChunks(text);
      _currentChunkIndex = 0;
      await _speakNextChunk();
    }
  }

  void _splitTextIntoChunks(String text) {
    // Dividir el texto en oraciones para poder pausar/reanudar
    _textChunks = text.split(RegExp(r'[.!?]\s+'))
        .where((chunk) => chunk.trim().isNotEmpty)
        .map((chunk) => chunk.trim() + '.')
        .toList();
    
    if (_textChunks.isEmpty) {
      _textChunks = [text];
    }
  }

  Future<void> _speakNextChunk() async {
    if (_currentChunkIndex < _textChunks.length && !_isPaused) {
      await _flutterTts.speak(_textChunks[_currentChunkIndex]);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
    _isPaused = false;
    _currentChunkIndex = 0;
    _textChunks.clear();
    _currentText = '';
    onStateChanged?.call();
  }

  Future<void> pause() async {
    if (_isPlaying && !_isPaused) {
      print('Pausando en chunk $_currentChunkIndex');
      await _flutterTts.stop();
      _isPaused = true;
      // Mantener _isPlaying = true para que los botones sigan visibles
      onStateChanged?.call();
    }
  }

  Future<void> resume() async {
    if (_isPaused) {
      print('Reanudando desde chunk $_currentChunkIndex');
      _isPaused = false;
      
      // Continuar desde el chunk donde se pausó
      if (_currentChunkIndex < _textChunks.length) {
        await _speakNextChunk();
      } else {
        // Si ya terminó, reiniciar
        _currentChunkIndex = 0;
        await _speakNextChunk();
      }
    }
  }

  // Leer contenido de una página específica
  Future<void> speakPageContent({
    String? titulo,
    String? subtitulo,
    String? contenido,
  }) async {
    String fullText = '';
    
    if (titulo != null && titulo.isNotEmpty) {
      fullText += '$titulo. ';
    }
    
    if (subtitulo != null && subtitulo.isNotEmpty) {
      fullText += '$subtitulo. ';
    }
    
    if (contenido != null && contenido.isNotEmpty) {
      fullText += contenido;
    }

    await speak(fullText);
  }

  void dispose() {
    _flutterTts.stop();
  }
}
