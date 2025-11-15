# 📋 Cómo se Muestran Múltiples Candidatos

## Vista Frontend - Agrupados por Cargo

Cuando un partido tiene múltiples candidatos del mismo cargo, se muestran así:

```
┌─────────────────────────────────────────┐
│  [Logo] ACCIÓN POPULAR                  │
│         5 Candidatos 2026               │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ▌ Representante Legal                   │
│                                          │
│  ┌──────────────────────────────┐      │
│  │  [Foto]                      │      │
│  │  Roberto Martínez Flores     │      │
│  │  Ver hoja de vida →          │      │
│  └──────────────────────────────┘      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ▌ Presidente                            │
│                                          │
│  ┌──────────────────────────────┐      │
│  │  [Foto]                      │      │
│  │  Juan Pérez García           │      │
│  │  Ver hoja de vida →          │      │
│  └──────────────────────────────┘      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ▌ Vicepresidente 1              (2)     │
│                                          │
│  ┌─────────┐  ┌─────────┐              │
│  │ [Foto]  │  │ [Foto]  │              │
│  │ María   │  │ Ana     │              │
│  │ López   │  │ García  │              │
│  └─────────┘  └─────────┘              │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ▌ Vicepresidente 2              (3)     │
│                                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐ │
│  │ [Foto]  │  │ [Foto]  │  │ [Foto]  │ │
│  │ Carlos  │  │ Pedro   │  │ Luis    │ │
│  │ Rodrígz │  │ Sánchez │  │ Torres  │ │
│  └─────────┘  └─────────┘  └─────────┘ │
└─────────────────────────────────────────┘
```

## Características

### 1. **Un solo candidato por cargo**
- Se muestra en tarjeta completa (ancho completo)
- Foto grande
- Información detallada

### 2. **Múltiples candidatos del mismo cargo**
- Se muestran en grid 2 columnas
- Tarjetas más compactas
- Badge con el número total de candidatos
- Todas las fotos visibles al mismo tiempo

### 3. **Organización**
- Agrupados por cargo
- Barra roja vertical como indicador
- Título del cargo en negrita
- Orden: Representante Legal → Presidente → Vicepresidentes

## Estructura de Archivos de Fotos

```
assets/images/candidatos/
├── accion_popular_representante.png
├── accion_popular_presidente.png
├── accion_popular_vice1_1.png    ← Primer Vice 1
├── accion_popular_vice1_2.png    ← Segundo Vice 1
├── accion_popular_vice2_1.png    ← Primer Vice 2
├── accion_popular_vice2_2.png    ← Segundo Vice 2
└── accion_popular_vice2_3.png    ← Tercer Vice 2
```

## Código para Agregar Múltiples Candidatos

```dart
static List<Candidato> getCandidatosPorPartido(String partidoId) {
  return [
    // Representante Legal (1)
    Candidato(
      nombre: 'Roberto Martínez',
      cargo: 'Representante Legal',
      fotoPath: Candidato.getFotoPath(partidoId, 'Representante Legal'),
      hojaVida: '...',
      biografia: '...',
      orden: 1,
    ),
    
    // Presidente (1)
    Candidato(
      nombre: 'Juan Pérez',
      cargo: 'Presidente',
      fotoPath: Candidato.getFotoPath(partidoId, 'Presidente'),
      hojaVida: '...',
      biografia: '...',
      orden: 1,
    ),
    
    // Vicepresidente 1 - Candidato 1
    Candidato(
      nombre: 'María López',
      cargo: 'Vicepresidente 1',
      fotoPath: Candidato.getFotoPath(partidoId, 'Vicepresidente 1', numero: 1),
      hojaVida: '...',
      biografia: '...',
      orden: 1,
    ),
    
    // Vicepresidente 1 - Candidato 2
    Candidato(
      nombre: 'Ana García',
      cargo: 'Vicepresidente 1',
      fotoPath: Candidato.getFotoPath(partidoId, 'Vicepresidente 1', numero: 2),
      hojaVida: '...',
      biografia: '...',
      orden: 2,
    ),
    
    // Vicepresidente 2 - Candidato 1
    Candidato(
      nombre: 'Carlos Rodríguez',
      cargo: 'Vicepresidente 2',
      fotoPath: Candidato.getFotoPath(partidoId, 'Vicepresidente 2', numero: 1),
      hojaVida: '...',
      biografia: '...',
      orden: 1,
    ),
    
    // Vicepresidente 2 - Candidato 2
    Candidato(
      nombre: 'Pedro Sánchez',
      cargo: 'Vicepresidente 2',
      fotoPath: Candidato.getFotoPath(partidoId, 'Vicepresidente 2', numero: 2),
      hojaVida: '...',
      biografia: '...',
      orden: 2,
    ),
    
    // Vicepresidente 2 - Candidato 3
    Candidato(
      nombre: 'Luis Torres',
      cargo: 'Vicepresidente 2',
      fotoPath: Candidato.getFotoPath(partidoId, 'Vicepresidente 2', numero: 3),
      hojaVida: '...',
      biografia: '...',
      orden: 3,
    ),
  ];
}
```

## Ventajas del Sistema

✅ **Flexible** - Soporta cualquier cantidad de candidatos por cargo
✅ **Organizado** - Agrupación clara por cargo
✅ **Visual** - Grid compacto para múltiples candidatos
✅ **Escalable** - Fácil agregar más candidatos
✅ **Intuitivo** - Badge muestra cuántos candidatos hay por cargo

## Uso en el Código

```dart
// Obtener candidatos
final candidatos = Candidato.getCandidatosPorPartido('accion_popular');

// Agrupar por cargo
final grupos = Candidato.agruparPorCargo(candidatos);

// Mostrar
grupos.forEach((cargo, listaCandidatos) {
  print('$cargo: ${listaCandidatos.length} candidatos');
});

// Resultado:
// Representante Legal: 1 candidatos
// Presidente: 1 candidatos
// Vicepresidente 1: 2 candidatos
// Vicepresidente 2: 3 candidatos
```
