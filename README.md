# App Electoral - Elecciones Presidenciales Perú 2026

Aplicación móvil desarrollada en Flutter para informar a los ciudadanos sobre las Elecciones Presidenciales de Perú 2026.

## 🎯 Características

### 📱 Funcionalidades principales

- **Información de Candidatos**: Perfiles completos de candidatos presidenciales
- **Partidos Políticos**: Información detallada de partidos y sus propuestas
- **Planes de Gobierno**: Acceso a los planes de gobierno de cada partido
- **Noticias Electorales**: Noticias en tiempo real de El Comercio sobre las elecciones
- **Locales de Votación**: Mapas interactivos con locales de votación en Chimbote
- **Miembros de Mesa**: Información sobre derechos y obligaciones
- **Asistente Electoral IA**: Chatbot con Gemini AI para responder preguntas electorales
- **Text-to-Speech**: Escucha las respuestas del asistente

### 🤖 Asistente Electoral con IA

- Powered by Google Gemini 2.0 Flash
- Responde solo preguntas sobre elecciones y política peruana
- Información actualizada sobre el proceso electoral 2026
- Soporte de voz (Text-to-Speech) en español

### 🗺️ Mapas de Locales de Votación

- Integración con Google Maps
- Locales de votación en Chimbote y Nuevo Chimbote
- Navegación directa con Google Maps o Waze
- Mapas embebidos en la aplicación

### 📰 Noticias Electorales

- Web scraping de El Comercio
- Filtrado inteligente de noticias electorales
- Búsqueda y filtros por distrito
- Actualización en tiempo real

## 🚀 Instalación

### Requisitos previos

- Flutter SDK (3.10.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Cuenta de Google para API de Gemini

### Pasos de instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/TU_USUARIO/app-electoral-peru-2026.git
cd app-electoral-peru-2026
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar API Key de Gemini**
   - Ve a https://aistudio.google.com/app/apikey
   - Crea una API key gratuita
   - Abre `lib/services/gemini_service.dart`
   - Reemplaza `TU_API_KEY_AQUI` con tu API key

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📦 Dependencias principales

```yaml
dependencies:
  flutter_tts: ^4.0.2              # Text-to-Speech
  shared_preferences: ^2.2.2       # Almacenamiento local
  http: ^1.1.0                     # Peticiones HTTP
  html: ^0.15.4                    # Parsing HTML
  url_launcher: ^6.2.1             # Abrir URLs
  webview_flutter: ^4.4.2          # WebView para mapas
  google_generative_ai: ^0.2.2     # Gemini AI
```

## 🏗️ Estructura del proyecto

```
lib/
├── models/              # Modelos de datos
│   ├── candidato.dart
│   ├── partido_politico.dart
│   ├── noticia.dart
│   ├── local_votacion.dart
│   └── mensaje_chat.dart
├── screens/             # Pantallas de la app
│   ├── home_screen.dart
│   ├── candidatos_screen.dart
│   ├── noticias_screen.dart
│   ├── locales_votacion_screen.dart
│   ├── chat_electoral_screen.dart
│   └── ...
├── services/            # Servicios y lógica de negocio
│   ├── gemini_service.dart
│   ├── noticias_service.dart
│   ├── locales_votacion_service.dart
│   └── auth_service.dart
└── widgets/             # Widgets reutilizables
    ├── info_card.dart
    ├── menu_button.dart
    └── tts_button.dart
```

## 🔐 Seguridad

⚠️ **IMPORTANTE**: No subas tu API key de Gemini al repositorio público.

- La API key está en `.gitignore`
- En producción, usa variables de entorno
- Considera usar Firebase Remote Config para keys

## 🌟 Características técnicas

- **Arquitectura**: MVC con servicios
- **Estado**: setState (puede migrar a Provider/Riverpod)
- **Navegación**: Navigator 2.0
- **Almacenamiento**: SharedPreferences
- **API**: Google Gemini AI, Web Scraping
- **Mapas**: Google Maps Embed API

## 📱 Plataformas soportadas

- ✅ Android
- ✅ iOS
- ⚠️ Web (parcial, sin TTS)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la Licencia MIT.

## 👥 Autores

- **DeltaCode Team** - Desarrollo inicial

## 🙏 Agradecimientos

- Google Gemini AI por la API gratuita
- El Comercio por las noticias electorales
- JNE, ONPE, RENIEC por la información electoral oficial

## 📞 Contacto

Para preguntas o sugerencias, abre un issue en GitHub.

---

Hecho con ❤️ para las Elecciones Presidenciales Perú 2026
