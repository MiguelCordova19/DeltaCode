# Cómo Agregar Candidatos

## Sistema Simplificado

El sistema ahora funciona de manera **manual y directa**. Solo necesitas:

1. **Agregar la foto del candidato** en la carpeta correcta
2. **Editar el código** para registrar al candidato

## Paso 1: Agregar la Foto

Coloca la foto en: `assets/images/candidatos/`

### Nombres de archivo según el cargo:

- **Representante Legal**: `{partido_id}_representante.png`
- **Presidente**: `{partido_id}_presidente.png`
- **Vicepresidente 1**: `{partido_id}_vice1.png`
- **Vicepresidente 2**: `{partido_id}_vice2.png`
- **Vicepresidente 3**: `{partido_id}_vice3.png`

### Ejemplo para Acción Popular:
```
accion_popular_representante.png
accion_popular_presidente.png
accion_popular_vice1.png
accion_popular_vice2.png
```

## Paso 2: Registrar el Candidato en el Código

Abre el archivo: `lib/models/candidato.dart`

Busca el método `getCandidatosPorPartido` y edita el caso del partido:

```dart
case 'accion_popular':
  return [
    Candidato(
      nombre: 'Juan Pérez García',  // ← Edita el nombre real
      cargo: 'Representante Legal',
      fotoPath: getFotoPath(partidoId, 'Representante Legal'),
      hojaVida: '• Abogado especializado en derecho electoral\n• Secretario General del Partido\n• 15 años de experiencia',  // ← Edita la hoja de vida
      biografia: 'Representante legal del partido político Acción Popular con amplia trayectoria.',  // ← Edita la biografía
      orden: 1,
    ),
    Candidato(
      nombre: 'María López Sánchez',  // ← Nuevo candidato
      cargo: 'Presidente',
      fotoPath: getFotoPath(partidoId, 'Presidente'),
      hojaVida: '• Economista con maestría en políticas públicas\n• Ex Ministra de Economía\n• Docente universitaria',
      biografia: 'Candidata a la presidencia de la república por Acción Popular.',
      orden: 1,
    ),
    // Agrega más candidatos aquí...
  ];
```

## Paso 3: Actualizar el pubspec.yaml (si es necesario)

Si agregaste nuevas imágenes, asegúrate de que estén incluidas en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/candidatos/
```

## Ventajas de este Sistema

✅ **Simple**: Solo editas un archivo para agregar/modificar candidatos
✅ **Flexible**: Puedes editar nombres, hojas de vida y biografías fácilmente
✅ **Sin errores**: No muestra candidatos que no existen
✅ **Rápido**: No necesita verificar archivos en tiempo de ejecución

## Ejemplo Completo: Agregar Todos los Candidatos de Acción Popular

```dart
case 'accion_popular':
  return [
    // Representante Legal
    Candidato(
      nombre: 'Dr. Roberto Martínez Flores',
      cargo: 'Representante Legal',
      fotoPath: getFotoPath(partidoId, 'Representante Legal'),
      hojaVida: '• Abogado especializado en derecho electoral\n• Secretario General del Partido\n• 15 años de experiencia política',
      biografia: 'Representante legal del partido político Acción Popular.',
      orden: 1,
    ),
    
    // Presidente
    Candidato(
      nombre: 'Dra. María López Sánchez',
      cargo: 'Presidente',
      fotoPath: getFotoPath(partidoId, 'Presidente'),
      hojaVida: '• Economista con maestría en políticas públicas\n• Ex Ministra de Economía\n• Docente universitaria',
      biografia: 'Candidata a la presidencia de la república.',
      orden: 1,
    ),
    
    // Primer Vicepresidente
    Candidato(
      nombre: 'Ing. Carlos Rodríguez Torres',
      cargo: 'Vicepresidente 1',
      fotoPath: getFotoPath(partidoId, 'Vicepresidente 1'),
      hojaVida: '• Ingeniero Civil con MBA\n• Ex Ministro de Transportes\n• Especialista en infraestructura',
      biografia: 'Candidato a primer vicepresidente.',
      orden: 1,
    ),
    
    // Segundo Vicepresidente
    Candidato(
      nombre: 'Dra. Ana Fernández Ruiz',
      cargo: 'Vicepresidente 2',
      fotoPath: getFotoPath(partidoId, 'Vicepresidente 2'),
      hojaVida: '• Médica especialista en salud pública\n• Ex Ministra de Salud\n• Investigadora científica',
      biografia: 'Candidata a segunda vicepresidente.',
      orden: 1,
    ),
  ];
```

## Para Agregar Otro Partido

Simplemente agrega un nuevo `case` en el switch:

```dart
case 'fuerza_popular':
  return [
    Candidato(
      nombre: 'Nombre del Candidato',
      cargo: 'Representante Legal',
      fotoPath: getFotoPath(partidoId, 'Representante Legal'),
      hojaVida: '• Información relevante',
      biografia: 'Biografía del candidato.',
      orden: 1,
    ),
  ];
```

## Notas Importantes

- **Solo agrega candidatos cuyas fotos YA EXISTEN** en la carpeta
- Si no hay candidatos, la app mostrará "No hay candidatos registrados"
- Puedes editar la hoja de vida y biografía en cualquier momento
- El campo `orden` se usa si tienes múltiples candidatos del mismo cargo
