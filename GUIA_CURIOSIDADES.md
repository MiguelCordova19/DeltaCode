# 📜 Línea de Tiempo - Curiosidades

## ✅ ¿Qué se ha implementado?

Una línea de tiempo profesional con:
- 🎨 **Animaciones suaves** - Entrada con efecto de rebote
- 🌈 **Colores dinámicos** - Cada presidente tiene su color
- 📐 **Efecto 3D** - Rotación en perspectiva de las cards
- ⚡ **Transiciones fluidas** - Fade in y slide
- 🎯 **Diseño alternado** - Cards a izquierda y derecha
- 🏆 **Destacado actual** - Borde especial para el presidente actual

## 📁 Archivos Creados

- `lib/models/presidente.dart` - Modelo de datos
- `lib/screens/curiosidades_screen.dart` - Pantalla de línea de tiempo

## 🎨 Características Visuales

### Animaciones:
1. **Entrada de cards**: Slide desde los lados con fade in
2. **Círculos de año**: Escala con rotación elástica
3. **Cards**: Rotación 3D en perspectiva
4. **Sombras**: Múltiples capas para profundidad

### Colores:
- Rojo (#E53935) - Principal
- Naranja, Verde, Cyan, Azul, Púrpura, Rosa - Variaciones por año
- Gradientes en línea vertical
- Sombras con color del presidente

### Efectos 3D:
- Transformación Matrix4 con perspectiva
- Rotación en eje Y
- Sombras múltiples para profundidad
- Elevación visual

## 🚀 Cómo Agregar al Home

### Opción 1: Agregar en HomeScreenContent

```dart
// En lib/screens/home_screen_content.dart

import '../screens/curiosidades_screen.dart';

// Agregar una nueva card en la sección de descubrimiento:
_buildDiscoveryCard(
  context: context,
  icon: Icons.timeline,
  title: 'Curiosidades',
  subtitle: 'Historia presidencial',
  color: const Color(0xFFE53935),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CuriosidadesScreen(),
      ),
    );
  },
),
```

### Opción 2: Agregar en el Menú de Perfil

```dart
// En lib/screens/perfil_screen.dart

_buildProfileOption(
  icon: Icons.timeline,
  title: 'Curiosidades',
  subtitle: 'Línea de tiempo presidencial',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CuriosidadesScreen(),
      ),
    );
  },
),
```

### Opción 3: Agregar como Tab en Tutoriales

```dart
// Crear una nueva sección en tutoriales_screen.dart
```

## 📊 Datos Incluidos

### Presidentes (2000-2025):
1. Valentín Paniagua (2000-2001)
2. Alejandro Toledo (2001-2006)
3. Alan García Pérez (2006-2011)
4. Ollanta Humala (2011-2016)
5. Pedro Pablo Kuczynski (2016-2018)
6. Martín Vizcarra (2018-2020)
7. Manuel Merino (2020) - 5 días
8. Francisco Sagasti (2020-2021)
9. Pedro Castillo (2021-2022)
10. Dina Boluarte (2022-2025)
11. José Enrique Jeri Oré (2025-) - ACTUAL

## 🎯 Personalización

### Agregar más presidentes:

```dart
Presidente(
  nombre: 'Nombre del Presidente',
  partido: 'Partido Político',
  periodo: '2026-2031',
  anioInicio: 2026,
  anioFin: 2031,
  duracion: '5 años',
  esActual: false,
),
```

### Cambiar colores:

Edita el método `_getColorForYear` en `curiosidades_screen.dart`:

```dart
final colors = [
  const Color(0xFFE53935), // Tu color personalizado
  // ... más colores
];
```

### Agregar imágenes:

1. Agrega `imagenUrl` al modelo
2. Reemplaza el ícono de persona con:

```dart
CircleAvatar(
  backgroundImage: NetworkImage(presidente.imagenUrl!),
  radius: 25,
)
```

## 🎬 Animaciones Implementadas

### 1. Entrada de Cards
```dart
TweenAnimationBuilder<double>(
  duration: Duration(milliseconds: 600 + (index * 100)),
  tween: Tween(begin: 0.0, end: 1.0),
  curve: Curves.easeOutBack,
  // Slide + Fade
)
```

### 2. Círculos de Año
```dart
Transform.scale + Transform.rotate
// Escala elástica con rotación
```

### 3. Efecto 3D en Cards
```dart
Matrix4.identity()
  ..setEntry(3, 2, 0.001) // Perspectiva
  ..rotateY(angle) // Rotación en Y
```

## 📱 Responsive

- Ancho de cards: 40% del ancho de pantalla
- Línea central: Siempre en el centro
- Adaptable a diferentes tamaños de pantalla

## 🎨 Diseño

- **Header**: Gradiente rojo con título y subtítulo
- **Timeline**: Línea vertical con gradiente
- **Cards**: Blancas con sombras múltiples
- **Círculos**: Color dinámico con sombra brillante
- **Actual**: Borde destacado y badge rojo

## ✨ Resultado Final

Una línea de tiempo profesional, animada y con efecto 3D que muestra la historia presidencial del Perú de forma atractiva y educativa.

**¡Los usuarios quedarán impresionados!** 🚀
