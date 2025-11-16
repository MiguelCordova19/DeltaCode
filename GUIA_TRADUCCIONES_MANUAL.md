# 🌍 Guía: Sistema de Traducciones Manual

## ✅ Sistema Implementado

He creado un sistema de traducciones **manual pero funcional** que:
- ✅ Funciona sin necesidad de generar archivos
- ✅ Cambia el idioma de toda la app instantáneamente
- ✅ Guarda la preferencia del usuario
- ✅ Es fácil de usar y mantener

## 📁 Archivos Creados

- `lib/utils/translations.dart` - Contiene todas las traducciones
- `lib/providers/idioma_provider.dart` - Gestiona el estado del idioma
- `lib/main.dart` - Configurado con Provider

## 🚀 Cómo Usar en tus Pantallas

### Paso 1: Importar lo necesario

```dart
import 'package:provider/provider.dart';
import '../providers/idioma_provider.dart';
import '../utils/translations.dart';
```

### Paso 2: Obtener el idioma actual

```dart
@override
Widget build(BuildContext context) {
  final idioma = Provider.of<IdiomaProvider>(context).locale.languageCode;
  
  return Scaffold(
    appBar: AppBar(
      title: Text(Translations.get('myProfile', idioma)),
    ),
    // ...
  );
}
```

### Paso 3: Usar las traducciones

```dart
// Textos simples
Text(Translations.get('home', idioma))           // "Inicio" o "Qallariy"
Text(Translations.get('discover', idioma))       // "Descubre" o "Tariy"
Text(Translations.get('candidates', idioma))     // "Candidatos" o "Akllasqakuna"

// Textos con parámetros
Text(Translations.welcome('Juan', idioma))       // "¡Bienvenido, Juan!" o "¡Allin hamusqayki, Juan!"
```

## 🎨 Ejemplo Completo: Actualizar una Pantalla

### Antes (sin traducciones):
```dart
import 'package:flutter/material.dart';

class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Información Personal'),
            subtitle: const Text('Edita tus datos personales'),
          ),
          ListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Configura tus alertas'),
          ),
        ],
      ),
    );
  }
}
```

### Después (con traducciones):
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/idioma_provider.dart';
import '../utils/translations.dart';

class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final idioma = Provider.of<IdiomaProvider>(context).locale.languageCode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('myProfile', idioma)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(Translations.get('personalInfo', idioma)),
            subtitle: Text(Translations.get('personalInfoSubtitle', idioma)),
          ),
          ListTile(
            title: Text(Translations.get('notifications', idioma)),
            subtitle: Text(Translations.get('notificationsSubtitle', idioma)),
          ),
        ],
      ),
    );
  }
}
```

## 📝 Traducciones Disponibles

### Navegación
```dart
Translations.get('home', idioma)          // "Inicio" / "Qallariy"
Translations.get('chat', idioma)          // "Chat" / "Rimanakuy"
Translations.get('calendar', idioma)      // "Calendario" / "Punchaw Qillqa"
Translations.get('profile', idioma)       // "Perfil" / "Ñuqa"
```

### Secciones
```dart
Translations.get('discover', idioma)              // "Descubre" / "Tariy"
Translations.get('governmentPlans', idioma)       // "Planes de\nGobierno" / "Kamachiy\nYuyaykuna"
Translations.get('candidates', idioma)            // "Candidatos" / "Akllasqakuna"
Translations.get('myVotingPlace', idioma)         // "Mi Local" / "Ñuqap Wasin"
Translations.get('news', idioma)                  // "Noticias" / "Willakuykuna"
```

### Acciones
```dart
Translations.get('viewDetails', idioma)       // "Ver Detalles" / "Qhaway Astawan"
Translations.get('close', idioma)             // "Cerrar" / "Wichqay"
Translations.get('login', idioma)             // "Iniciar Sesión" / "Yaykuy"
```

### Con Parámetros
```dart
Translations.welcome('Juan', idioma)   // "¡Bienvenido, Juan!" / "¡Allin hamusqayki, Juan!"
```

## ➕ Agregar Nuevas Traducciones

Edita `lib/utils/translations.dart` y agrega nuevas entradas:

```dart
static final Map<String, Map<String, String>> _translations = {
  // ... traducciones existentes ...
  
  // Nueva traducción
  'nuevaClave': {'es': 'Texto en español', 'qu': 'Texto en quechua'},
};
```

Luego úsala:
```dart
Text(Translations.get('nuevaClave', idioma))
```

## 🔄 Cómo Funciona el Cambio de Idioma

1. Usuario va a **Perfil → Idioma de la Aplicación**
2. Selecciona **Quechua**
3. `IdiomaProvider` cambia el `Locale`
4. **Toda la app se reconstruye** automáticamente
5. Todas las pantallas que usan `Translations.get()` muestran textos en Quechua

## 🎯 Ventajas de Este Sistema

✅ **Simple**: No requiere generación de archivos  
✅ **Funcional**: Cambia el idioma instantáneamente  
✅ **Mantenible**: Todas las traducciones en un solo archivo  
✅ **Escalable**: Fácil agregar más idiomas  
✅ **Sin Errores**: No depende de configuraciones complejas  

## 📋 Checklist de Implementación

### Pantallas por Actualizar:

- [ ] `home_screen_content.dart`
- [ ] `perfil_screen.dart`
- [ ] `login_screen.dart`
- [ ] `planes_gobierno_screen.dart`
- [ ] `candidatos_screen.dart`
- [ ] `noticias_screen.dart`
- [ ] `calendario_electoral_screen.dart`

### Para cada pantalla:

1. Importar Provider y Translations
2. Obtener el idioma actual
3. Reemplazar textos hardcodeados con `Translations.get()`
4. Probar el cambio de idioma

## 🎉 ¡Listo!

Tu app ahora tiene un sistema de traducciones funcional. Solo necesitas actualizar las pantallas una por una siguiendo los ejemplos.

**Kunan Quechuapi rimankichik!** 🚀
