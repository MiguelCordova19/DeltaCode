# Instrucciones para Resetear Logros (Solo para Testing)

Si ya obtuviste el logro y quieres probarlo de nuevo, puedes resetear los datos de dos formas:

## Opción 1: Desde el código (temporal)

Agrega este código temporalmente en alguna pantalla (por ejemplo, en el botón de configuración):

```dart
// Importar el servicio
import '../services/gamificacion_service.dart';

// En algún botón o acción:
final gamificacionService = GamificacionService();
await gamificacionService.resetearDatos();
```

## Opción 2: Desinstalar y reinstalar la app

La forma más simple es desinstalar completamente la app y volverla a instalar. Esto borrará todos los datos de SharedPreferences.

## Opción 3: Limpiar datos de la app (Android)

1. Ve a Configuración del dispositivo
2. Aplicaciones
3. Busca tu app
4. Almacenamiento
5. Borrar datos

## Para verificar si el logro ya existe:

Revisa los logs en la consola cuando presiones el botón de retroceso:
- Si dice "DEBUG: Logro ya obtenido, no se muestra" → Ya lo tienes
- Si dice "DEBUG: Intentando otorgar logro..." → Se está intentando otorgar
- Si dice "DEBUG: Logro otorgado, mostrando diálogo..." → Se otorgó correctamente
