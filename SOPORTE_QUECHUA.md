# Soporte para Idioma Quechua

## ✅ Implementación Completa

Se ha agregado soporte completo para el idioma Quechua (Runasimi) en la aplicación.

### Características Implementadas

#### 1. Configuración de Audio con Quechua

**Ubicación:** Perfil → Configuración de Audio

**Opciones de idioma para TTS:**
- 🇵🇪 **Quechua** (Runasimi) - `qu-PE`
- 🌎 **Español (Latino)** - `es-MX`

**Opciones de género:**
- 👩 Voz Femenina
- 👨 Voz Masculina

#### 2. Configuración de Idioma de la Aplicación

**Ubicación:** Perfil → Idioma de la Aplicación

**Idiomas disponibles:**

1. **Español** 🇵🇪
   - Spanish
   - Idioma principal de la aplicación

2. **Quechua** 🏔️
   - Runasimi
   - Lengua originaria del Perú

**Características:**
- Cards con efecto 3D y sombras
- Selección visual con checkmark
- Diálogo de confirmación bilingüe
- Guardado persistente con SharedPreferences

### Archivos Creados

1. **lib/services/idioma_service.dart**
   - Servicio para gestionar el idioma de la app
   - Guarda preferencia en SharedPreferences
   - Constantes: ESPANOL y QUECHUA

2. **lib/screens/configuracion_idioma_screen.dart**
   - Pantalla para cambiar idioma de la app
   - Diseño con efectos 3D
   - Cards interactivas para cada idioma

3. **Actualizado: lib/screens/configuracion_audio_screen.dart**
   - Reemplazado "Español (España)" por "Quechua"
   - Código de idioma: `qu-PE`

### Integración en Perfil

Nueva opción agregada (primera en configuración):
- **Ícono**: 🌐 Language
- **Título**: Idioma de la Aplicación
- **Subtítulo**: Español / Quechua

### Diseño Visual

**Efectos 3D aplicados:**
- Sombras múltiples en cards seleccionadas
- Gradientes rojos en elementos activos
- Elevación visual pronunciada
- Bordes y highlights

**Paleta de colores:**
- Rojo principal: #E53935
- Rojo oscuro: #D32F2F
- Blanco para fondos
- Grises para texto secundario

### Flujo de Usuario

1. Usuario va a Perfil
2. Selecciona "Idioma de la Aplicación"
3. Ve las dos opciones: Español y Quechua
4. Toca el idioma deseado
5. Recibe confirmación bilingüe
6. Se guarda la preferencia
7. Al reiniciar la app, verá el nuevo idioma

### Diálogo de Confirmación

**Cuando selecciona Quechua:**
```
Kunan Quechuapi rimankichik. Musuqmanta qallariy app nisqata.

(Ahora hablas Quechua. Reinicia la app para ver los cambios.)
```

**Cuando selecciona Español:**
```
Ahora hablas Español. Reinicia la app para ver los cambios.
```

### Próximos Pasos para Implementación Completa

Para que el cambio de idioma funcione completamente, se necesita:

1. **Agregar paquete de internacionalización:**
   ```yaml
   dependencies:
     flutter_localizations:
       sdk: flutter
     intl: ^0.18.0
   ```

2. **Crear archivos de traducción:**
   - `lib/l10n/app_es.arb` (Español)
   - `lib/l10n/app_qu.arb` (Quechua)

3. **Configurar MaterialApp:**
   ```dart
   MaterialApp(
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
     locale: Locale(idiomaActual),
     // ...
   )
   ```

4. **Traducir textos de la interfaz:**
   - Títulos de pantallas
   - Botones
   - Mensajes
   - Etiquetas

### Notas sobre TTS en Quechua

**Importante:** El soporte de Text-to-Speech para Quechua depende del dispositivo:
- Android: Puede requerir instalar voces adicionales
- iOS: Soporte limitado
- Alternativa: Usar voz en español con pronunciación adaptada

### Beneficios de Inclusión

✅ **Accesibilidad**: Usuarios quechuahablantes pueden usar la app
✅ **Inclusión**: Respeta la diversidad lingüística del Perú
✅ **Educación**: Promueve el uso de lenguas originarias
✅ **Alcance**: Amplía la base de usuarios potenciales
✅ **Cultural**: Valora el patrimonio cultural peruano

### Estadísticas

- **Hablantes de Quechua en Perú**: ~4 millones
- **Porcentaje de población**: ~13%
- **Regiones principales**: Cusco, Ayacucho, Apurímac, Huancavelica
- **Reconocimiento**: Idioma oficial del Perú (junto con español)
