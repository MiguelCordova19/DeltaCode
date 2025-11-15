# TTS Implementado en Planes de Gobierno

## ✅ Funcionalidades Agregadas

### 1. **Lectura de Categorías Completas**
- Botón flotante: "Leer [Categoría]" (ej: "Leer Economía")
- Lee todas las propuestas de la categoría seleccionada
- Incluye nombre del partido y categoría en la introducción

### 2. **Lectura de Propuestas Individuales**
- Botón 🔊 junto a cada propuesta
- Lee solo esa propuesta específica
- Incluye contexto del partido

### 3. **Controles en AppBar**
- ⚙️ **Configurar voz**: Abre configuración (solo en vista de detalle)
- ⏸️ **Pausar**: Pausa la lectura
- ▶️ **Reanudar**: Continúa desde donde se pausó
- ⏹️ **Detener**: Detiene completamente

### 4. **Barra de Progreso**
- Muestra porcentaje de lectura
- Botones ⏪ Retroceder y ⏩ Avanzar
- Cambia de color: Morado (leyendo) / Naranja (pausado)
- Barra de progreso visual animada

### 5. **Botones Flotantes**
- **No leyendo**: "Leer [Categoría]" (morado)
- **Leyendo**: Botones de Pausa ⏸️ y Detener ⏹️
- **Pausado**: Botón verde ▶️ para reanudar

## 🎯 Flujos de Uso

### Flujo 1: Leer Categoría Completa

1. Usuario selecciona un partido
2. Usuario selecciona una categoría (ej: "Economía")
3. Usuario toca "Leer Economía"
4. Se lee: "Plan de Gobierno de [Partido]. Categoría: Economía. [Propuestas]"
5. Usuario puede pausar, avanzar, retroceder o detener

### Flujo 2: Leer Propuesta Individual

1. Usuario selecciona un partido
2. Usuario ve lista de propuestas
3. Usuario toca 🔊 junto a una propuesta
4. Se lee: "Propuesta de [Partido]. [Texto de la propuesta]"
5. Usuario puede controlar la lectura

### Flujo 3: Cambiar de Categoría

1. Usuario está leyendo "Economía"
2. Usuario cambia a "Educación"
3. Usuario toca "Leer Educación"
4. Se detiene la lectura anterior
5. Inicia lectura de nueva categoría

## 🎨 Elementos Visuales

### Vista de Lista de Partidos
```
┌─────────────────────────────────────┐
│  Planes de Gobierno                 │
│  Selecciona un partido para ver...  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [Logo] Acción Popular    →  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ [Logo] Fuerza Popular    →  │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Vista de Detalle (Leyendo)
```
┌─────────────────────────────────────┐
│ ← ⚙️ ⏸️ ⏹️                          │
│ Elecciones 2026                     │
├─────────────────────────────────────┤
│ [Logo] Acción Popular               │
│ Plan de Gobierno 2026               │
├─────────────────────────────────────┤
│ ⏪  🔊 Leyendo... 45%  ⏩           │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
├─────────────────────────────────────┤
│ [Visión País] [Economía] [Educación]│
├─────────────────────────────────────┤
│ 1. Reducción impuestos... 🔊 →     │
│ 2. Fomento inversión...   🔊 →     │
│ 3. Estabilizar precios... 🔊 →     │
└─────────────────────────────────────┘
                    ┌────┐  ┌────┐
                    │ ⏸️ │  │ ⏹️ │
                    └────┘  └────┘
```

### Vista de Detalle (No Leyendo)
```
┌─────────────────────────────────────┐
│ ← ⚙️                                │
│ Elecciones 2026                     │
├─────────────────────────────────────┤
│ [Logo] Acción Popular               │
│ Plan de Gobierno 2026               │
├─────────────────────────────────────┤
│ [Visión País] [Economía] [Educación]│
├─────────────────────────────────────┤
│ 1. Reducción impuestos... 🔊 →     │
│ 2. Fomento inversión...   🔊 →     │
│ 3. Estabilizar precios... 🔊 →     │
└─────────────────────────────────────┘
              ┌──────────────────┐
              │ 🔊 Leer Economía │
              └──────────────────┘
```

## 📝 Contenido de Lectura

### Lectura de Categoría Completa
```
"Plan de Gobierno de Acción Popular. 
Categoría: Economía. 
Reducción a impuestos a mypes. 
Fomento de inversión empresarial. 
Estabilizar de precios canasta básica. 
Creación de fondo de innovación tech. 
Apoyo a emprendimientos digitales."
```

### Lectura de Propuesta Individual
```
"Propuesta de Acción Popular. 
Reducción a impuestos a mypes."
```

## 🔧 Características Técnicas

### Pausa/Reanudación
- División en grupos de 5 palabras
- Pausa casi exacta (±5 palabras)
- Reanuda desde el grupo donde se pausó

### Progreso
- Actualización en tiempo real
- Porcentaje visible en barra de estado
- Barra de progreso visual

### Navegación
- Saltar 10 palabras atrás (⏪)
- Saltar 10 palabras adelante (⏩)
- Funciona durante lectura o pausa

### Transiciones
- Animaciones suaves (400ms)
- ScaleTransition + FadeTransition
- AnimatedContainer para barra de estado

## 🎯 Casos de Uso

### Caso 1: Comparar Propuestas
```
Usuario quiere comparar propuestas económicas:
1. Selecciona "Acción Popular"
2. Va a categoría "Economía"
3. Toca 🔊 en propuesta 1
4. Escucha
5. Toca 🔊 en propuesta 2
6. Compara mentalmente
```

### Caso 2: Estudiar Plan Completo
```
Usuario quiere conocer todo el plan:
1. Selecciona partido
2. Toca "Leer Visión País"
3. Escucha toda la categoría
4. Cambia a "Economía"
5. Toca "Leer Economía"
6. Continúa con todas las categorías
```

### Caso 3: Lectura Interrumpida
```
Usuario está leyendo pero necesita pausar:
1. Está leyendo "Economía"
2. Toca ⏸️ para pausar
3. Hace otra cosa
4. Regresa y toca ▶️
5. Continúa desde donde se quedó
```

## 🚀 Mejoras Futuras

### Corto Plazo:
1. **Datos reales**: Conectar con base de datos de propuestas
2. **Favoritos**: Marcar propuestas favoritas
3. **Compartir**: Compartir propuesta por WhatsApp/Email

### Mediano Plazo:
1. **Comparador**: Comparar propuestas de 2 partidos lado a lado
2. **Búsqueda**: Buscar palabras clave en propuestas
3. **Filtros**: Filtrar por tema o palabra clave

### Largo Plazo:
1. **IA**: Resumen automático de propuestas
2. **Análisis**: Análisis de viabilidad de propuestas
3. **Histórico**: Comparar con propuestas anteriores

## 📊 Estadísticas de Uso (Futuro)

Podrías agregar analytics para saber:
- Categorías más escuchadas
- Partidos más consultados
- Tiempo promedio de lectura
- Propuestas más populares

## 💡 Tips para Usuarios

1. **Usa los botones de saltar** para navegar rápido
2. **Pausa cuando necesites** - se guarda tu posición
3. **Configura la voz** según tu preferencia
4. **Lee propuestas individuales** para comparar mejor
5. **Usa la barra de progreso** para saber cuánto falta

## ✨ Resultado Final

Ahora la pantalla de Planes de Gobierno tiene:
- ✅ Lectura completa de categorías
- ✅ Lectura individual de propuestas
- ✅ Pausa/reanudación precisa
- ✅ Barra de progreso visual
- ✅ Botones de navegación
- ✅ Configuración de voz
- ✅ Transiciones suaves
- ✅ Experiencia de usuario mejorada

¡Los usuarios ahora pueden escuchar los planes de gobierno mientras hacen otras cosas! 🎉
