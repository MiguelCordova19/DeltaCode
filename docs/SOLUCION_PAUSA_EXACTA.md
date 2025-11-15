# Solución: Pausa y Reanudación Exacta en TTS

## 🎯 El Problema

Flutter TTS no soporta pausa/reanudación nativa en Android. Cuando llamas a `pause()`, realmente detiene el audio y no hay forma de reanudar desde el punto exacto.

## ✅ Soluciones Disponibles

### Solución 1: División en Grupos de Palabras (Implementada)

**Archivo**: `lib/services/tts_service_advanced.dart`

#### Cómo Funciona:
1. Divide el texto en grupos de 5 palabras
2. Lee cada grupo secuencialmente
3. Al pausar, guarda el índice del grupo actual
4. Al reanudar, continúa desde ese grupo

#### Ventajas:
- ✅ No requiere paquetes adicionales
- ✅ Pausa casi exacta (máximo 5 palabras de diferencia)
- ✅ Incluye progreso (X de Y grupos)
- ✅ Permite saltar adelante/atrás

#### Desventajas:
- ❌ Pequeñas pausas entre grupos (casi imperceptibles)
- ❌ No es 100% exacto (pausa al final del grupo)

#### Uso:
```dart
// En lugar de TtsService, usa TtsServiceAdvanced
final TtsService _ttsService = TtsServiceAdvanced();

// Escuchar progreso
_ttsService.onProgress = (current, total) {
  print('Progreso: $current de $total');
  // Actualizar barra de progreso
};

// Pausar/Reanudar funciona exactamente igual
await _ttsService.pause();
await _ttsService.resume();

// Nuevas funciones
await _ttsService.skipForward(); // Saltar 10 palabras adelante
await _ttsService.skipBackward(); // Saltar 10 palabras atrás
```

---

### Solución 2: Convertir TTS a Audio y Usar Reproductor

**Requiere**: `just_audio` + API de TTS externa

#### Cómo Funciona:
1. Convertir el texto a archivo de audio MP3 usando una API
2. Reproducir el audio con `just_audio`
3. `just_audio` soporta pausa/reanudación perfecta

#### APIs Disponibles:
- **Google Cloud Text-to-Speech**: $4 por 1M caracteres
- **Amazon Polly**: $4 por 1M caracteres
- **Microsoft Azure**: $4 por 1M caracteres
- **ElevenLabs**: Más natural, más caro

#### Ventajas:
- ✅ Pausa/reanudación 100% exacta
- ✅ Barra de progreso precisa
- ✅ Saltar a cualquier punto
- ✅ Control de velocidad en tiempo real
- ✅ Audio de mejor calidad

#### Desventajas:
- ❌ Requiere conexión a internet
- ❌ Costo por uso de API
- ❌ Latencia inicial (generar audio)
- ❌ Más complejo de implementar

#### Implementación:

**1. Agregar dependencias:**
```yaml
dependencies:
  just_audio: ^0.9.36
  http: ^1.1.0
```

**2. Código de ejemplo:**
```dart
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class TtsAudioService {
  final AudioPlayer _player = AudioPlayer();
  
  Future<void> speakWithAudio(String text) async {
    // 1. Convertir texto a audio usando API
    final audioUrl = await _textToAudioUrl(text);
    
    // 2. Cargar y reproducir
    await _player.setUrl(audioUrl);
    await _player.play();
  }
  
  Future<String> _textToAudioUrl(String text) async {
    // Llamar a API de TTS (ejemplo con Google Cloud)
    final response = await http.post(
      Uri.parse('https://texttospeech.googleapis.com/v1/text:synthesize'),
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'input': {'text': text},
        'voice': {
          'languageCode': 'es-ES',
          'name': 'es-ES-Standard-A',
        },
        'audioConfig': {'audioEncoding': 'MP3'},
      }),
    );
    
    // Retornar URL del audio generado
    return 'url_del_audio.mp3';
  }
  
  // Pausa perfecta
  Future<void> pause() => _player.pause();
  
  // Reanudación perfecta
  Future<void> resume() => _player.play();
  
  // Saltar a posición exacta
  Future<void> seek(Duration position) => _player.seek(position);
  
  // Obtener posición actual
  Duration? get position => _player.position;
  
  // Obtener duración total
  Duration? get duration => _player.duration;
}
```

---

### Solución 3: Híbrida (Recomendada para tu caso)

Combinar ambas soluciones:

1. **Modo Offline**: Usar `TtsServiceAdvanced` (grupos de palabras)
2. **Modo Online**: Usar API + `just_audio` (pausa perfecta)

#### Implementación:
```dart
class TtsServiceHybrid {
  final TtsServiceAdvanced _offlineService = TtsServiceAdvanced();
  final TtsAudioService _onlineService = TtsAudioService();
  bool _useOnlineMode = false;
  
  Future<void> speak(String text) async {
    if (_useOnlineMode && await _hasInternet()) {
      await _onlineService.speakWithAudio(text);
    } else {
      await _offlineService.speak(text);
    }
  }
  
  Future<void> pause() async {
    if (_useOnlineMode) {
      await _onlineService.pause();
    } else {
      await _offlineService.pause();
    }
  }
  
  Future<void> resume() async {
    if (_useOnlineMode) {
      await _onlineService.resume();
    } else {
      await _offlineService.resume();
    }
  }
}
```

---

## 📊 Comparación

| Característica | Actual (Oraciones) | Avanzado (Palabras) | Audio API |
|----------------|-------------------|---------------------|-----------|
| Precisión pausa | ~50 palabras | ~5 palabras | 100% exacto |
| Requiere internet | ❌ | ❌ | ✅ |
| Costo | Gratis | Gratis | ~$4/1M chars |
| Latencia | Instantáneo | Instantáneo | 1-3 segundos |
| Progreso preciso | ❌ | ✅ | ✅ |
| Saltar adelante/atrás | ❌ | ✅ | ✅ |
| Calidad audio | Sistema | Sistema | Alta |

---

## 🚀 Recomendación

Para tu app de elecciones, te recomiendo:

### Opción A: Usar TtsServiceAdvanced (Implementado)
- **Pros**: Gratis, offline, suficientemente preciso
- **Cons**: Pausa cada ~5 palabras
- **Ideal para**: Textos cortos (biografías, hojas de vida)

### Opción B: Implementar modo híbrido
- **Pros**: Mejor experiencia cuando hay internet
- **Cons**: Más complejo, requiere API key
- **Ideal para**: App profesional con presupuesto

---

## 💡 Cómo Cambiar al Servicio Avanzado

1. **Reemplazar el import:**
```dart
// Antes
import '../services/tts_service.dart';

// Después
import '../services/tts_service_advanced.dart';
```

2. **Cambiar la instancia:**
```dart
// Antes
final TtsService _ttsService = TtsService();

// Después  
final TtsServiceAdvanced _ttsService = TtsServiceAdvanced();
```

3. **Agregar barra de progreso (opcional):**
```dart
_ttsService.onProgress = (current, total) {
  setState(() {
    _progress = current / total;
  });
};

// En el UI
LinearProgressIndicator(value: _progress)
```

4. **Agregar botones de saltar (opcional):**
```dart
IconButton(
  icon: Icon(Icons.fast_rewind),
  onPressed: () => _ttsService.skipBackward(),
),
IconButton(
  icon: Icon(Icons.fast_forward),
  onPressed: () => _ttsService.skipForward(),
),
```

---

## 🎯 Conclusión

- **Para tu caso actual**: `TtsServiceAdvanced` es suficiente
- **Para producción profesional**: Considera API + just_audio
- **Mejor de ambos mundos**: Implementa modo híbrido

¿Quieres que implemente alguna de estas soluciones en tu app?
