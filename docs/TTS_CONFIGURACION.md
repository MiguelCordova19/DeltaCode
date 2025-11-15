# Configuración de Voz (Text-to-Speech)

## 🎤 Características Implementadas

### 1. Selector de Voces
- Muestra todas las voces disponibles en español en el dispositivo
- Permite seleccionar la voz preferida
- Opción de "Voz por defecto" del sistema

### 2. Controles de Reproducción
- ▶️ **Play**: Inicia la lectura
- ⏸️ **Pausa**: Pausa la lectura actual
- ⏹️ **Stop**: Detiene completamente la lectura

### 3. Ajustes Personalizables
- **Velocidad**: 0.1 - 1.0 (lento a rápido)
- **Tono**: 0.5 - 2.0 (grave a agudo)
- **Volumen**: 0% - 100%

### 4. Botón de Prueba
- Prueba la configuración antes de guardar
- Reproduce un texto de ejemplo

## 📱 Cómo Usar

### En la Pantalla de Candidatos:

1. **Abrir Configuración**:
   - Toca el ícono ⚙️ (engranaje con voz) en la parte superior derecha
   - Se abrirá el diálogo de configuración

2. **Seleccionar Voz**:
   - Despliega el menú "Seleccionar Voz"
   - Elige la voz que prefieras
   - Toca "Probar Voz" para escucharla

3. **Ajustar Configuración**:
   - Mueve los sliders de velocidad, tono y volumen
   - Prueba cada cambio con el botón "Probar Voz"

4. **Guardar**:
   - Toca "Guardar" para aplicar los cambios
   - Toca "Cancelar" para descartar

### Controles Durante la Lectura:

**En el AppBar (arriba):**
- ⚙️ Configurar voz
- ⏸️ Pausar/Reanudar (aparece cuando está leyendo)
- ⏹️ Detener (aparece cuando está leyendo)

**Botones Flotantes (abajo):**
- Cuando NO está leyendo: "Leer todo" (botón morado)
- Cuando SÍ está leyendo: 
  - ⏸️ Pausar (botón morado)
  - ⏹️ Detener (botón rojo)

**Botones por Sección:**
- 🔊 Junto a "Hoja de Vida": Lee solo esa sección
- 🔊 Junto a "Biografía": Lee solo esa sección

## 🎯 Flujo de Uso Típico

```
1. Usuario entra a ver un candidato
2. Toca el ícono ⚙️ para configurar la voz
3. Selecciona su voz preferida
4. Ajusta velocidad y tono
5. Prueba la configuración
6. Guarda los cambios
7. Toca "Leer todo" para escuchar
8. Puede pausar/reanudar cuando quiera
9. Puede detener en cualquier momento
```

## 🔧 Detalles Técnicos

### Archivos Creados:
- `lib/models/tts_config.dart` - Modelo de configuración
- `lib/widgets/tts_config_dialog.dart` - Diálogo de configuración
- `lib/services/tts_service.dart` - Servicio actualizado con voces

### Configuración Persistente:
La configuración se mantiene durante la sesión de la app. Para hacerla permanente, necesitarías agregar:
- `shared_preferences` para guardar en el dispositivo
- Cargar la configuración al iniciar la app

### Voces Disponibles:
Las voces dependen del dispositivo:
- **Android**: Usa las voces de Google TTS instaladas
- **iOS**: Usa las voces de Siri instaladas
- Si no hay voces en español, usa la voz por defecto del sistema

## 📝 Notas Importantes

1. **Pausa en Android**: 
   - La pausa real no está soportada nativamente
   - Al "reanudar", reinicia la lectura desde el principio
   - Es una limitación de Flutter TTS

2. **Voces del Sistema**:
   - El usuario debe tener voces en español instaladas
   - En Android: Configuración > Idioma > Texto a voz
   - En iOS: Configuración > Accesibilidad > Contenido Hablado

3. **Rendimiento**:
   - La primera vez puede tardar en cargar las voces
   - Las voces se cargan una sola vez al inicializar

## 🚀 Mejoras Futuras Sugeridas

1. **Persistencia**:
   ```dart
   // Agregar shared_preferences
   dependencies:
     shared_preferences: ^2.2.2
   ```

2. **Resaltado de Texto**:
   - Resaltar el texto que se está leyendo
   - Usar `setProgressHandler` de flutter_tts

3. **Control de Velocidad en Tiempo Real**:
   - Cambiar velocidad mientras lee
   - Botones +/- para ajuste rápido

4. **Marcadores**:
   - Guardar posición de lectura
   - Continuar desde donde se dejó

5. **Modo Nocturno**:
   - Tema oscuro para lectura nocturna
   - Reducir brillo automáticamente
