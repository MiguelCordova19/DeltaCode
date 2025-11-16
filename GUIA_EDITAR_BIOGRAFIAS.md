# 📝 Guía para Editar Biografías de Precandidatos

## 🎯 Ubicación del archivo
Las biografías se editan en: `lib/models/candidato.dart`

---

## 📋 Opción 1: Biografías Genéricas (Para todos los partidos)

Si quieres cambiar las biografías por defecto que se usan cuando NO hay una biografía personalizada:

### Busca la sección `cargosConfig` (línea ~60):

```dart
final cargosConfig = [
  {
    'cargo': 'Representante Legal',
    'titulo': 'Representante Legal',
    'hojaVida': '• Aquí va la hoja de vida\n• Puedes agregar múltiples líneas',
    'biografia': 'Aquí va la biografía completa del candidato.',
  },
  {
    'cargo': 'Presidente',
    'titulo': 'Candidato a Presidente',
    'hojaVida': '• Economista\n• Ex Ministro',
    'biografia': 'Biografía del presidente.',
  },
  // ... más cargos
];
```

### Campos que puedes editar:
- **hojaVida**: Lista de logros y experiencia (usa `\n` para saltos de línea)
- **biografia**: Descripción completa del candidato

---

## 🎨 Opción 2: Biografías Personalizadas por Partido

Para crear biografías específicas para cada partido:

### Busca el método `getBiografiasPersonalizadas()` (línea ~55):

```dart
static Map<String, Map<String, Map<String, String>>> getBiografiasPersonalizadas() {
  return {
    'accion_popular': {
      'Presidente': {
        'nombre': 'Juan Pérez García',
        'hojaVida': '• Economista con maestría en Harvard\n• Ex Ministro de Economía',
        'biografia': 'Biografía completa aquí...',
      },
      'Vicepresidente 1': {
        'nombre': 'María López',
        'hojaVida': '• Abogada\n• Ex Defensora del Pueblo',
        'biografia': 'Biografía completa...',
      },
    },
    'fuerza_popular': {
      'Presidente': {
        'nombre': 'Keiko Fujimori',
        'hojaVida': '• Administradora de empresas\n• Congresista (2006-2011)',
        'biografia': 'Lideresa política con amplia experiencia...',
      },
    },
  };
}
```

---

## 📝 Cómo agregar un nuevo partido

### Paso 1: Copia esta plantilla

```dart
'nombre_del_partido': {
  'Presidente': {
    'nombre': 'Nombre Completo del Candidato',
    'hojaVida': '• Profesión y estudios\n• Experiencia laboral\n• Cargos públicos\n• Logros destacados',
    'biografia': 'Biografía completa del candidato. Incluye su trayectoria política, propuestas principales y visión para el país.',
  },
  'Vicepresidente 1': {
    'nombre': 'Nombre del Primer Vice',
    'hojaVida': '• Profesión\n• Experiencia',
    'biografia': 'Biografía del primer vicepresidente.',
  },
  'Vicepresidente 2': {
    'nombre': 'Nombre del Segundo Vice',
    'hojaVida': '• Profesión\n• Experiencia',
    'biografia': 'Biografía del segundo vicepresidente.',
  },
  'Representante Legal': {
    'nombre': 'Nombre del Representante',
    'hojaVida': '• Abogado\n• Experiencia',
    'biografia': 'Biografía del representante legal.',
  },
},
```

### Paso 2: Reemplaza los valores

- **nombre_del_partido**: Usa el ID del partido (ej: `accion_popular`, `fuerza_popular`)
- **nombre**: Nombre completo del candidato
- **hojaVida**: Lista de logros (usa `\n` para nueva línea)
- **biografia**: Texto completo de la biografía

---

## 🔍 IDs de Partidos Disponibles

Para saber qué ID usar, revisa el archivo `lib/models/partido_politico.dart`:

Ejemplos comunes:
- `accion_popular`
- `fuerza_popular`
- `alianza_para_el_progreso`
- `partido_morado`
- `renovacion_popular`
- `avanza_pais`
- `juntos_por_el_peru`
- `podemos_peru`
- `somos_peru`

---

## ✅ Ejemplo Completo: Acción Popular

```dart
'accion_popular': {
  'Presidente': {
    'nombre': 'Raúl Diez Canseco Terry',
    'hojaVida': '• Economista, Universidad del Pacífico\n• MBA en Harvard Business School\n• Ex Ministro de Economía y Finanzas (2018-2020)\n• Docente universitario por 20 años\n• Autor de 5 libros sobre economía peruana\n• Consultor del Banco Mundial',
    'biografia': 'Reconocido economista con amplia trayectoria académica y en gestión pública. Durante su gestión como Ministro de Economía implementó políticas de estabilización económica que redujeron la inflación al 2%. Propone un modelo de desarrollo inclusivo con énfasis en educación, tecnología e innovación. Su plan de gobierno se centra en la reactivación económica post-pandemia y la reducción de la pobreza mediante programas sociales focalizados.',
  },
  'Vicepresidente 1': {
    'nombre': 'Patricia Juárez Gallegos',
    'hojaVida': '• Abogada, Pontificia Universidad Católica del Perú\n• Maestría en Derechos Humanos, Universidad de Salamanca\n• Ex Defensora del Pueblo (2016-2021)\n• Activista social por 15 años\n• Fundadora de ONG "Justicia para Todos"',
    'biografia': 'Destacada abogada especializada en derechos humanos y justicia social. Como Defensora del Pueblo lideró importantes reformas en el sistema de justicia y la protección de poblaciones vulnerables. Ha trabajado en casos emblemáticos de defensa de derechos de comunidades indígenas y mujeres víctimas de violencia. Propone fortalecer el sistema judicial y garantizar el acceso a la justicia para todos los peruanos.',
  },
  'Vicepresidente 2': {
    'nombre': 'Carlos Neuhaus Tudela',
    'hojaVida': '• Ingeniero Civil, Universidad Nacional de Ingeniería\n• MBA, ESAN\n• Ex Ministro de Transportes y Comunicaciones\n• Gerente de proyectos de infraestructura\n• Experiencia en construcción de carreteras y puentes',
    'biografia': 'Ingeniero con amplia experiencia en gestión de infraestructura y desarrollo de proyectos de gran envergadura. Durante su gestión ministerial supervisó la construcción de más de 2,000 km de carreteras. Propone un plan ambicioso de infraestructura para conectar el país y mejorar la competitividad.',
  },
},
```

---

## 💡 Consejos para escribir buenas biografías

### Hoja de Vida (hojaVida):
- ✅ Usa viñetas con `•`
- ✅ Separa líneas con `\n`
- ✅ Incluye: profesión, estudios, experiencia, cargos, logros
- ✅ Sé conciso (4-6 puntos máximo)

### Biografía (biografia):
- ✅ Escribe en tercera persona
- ✅ Incluye trayectoria profesional y política
- ✅ Menciona logros concretos
- ✅ Agrega propuestas principales
- ✅ Longitud: 2-4 párrafos (150-300 palabras)

---

## 🔄 Después de editar

1. Guarda el archivo `candidato.dart`
2. Reinicia la aplicación
3. Ve a la sección "Precandidatos"
4. Selecciona el partido que editaste
5. Verifica que las biografías se muestren correctamente

---

## ⚠️ Notas Importantes

- Si NO defines una biografía personalizada para un partido, se usará la biografía genérica
- Los IDs de partido deben coincidir exactamente (case-sensitive)
- Usa comillas simples `'` para los textos
- No olvides las comas `,` al final de cada bloque
- Usa `\n` para saltos de línea dentro del texto

---

## 🆘 Solución de Problemas

### ❌ Error: "No hay precandidatos registrados"
- Verifica que el ID del partido sea correcto
- Asegúrate de que las fotos existan en `assets/images/candidatos/`

### ❌ Error de sintaxis
- Revisa que todas las comillas estén cerradas
- Verifica que todas las comas estén en su lugar
- Usa un editor con resaltado de sintaxis

### ❌ No se muestran los cambios
- Reinicia completamente la aplicación
- Haz "Hot Restart" (no solo "Hot Reload")
- Verifica que guardaste el archivo

---

## 📞 Estructura de Archivos

```
lib/
├── models/
│   ├── candidato.dart          ← EDITA AQUÍ LAS BIOGRAFÍAS
│   └── partido_politico.dart   ← Consulta IDs de partidos
└── screens/
    └── candidatos_screen.dart  ← Pantalla que muestra los candidatos
```
