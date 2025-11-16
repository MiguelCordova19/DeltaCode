# Diálogo de Bienvenida con Local de Votación

## ✅ Implementación Completa

Se ha agregado un diálogo de bienvenida que se muestra al iniciar la aplicación.

### Características

**Cuándo se muestra:**
- Al abrir la app por primera vez en el día
- Solo una vez por día (se guarda en SharedPreferences)
- Después de cargar los datos del usuario

**Contenido del diálogo:**

1. **Header con gradiente rojo**
   - Ícono de votación
   - Saludo personalizado con el nombre del usuario

2. **Información del local**
   - Nombre del local de votación
   - Dirección completa
   - Número de mesa asignada

3. **Mensaje informativo**
   - Indica dónde encontrar más detalles
   - Referencia al menú "Mi Local"

4. **Botones de acción**
   - **Cerrar**: Cierra el diálogo
   - **Ver Detalles**: Navega a la pantalla de locales de votación

### Diseño

**Paleta de colores:**
- Gradiente rojo en header (#E53935 → #EF5350)
- Fondo blanco para contenido
- Acentos rojos en iconos y botones

**Elementos visuales:**
- Ícono circular con fondo blanco
- Cards con bordes y fondos de color
- Botones con estilos consistentes

### Funcionalidad

**Control de frecuencia:**
- Usa SharedPreferences para guardar la última vez que se mostró
- Clave: `ultima_bienvenida`
- Valor: Fecha en formato ISO (YYYY-MM-DD)
- Solo se muestra una vez por día

**Navegación:**
- Botón "Ver Detalles" lleva a LocalesVotacionScreen
- Permite al usuario consultar información completa
- Incluye mapa y cómo llegar

### Datos Mostrados

**Actualmente muestra datos de ejemplo:**
- Local: I.E. San Pedro
- Dirección: Av. Pardo 123, Chimbote
- Mesa: 001234

**Para personalizar:**
Estos datos deberían venir del objeto `_usuario` o de un servicio que consulte el local por DNI.

### Mejoras Futuras Posibles

- Obtener datos reales del local por DNI del usuario
- Agregar botón "No volver a mostrar"
- Incluir fecha de las elecciones
- Mostrar recordatorios según proximidad de la fecha
- Agregar información sobre si es miembro de mesa
- Incluir horario de votación
- Botón directo para abrir mapa

### Código Relevante

**Archivo modificado:**
- `lib/screens/home_screen_content.dart`

**Dependencias:**
- `shared_preferences` (ya incluida en el proyecto)

**Método principal:**
- `_mostrarDialogoBienvenida()` - Muestra el diálogo
- Se llama desde `_cargarDatos()` después de cargar el usuario

### Personalización

Para cambiar los datos mostrados, edita la sección del diálogo en `home_screen_content.dart`:

```dart
const Text(
  'I.E. San Pedro',  // ← Cambiar por dato real
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),
```

Para integrar con datos reales del usuario:
```dart
Text(
  _usuario?.localVotacion ?? 'I.E. San Pedro',
  // ...
),
```
