import 'package:flutter_tts/flutter_tts.dart';
import '../models/tts_config.dart';

/// Servicio TTS avanzado con pausa/reanudación precisa
class TtsServiceAdvanced {
  static final TtsServiceAdvanced _instance = TtsServiceAdvanced._internal();
  factory TtsServiceAdvanced() => _instance;
  TtsServiceAdvanced._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  bool _isPaused = false;
  TtsConfig _config = TtsConfig();
  List<VoiceOption> _availableVoices = [];
  
  // Para pausa/reanudación precisa
  List<String> _words = [];
  int _currentWordIndex = 0;
  bool _shouldContinue = true;
  
  // Callbacks
  Function()? onStateChanged;
  Function(int currentWord, int totalWords)? onProgress;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  TtsConfig get config => _config;
  List<VoiceOption> get availableVoices => _availableVoices;
  double get progress => _words.isEmpty ? 0 : _currentWordIndex / _words.length;

  Future<void> initialize() async {
    await applyConfig(_config);
    await loadAvailableVoices();

    _flutterTts.setStartHandler(() {
      print('TTS: Palabra iniciada');
    });

    _flutterTts.setCompletionHandler(() {
      print('TTS: Palabra completada - $_currentWordIndex de ${_words.length}');
      _onWordCompleted();
    });

    _flutterTts.setErrorHandler((msg) {
      print('TTS: Error - $msg');
      _isPlaying = false;
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
              return locale.toLowerCase().startsWith('es');
            })
            .map((voice) {
              final name = voice['name']?.toString() ?? 'Voz desconocida';
              final locale = voice['locale']?.toString() ?? 'es-ES';
              return VoiceOption(name: name, locale: locale);
            })
            .toList();

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

  /// Hablar texto con capacidad de pausa/reanudación precisa
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    // Dividir en palabras (grupos de 3-5 palabras para mejor fluidez)
    _words = _splitIntoWordGroups(text, wordsPerGroup: 5);
    _currentWordIndex = 0;
    _shouldContinue = true;
    _isPlaying = true;
    _isPaused = false;
    
    onStateChanged?.call();
    
    await _speakNextWord();
  }

  List<String> _splitIntoWordGroups(String text, {int wordsPerGroup = 5}) {
    // Limpiar el texto
    final cleanText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // Dividir en palabras
    final allWords = cleanText.split(' ');
    final groups = <String>[];
    
    // Agrupar palabras
    for (int i = 0; i < allWords.length; i += wordsPerGroup) {
      final end = (i + wordsPerGroup < allWords.length) 
          ? i + wordsPerGroup 
          : allWords.length;
      final group = allWords.sublist(i, end).join(' ');
      groups.add(group);
    }
    
    return groups;
  }

  Future<void> _speakNextWord() async {
    if (!_shouldContinue || _isPaused || _currentWordIndex >= _words.length) {
      if (_currentWordIndex >= _words.length) {
        // Terminó toda la lectura
        _isPlaying = false;
        _isPaused = false;
        _currentWordIndex = 0;
        _words.clear();
        onStateChanged?.call();
      }
      return;
    }

    final word = _words[_currentWordIndex];
    print('Hablando grupo $_currentWordIndex: "$word"');
    
    // Notificar progreso
    onProgress?.call(_currentWordIndex, _words.length);
    
    await _flutterTts.speak(word);
  }

  void _onWordCompleted() {
    if (_shouldContinue && !_isPaused) {
      _currentWordIndex++;
      _speakNextWord();
    }
  }

  /// Pausar en el punto exacto
  Future<void> pause() async {
    if (_isPlaying && !_isPaused) {
      print('Pausando en palabra $_currentWordIndex de ${_words.length}');
      _isPaused = true;
      _shouldContinue = false;
      await _flutterTts.stop();
      onStateChanged?.call();
    }
  }

  /// Reanudar desde el punto exacto donde se pausó
  Future<void> resume() async {
    if (_isPaused && _words.isNotEmpty) {
      print('Reanudando desde palabra $_currentWordIndex de ${_words.length}');
      _isPaused = false;
      _shouldContinue = true;
      _isPlaying = true;
      onStateChanged?.call();
      
      await _speakNextWord();
    }
  }

  /// Detener completamente
  Future<void> stop() async {
    print('Deteniendo completamente');
    _shouldContinue = false;
    await _flutterTts.stop();
    _isPlaying = false;
    _isPaused = false;
    _currentWordIndex = 0;
    _words.clear();
    onStateChanged?.call();
  }

  /// Saltar adelante (10 palabras)
  Future<void> skipForward() async {
    if (_words.isNotEmpty) {
      _currentWordIndex = (_currentWordIndex + 2).clamp(0, _words.length - 1);
      if (_isPlaying && !_isPaused) {
        await _flutterTts.stop();
        await _speakNextWord();
      }
      onStateChanged?.call();
    }
  }

  /// Saltar atrás (10 palabras)
  Future<void> skipBackward() async {
    if (_words.isNotEmpty) {
      _currentWordIndex = (_currentWordIndex - 2).clamp(0, _words.length - 1);
      if (_isPlaying && !_isPaused) {
        await _flutterTts.stop();
        await _speakNextWord();
      }
      onStateChanged?.call();
    }
  }

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
