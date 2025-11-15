# Guía de Implementación de Text-to-Speech (TTS)

## 📦 Instalación

1. El paquete `flutter_tts` ya está agregado en `pubspec.yaml`
2. Ejecuta: `flutter pub get`

## 🎯 Uso Básico

### Opción 1: Usar el widget TtsButton (Más fácil)

```dart
import '../widgets/tts_button.dart';

// En cualquier parte de tu UI
TtsButton(
  text: 'Este es el texto que se leerá',
  title: 'Título opcional',
  icon: Icons.volume_up,
  color: Colors.blue,
)
```

### Opción 2: Usar el servicio directamente

```dart
import '../services/tts_service.dart';

class MiPantalla extends StatefulWidget {
  @override
  State<MiPantalla> createState() => _MiPantallaState();
}

class _MiPantallaState extends State<MiPantalla> {
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  void _leerTexto() async {
    await _ttsService.speak('Hola, este es un texto de ejemplo');
  }

  void _detener() async {
    await _ttsService.stop();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _leerTexto,
              child: Text('Leer'),
            ),
            ElevatedButton(
              onPressed: _detener,
              child: Text('Detener'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎨 Ejemplos de Implementación

### 1. Botón en AppBar

```dart
AppBar(
  title: Text('Mi Pantalla'),
  actions: [
    TtsButton(
      text: 'Todo el contenido de la página',
      title: 'Título de la página',
    ),
  ],
)
```

### 2. Botón junto a una sección

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Hoja de Vida', style: TextStyle(fontSize: 20)),
    TtsButton(
      text: candidato.hojaVida,
      title: 'Hoja de Vida',
      iconSize: 20,
    ),
  ],
)
```

### 3. Botón flotante para leer toda la página

```dart
floatingActionButton: FloatingActionButton.extended(
  onPressed: () async {
    final tts = TtsService();
    await tts.initialize();
    await tts.speakPageContent(
      titulo: 'Título de la página',
      contenido: 'Todo el contenido aquí',
    );
  },
  icon: Icon(Icons.volume_up),
  label: Text('Leer todo'),
)
```

## ⚙️ Configuración Avanzada

### Cambiar velocidad de lectura

```dart
final tts = TtsService();
await tts.initialize();

// En tts_service.dart, modifica:
await _flutterTts.setSpeechRate(0.5); // 0.0 (lento) - 1.0 (rápido)
```

### Cambiar idioma

```dart
// En tts_service.dart, modifica:
await _flutterTts.setLanguage("es-ES"); // Español de España
await _flutterTts.setLanguage("es-MX"); // Español de México
await _flutterTts.setLanguage("es-PE"); // Español de Perú
```

### Cambiar tono de voz

```dart
// En tts_service.dart, modifica:
await _flutterTts.setPitch(1.0); // 0.5 (grave) - 2.0 (agudo)
```

## 📱 Permisos

### Android
No requiere permisos adicionales.

### iOS
Agrega en `ios/Runner/Info.plist`:
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>Esta app usa síntesis de voz para leer contenido</string>
```

## 🔧 Solución de Problemas

### El audio no se escucha
1. Verifica que el volumen del dispositivo esté alto
2. Asegúrate de llamar a `initialize()` antes de usar TTS
3. En Android, verifica que no esté en modo silencioso

### El idioma no funciona
1. Verifica que el idioma esté instalado en el dispositivo
2. Prueba con diferentes códigos de idioma (es-ES, es-MX, es-PE)

### La app se cierra al usar TTS
1. Asegúrate de llamar a `stop()` en el `dispose()`
2. No uses TTS en widgets que se destruyen rápidamente

## 💡 Mejores Prácticas

1. **Siempre detén el TTS al salir de la pantalla**
   ```dart
   @override
   void dispose() {
     _ttsService.stop();
     super.dispose();
   }
   ```

2. **Usa textos cortos para mejor experiencia**
   - Divide textos largos en secciones
   - Permite al usuario elegir qué sección leer

3. **Indica visualmente cuando está leyendo**
   - Cambia el ícono (volume_up → stop_circle)
   - Cambia el color (azul → rojo)

4. **Proporciona control al usuario**
   - Botón para detener
   - Botón para pausar
   - Indicador de progreso (opcional)

## 📚 Recursos Adicionales

- [Documentación flutter_tts](https://pub.dev/packages/flutter_tts)
- [Códigos de idioma](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
