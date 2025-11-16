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
    try {
      // Configurar handlers primero
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

      // Esperar un momento para que el motor se vincule
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Cargar voces disponibles primero
      await loadAvailableVoices();
      
      // Aplicar configuración (ahora con voz femenina si está disponible)
      await applyConfig(_config);
      
      print('TTS: Inicialización completada');
    } catch (e) {
      print('TTS: Error en inicialización - $e');
    }
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
        
        // Si no hay voz seleccionada, seleccionar automáticamente una voz femenina en español
        if (_config.selectedVoice == null && _availableVoices.isNotEmpty) {
          // Buscar una voz femenina en español
          final femaleVoice = _availableVoices.firstWhere(
            (voice) => voice.name.toLowerCase().contains('female'),
            orElse: () => _availableVoices.first,
          );
          
          // Actualizar configuración con la voz femenina
          _config = _config.copyWith(selectedVoice: femaleVoice.name);
          
          // Aplicar la voz
          await _flutterTts.setVoice({
            "name": femaleVoice.name,
            "locale": femaleVoice.locale,
          });
          
          print('TTS: Voz femenina por defecto configurada - ${femaleVoice.name}');
        }
      }
    } catch (e) {
      print('Error al cargar voces: $e');
    }
  }

  Future<void> applyConfig(TtsConfig config) async {
    try {
      _config = config;
      
      // Configurar idioma
      final langResult = await _flutterTts.setLanguage(config.language);
      print('TTS: Idioma configurado - $langResult');
      
      // Configurar parámetros
      await _flutterTts.setSpeechRate(config.speechRate);
      await _flutterTts.setVolume(config.volume);
      await _flutterTts.setPitch(config.pitch);
      
      // Configurar voz específica si está seleccionada
      if (config.selectedVoice != null) {
        await _flutterTts.setVoice({
          "name": config.selectedVoice!,
          "locale": config.language,
        });
        print('TTS: Voz configurada - ${config.selectedVoice}');
      }
      
      // Verificar que el motor esté listo
      final engines = await _flutterTts.getEngines;
      print('TTS: Motores disponibles - $engines');
      
    } catch (e) {
      print('TTS: Error al aplicar configuración - $e');
    }
  }

  Future<void> updateConfig(TtsConfig newConfig) async {
    await applyConfig(newConfig);
  }

  /// Hablar texto con capacidad de pausa/reanudación precisa
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    // Dividir en oraciones para lectura más fluida
    _words = _splitIntoSentences(text);
    _currentWordIndex = 0;
    _shouldContinue = true;
    _isPlaying = true;
    _isPaused = false;
    
    onStateChanged?.call();
    
    await _speakNextWord();
  }

  List<String> _splitIntoSentences(String text) {
    // Limpiar el texto
    final cleanText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // Dividir por oraciones (punto, punto y coma, dos puntos, saltos de línea)
    final sentences = cleanText.split(RegExp(r'[.;:\n]+'));
    
    // Filtrar oraciones vacías y limpiar espacios
    final validSentences = sentences
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    
    // Si no hay oraciones válidas o el texto es muy corto, dividir en párrafos grandes
    if (validSentences.isEmpty || validSentences.length == 1) {
      // Dividir en fragmentos de aproximadamente 50 palabras
      final words = cleanText.split(' ');
      final chunks = <String>[];
      
      for (int i = 0; i < words.length; i += 50) {
        final end = (i + 50 < words.length) ? i + 50 : words.length;
        final chunk = words.sublist(i, end).join(' ');
        chunks.add(chunk);
      }
      
      return chunks.isEmpty ? [cleanText] : chunks;
    }
    
    return validSentences;
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
    
    try {
      final result = await _flutterTts.speak(word);
      if (result == 0) {
        print('TTS: Error al hablar - Motor no vinculado');
        // Intentar reinicializar
        await Future.delayed(const Duration(milliseconds: 100));
        await applyConfig(_config);
        // Reintentar
        await _flutterTts.speak(word);
      }
    } catch (e) {
      print('TTS: Excepción al hablar - $e');
      _isPlaying = false;
      _isPaused = false;
      onStateChanged?.call();
    }
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

  /// Saltar adelante (1 oración)
  Future<void> skipForward() async {
    if (_words.isNotEmpty) {
      _currentWordIndex = (_currentWordIndex + 1).clamp(0, _words.length - 1);
      if (_isPlaying && !_isPaused) {
        await _flutterTts.stop();
        await _speakNextWord();
      }
      onStateChanged?.call();
    }
  }

  /// Saltar atrás (1 oración)
  Future<void> skipBackward() async {
    if (_words.isNotEmpty) {
      _currentWordIndex = (_currentWordIndex - 1).clamp(0, _words.length - 1);
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
