# Guía: TTS Advanced Implementado

## ✅ Cambios Realizados

### 1. **Servicio Actualizado**
- ✅ Cambiado de `TtsService` a `TtsServiceAdvanced`
- ✅ División del texto en grupos de 5 palabras
- ✅ Pausa/reanudación casi exacta
- ✅ Sistema de progreso implementado

### 2. **Nuevas Funcionalidades**

#### Barra de Progreso
- Muestra el porcentaje de lectura (0-100%)
- Se actualiza en tiempo real
- Visible en la barra de estado morada/naranja

#### Botones de Saltar
- **⏪ Retroceder**: Salta 10 palabras atrás
- **⏩ Avanzar**: Salta 10 palabras adelante
- Ubicados en la barra de estado

#### Indicador de Progreso Visual
- Barra de progreso lineal debajo del estado
- Color blanco sobre fondo morado/naranja
- Animación suave

### 3. **Mejoras en la Pausa**

**Antes:**
- Pausaba al final de una oración (~50 palabras)
- Al reanudar, podía reiniciar desde el inicio

**Ahora:**
- Pausa cada 5 palabras máximo
- Al reanudar, continúa exactamente desde donde se pausó
- Muestra el porcentaje exacto donde se pausó

## 🎯 Cómo Funciona

### División del Texto

**Texto original:**
```
"Economista de la Universidad Nacional Mayor de San Marcos. 
Maestría en Políticas Públicas de Harvard University. 
Ex Ministro de Economía entre 2018 y 2020."
```

**Se divide en grupos de 5 palabras:**
```
Grupo 1: "Economista de la Universidad Nacional"
Grupo 2: "Mayor de San Marcos. Maestría"
Grupo 3: "en Políticas Públicas de Harvard"
Grupo 4: "University. Ex Ministro de Economía"
Grupo 5: "entre 2018 y 2020."
```

### Flujo de Lectura

1. **Inicio**: Lee grupo 1
2. **Completado grupo 1**: Automáticamente lee grupo 2
3. **Usuario pausa en grupo 3**: Se detiene
4. **Usuario reanuda**: Continúa desde grupo 3
5. **Termina todos los grupos**: Se detiene automáticamente

## 🎨 Interfaz de Usuario

### Barra de Estado (cuando está leyendo)

```
┌─────────────────────────────────────────────┐
│  ⏪    🔊 Leyendo... 45%    ⏩              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
└─────────────────────────────────────────────┘
```

**Cuando está pausado:**
```
┌─────────────────────────────────────────────┐
│  ⏪    ⏸️ En pausa - 45%    ⏩              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
└─────────────────────────────────────────────┘
```

### Botones Flotantes

**No leyendo:**
```
┌──────────────┐
│ 🔊 Leer todo │
└──────────────┘
```

**Leyendo:**
```
┌────┐  ┌────┐
│ ⏸️ │  │ ⏹️ │
└────┘  └────┘
```

**Pausado:**
```
┌────┐  ┌────┐
│ ▶️ │  │ ⏹️ │
└────┘  └────┘
```

## 🎮 Controles Disponibles

### En el AppBar (arriba):
- ⚙️ **Configurar voz**: Abre configuración
- ⏸️ **Pausar**: Pausa la lectura (solo visible cuando lee)
- ▶️ **Reanudar**: Continúa la lectura (solo visible cuando está pausado)
- ⏹️ **Detener**: Detiene completamente (solo visible cuando lee)

### En la Barra de Estado:
- ⏪ **Retroceder**: Salta 10 palabras atrás
- ⏩ **Avanzar**: Salta 10 palabras adelante
- 📊 **Progreso**: Muestra porcentaje actual

### Botones Flotantes:
- 🔊 **Leer todo**: Inicia lectura completa
- ⏸️/▶️ **Pausar/Reanudar**: Control de pausa
- ⏹️ **Detener**: Detiene y vuelve al inicio

### Botones de Sección:
- 🔊 **Junto a "Hoja de Vida"**: Lee solo esa sección
- 🔊 **Junto a "Biografía"**: Lee solo esa sección

## 📊 Progreso y Estadísticas

### Información Disponible:
```dart
// Progreso actual (0.0 - 1.0)
double progress = _ttsService.progress;

// Callback de progreso
_ttsService.onProgress = (current, total) {
  print('Leyendo grupo $current de $total');
  print('Progreso: ${(current/total * 100).toInt()}%');
};
```

### Ejemplo de Uso:
```dart
// Mostrar en UI
Text('${(_progress * 100).toInt()}% completado')

// Barra de progreso
LinearProgressIndicator(value: _progress)

// Tiempo estimado (si conoces la velocidad)
final wordsPerMinute = 150;
final totalWords = _ttsService._words.length * 5;
final minutesRemaining = (totalWords * (1 - _progress)) / wordsPerMinute;
```

## 🔧 Configuración Avanzada

### Ajustar Tamaño de Grupos

En `tts_service_advanced.dart`, línea ~150:
```dart
// Cambiar de 5 a otro número
_words = _splitIntoWordGroups(text, wordsPerGroup: 5);
```

**Recomendaciones:**
- **3 palabras**: Pausa más precisa, más pausas entre grupos
- **5 palabras**: Balance ideal (implementado)
- **10 palabras**: Menos pausas, menos preciso

### Ajustar Velocidad de Salto

En `tts_service_advanced.dart`, métodos `skipForward` y `skipBackward`:
```dart
// Cambiar el número de grupos a saltar
_currentWordIndex = (_currentWordIndex + 2).clamp(0, _words.length - 1);
```

**Ejemplo:**
- `+ 2`: Salta 10 palabras (2 grupos × 5 palabras)
- `+ 4`: Salta 20 palabras (4 grupos × 5 palabras)

## 🐛 Solución de Problemas

### Problema: Pausas muy frecuentes
**Solución**: Aumentar `wordsPerGroup` a 7 o 10

### Problema: Pausa no es suficientemente precisa
**Solución**: Reducir `wordsPerGroup` a 3

### Problema: Los botones de saltar no funcionan
**Solución**: Verificar que `_ttsService.onProgress` esté configurado

### Problema: El progreso no se actualiza
**Solución**: Verificar que el callback esté en `initState`:
```dart
_ttsService.onProgress = (current, total) {
  if (mounted) {
    setState(() {
      _progress = current / total;
    });
  }
};
```

## 🚀 Próximas Mejoras Posibles

1. **Marcadores**: Guardar posiciones favoritas
2. **Historial**: Recordar última posición de lectura
3. **Velocidad variable**: Cambiar velocidad en tiempo real
4. **Resaltado**: Resaltar texto que se está leyendo
5. **Modo nocturno**: Tema oscuro para lectura nocturna
6. **Compartir posición**: Compartir timestamp con otros usuarios

## 📝 Notas Importantes

1. **Precisión**: La pausa es casi exacta (±5 palabras)
2. **Rendimiento**: No afecta el rendimiento de la app
3. **Compatibilidad**: Funciona en Android e iOS
4. **Offline**: No requiere conexión a internet
5. **Gratis**: Sin costos adicionales

## ✨ Resultado Final

Ahora tu app tiene:
- ✅ Pausa/reanudación casi exacta
- ✅ Barra de progreso visual
- ✅ Botones para saltar adelante/atrás
- ✅ Indicador de porcentaje
- ✅ Transiciones suaves
- ✅ Mejor experiencia de usuario

¡Disfruta de la nueva funcionalidad! 🎉
