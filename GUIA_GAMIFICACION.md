# 🎮 Sistema de Gamificación - Guía Completa

## ✅ ¿Qué se ha implementado?

Un sistema completo de gamificación con:
- 🪙 **Monedas virtuales** - Los usuarios ganan puntos por acciones
- 🏆 **Logros** - Se desbloquean al completar tareas
- 🎁 **Cupones canjeables** - Recompensas reales por puntos
- 🎉 **Diálogos de felicitación** - Feedback visual atractivo
- 📊 **Historial** - Seguimiento de todas las transacciones

## 📁 Archivos Creados

### Modelos
- `lib/models/puntos_usuario.dart` - Modelo de datos

### Servicios
- `lib/services/gamificacion_service.dart` - Lógica de negocio

### Widgets
- `lib/widgets/monedas_widget.dart` - Muestra balance en perfil
- `lib/widgets/dialogo_felicitacion.dart` - Animación de felicitación

### Pantallas
- `lib/screens/recompensas_screen.dart` - Pantalla principal de recompensas

## 🎯 Puntos por Acción

```dart
PUNTOS_LEER_PLAN = 100           // Leer un plan de gobierno completo
PUNTOS_COMPLETAR_TUTORIAL = 50   // Completar un tutorial
PUNTOS_VER_CANDIDATO = 25        // Ver perfil de candidato
PUNTOS_LEER_NOTICIA = 15         // Leer una noticia
PUNTOS_CHECK_IN_DIARIO = 10      // Check-in diario
PUNTOS_COMPARTIR = 20            // Compartir contenido
PUNTOS_PRIMER_LOGIN = 50         // Primera vez que inicia sesión
```

## 🚀 Cómo Usar

### 1. Otorgar Puntos

```dart
import '../services/gamificacion_service.dart';
import '../widgets/dialogo_felicitacion.dart';

final _gamificacionService = GamificacionService();

// Otorgar puntos simples
await _gamificacionService.agregarPuntos(
  puntos: 100,
  descripcion: 'Plan de gobierno leído',
);

// Otorgar puntos con logro
await _gamificacionService.agregarPuntos(
  puntos: 100,
  descripcion: 'Plan de gobierno leído: Partido X',
  logroId: 'plan_partido_x',
  logroTitulo: '¡Primer Plan Leído!',
  logroDescripcion: 'Has leído tu primer plan de gobierno',
  logroIcono: '📖',
);

// Mostrar felicitación
await DialogoFelicitacion.mostrar(
  context,
  titulo: '¡Excelente!',
  mensaje: 'Has leído el plan de gobierno completo',
  puntosGanados: 100,
  icono: '📖',
);
```

### 2. Verificar Balance

```dart
final puntos = await _gamificacionService.obtenerPuntos();
print('Balance: ${puntos.balance}');
```

### 3. Canjear Cupón

```dart
await _gamificacionService.canjearPuntos(
  puntos: 500,
  descripcion: 'Canjeado: Descuento 10% en Librería',
);
```

## 🎨 Ejemplos de Implementación

### Ejemplo 1: Leer Plan de Gobierno

```dart
// En plan_gobierno_detalle_screen.dart

Future<void> _marcarComoLeido() async {
  await _gamificacionService.agregarPuntos(
    puntos: GamificacionService.PUNTOS_LEER_PLAN,
    descripcion: 'Plan leído: ${widget.partido.nombre}',
    logroId: 'plan_${widget.partido.id}',
    logroTitulo: '¡Plan Completado!',
    logroDescripcion: widget.partido.nombre,
    logroIcono: '📖',
  );

  if (mounted) {
    await DialogoFelicitacion.mostrar(
      context,
      titulo: '¡Bien hecho!',
      mensaje: 'Has leído el plan de gobierno completo',
      puntosGanados: GamificacionService.PUNTOS_LEER_PLAN,
      icono: '📖',
    );
  }
}
```

### Ejemplo 2: Ver Candidato

```dart
// En candidato_detalle_screen.dart

@override
void initState() {
  super.initState();
  _otorgarPuntosPorVer();
}

Future<void> _otorgarPuntosPorVer() async {
  await _gamificacionService.agregarPuntos(
    puntos: GamificacionService.PUNTOS_VER_CANDIDATO,
    descripcion: 'Candidato visto: ${widget.candidato.nombre}',
  );
}
```

### Ejemplo 3: Check-in Diario

```dart
// En home_screen.dart

@override
void initState() {
  super.initState();
  _verificarCheckInDiario();
}

Future<void> _verificarCheckInDiario() async {
  final yaHizoCheckIn = await _gamificacionService.verificarCheckInDiario();
  
  if (!yaHizoCheckIn) {
    await _gamificacionService.registrarCheckInDiario();
    await _gamificacionService.agregarPuntos(
      puntos: GamificacionService.PUNTOS_CHECK_IN_DIARIO,
      descripcion: 'Check-in diario',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡+10 puntos por tu visita diaria!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
```

### Ejemplo 4: Leer Noticia

```dart
// En noticia_detalle_screen.dart

Future<void> _marcarNoticiaLeida() async {
  await _gamificacionService.agregarPuntos(
    puntos: GamificacionService.PUNTOS_LEER_NOTICIA,
    descripcion: 'Noticia leída: ${widget.noticia.titulo}',
  );
}
```

## 🎁 Cupones Disponibles

Los cupones se pueden personalizar en `gamificacion_service.dart`:

```dart
List<Cupon> obtenerCuponesDisponibles() {
  return [
    Cupon(
      id: 'cupon_1',
      titulo: 'Descuento 10% en Librería',
      descripcion: 'Válido en librerías participantes',
      puntosRequeridos: 500,
      imagen: '📚',
      categoria: 'Educación',
    ),
    // ... más cupones
  ];
}
```

## 📱 Pantallas del Sistema

### 1. Widget de Monedas (Perfil)
- Muestra el balance actual
- Al tocar, navega a la pantalla de recompensas
- Diseño con gradiente rojo y moneda dorada

### 2. Pantalla de Recompensas
**3 Tabs:**
- **Cupones**: Lista de recompensas canjeables
- **Logros**: Historial de logros desbloqueados
- **Historial**: Todas las transacciones

### 3. Diálogo de Felicitación
- Animación de confetti
- Trofeo/icono personalizable
- Muestra puntos ganados
- Diseño atractivo con colores de la app

## 🎨 Colores Utilizados

```dart
Color(0xFFE53935)  // Rojo principal
Color(0xFFD32F2F)  // Rojo oscuro
Colors.amber       // Dorado para monedas
Colors.white       // Fondo
```

## 📊 Flujo de Usuario

1. **Usuario completa una acción** (lee plan, tutorial, etc.)
2. **Sistema otorga puntos** automáticamente
3. **Muestra diálogo de felicitación** con animación
4. **Puntos se suman al balance**
5. **Usuario puede ver balance** en el perfil
6. **Usuario puede canjear** cupones cuando tenga suficientes puntos

## 🔧 Personalización

### Agregar Nuevos Cupones

Edita `lib/services/gamificacion_service.dart`:

```dart
Cupon(
  id: 'nuevo_cupon',
  titulo: 'Tu Cupón',
  descripcion: 'Descripción del cupón',
  puntosRequeridos: 300,
  imagen: '🎁',
  categoria: 'Categoría',
),
```

### Cambiar Puntos por Acción

Edita las constantes en `gamificacion_service.dart`:

```dart
static const int PUNTOS_LEER_PLAN = 150; // Cambiar de 100 a 150
```

### Personalizar Iconos de Logros

Al otorgar puntos, especifica el icono:

```dart
logroIcono: '🏆',  // Trofeo
logroIcono: '📚',  // Libro
logroIcono: '⭐',  // Estrella
logroIcono: '🎯',  // Diana
logroIcono: '💎',  // Diamante
```

## ✅ Checklist de Implementación

### Ya Implementado:
- [x] Modelo de datos
- [x] Servicio de gamificación
- [x] Widget de monedas en perfil
- [x] Diálogo de felicitación
- [x] Pantalla de recompensas
- [x] Ejemplo en tutoriales

### Por Implementar:
- [ ] Puntos por leer planes de gobierno
- [ ] Puntos por ver candidatos
- [ ] Puntos por leer noticias
- [ ] Check-in diario
- [ ] Puntos por compartir
- [ ] Puntos por primer login

## 🎉 Resultado Final

Los usuarios ahora tienen incentivos para:
- ✅ Leer más planes de gobierno
- ✅ Completar tutoriales
- ✅ Informarse sobre candidatos
- ✅ Usar la app diariamente
- ✅ Compartir contenido
- ✅ Canjear recompensas reales

**¡El sistema está listo para aumentar el engagement de los usuarios!** 🚀
