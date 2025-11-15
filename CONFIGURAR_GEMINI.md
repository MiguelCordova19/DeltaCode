# Configurar Gemini AI - Asistente Electoral

## 🤖 ¿Qué es Gemini Flash?

Gemini Flash es el modelo de IA de Google, **completamente gratuito**, optimizado para respuestas rápidas y conversaciones naturales.

## 📝 Pasos para configurar

### 1. Obtener API Key (Gratis)

1. Ve a: **https://makersuite.google.com/app/apikey**
2. Inicia sesión con tu cuenta de Google
3. Haz clic en "Create API Key"
4. Copia la API key generada

### 2. Configurar en la app

1. Abre el archivo: `lib/services/gemini_service.dart`
2. Busca la línea:
   ```dart
   static const String _apiKey = 'TU_API_KEY_AQUI';
   ```
3. Reemplaza `'TU_API_KEY_AQUI'` con tu API key:
   ```dart
   static const String _apiKey = 'AIzaSy...tu_key_aqui';
   ```
4. Guarda el archivo

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. ¡Listo!

Ahora el asistente electoral funcionará correctamente.

## 🎯 Características del Asistente

### ✅ Responde SOLO sobre temas electorales:
- Partidos políticos peruanos
- Candidatos presidenciales
- Planes de gobierno
- Proceso electoral (JNE, ONPE, RENIEC)
- Locales de votación
- Cómo votar correctamente
- Derechos y deberes de votantes

### ❌ NO responde sobre:
- Deportes
- Entretenimiento
- Tecnología no relacionada
- Temas personales
- Cualquier cosa fuera del ámbito electoral

## 🔒 Seguridad

El asistente está configurado con un "system prompt" que limita sus respuestas exclusivamente a temas electorales. Si alguien pregunta sobre otros temas, responderá amablemente que solo puede ayudar con información electoral.

## 💡 Ejemplos de preguntas válidas

- "¿Cuáles son los partidos políticos principales en Perú?"
- "¿Cómo funciona el proceso electoral?"
- "¿Qué es el JNE?"
- "¿Cuándo son las elecciones 2026?"
- "¿Qué documentos necesito para votar?"
- "Explícame qué hace un miembro de mesa"

## 🚫 Ejemplos de preguntas rechazadas

- "¿Quién ganó el último partido de fútbol?"
- "Recomiéndame una película"
- "¿Cómo cocino arroz?"

El asistente responderá: "Lo siento, solo puedo ayudarte con información sobre las Elecciones 2026 y temas electorales en Perú."

## 📊 Límites gratuitos de Gemini Flash

- **15 solicitudes por minuto**
- **1 millón de tokens por día**
- **1,500 solicitudes por día**

Más que suficiente para una app electoral! 🎉

## 🔧 Solución de problemas

### Error: "API key no configurada"
- Verifica que hayas copiado correctamente la API key
- Asegúrate de que no tenga espacios al inicio o final
- La key debe empezar con "AIza..."

### Error de conexión
- Verifica tu conexión a internet
- Asegúrate de que la API key sea válida
- Revisa que no hayas excedido los límites gratuitos

## 📱 Uso en la app

1. Abre la app
2. Toca el ícono "Asistente" en el menú inferior
3. Escribe tu pregunta sobre elecciones
4. ¡Recibe respuestas instantáneas!

## 🌟 Ventajas

- ✅ Completamente gratuito
- ✅ Respuestas rápidas (Flash model)
- ✅ Contexto de conversación
- ✅ Limitado a temas electorales
- ✅ Interfaz amigable tipo chat
- ✅ Historial de conversación
