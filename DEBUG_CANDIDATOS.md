# Debug: Candidatos no cargan

## Cambios Realizados

1. **Eliminé FutureBuilder**: Ahora las imágenes se cargan directamente sin verificación previa
2. **Simplificé el código**: El sistema ya no verifica si las imágenes existen antes de mostrarlas
3. **Agregué debug prints**: Ahora imprime en consola información sobre los candidatos

## Para Verificar

### 1. Ejecuta la app y ve a Candidatos > Acción Popular

Deberías ver en la consola algo como:
```
=== DEBUG CANDIDATOS ===
Partido ID: accion_popular
Número de candidatos: 1
- Representante Legal - Acción Popular (Representante Legal): assets/images/candidatos/accion_popular_representante.png
========================
```

### 2. Verifica que la imagen existe

Ejecuta en terminal:
```cmd
dir assets\images\candidatos\accion_popular_representante.png
```

Debe mostrar el archivo.

### 3. Si ves el mensaje "No hay candidatos registrados"

Significa que `getCandidatosPorPartido` está retornando una lista vacía. Verifica:
- Que el `partidoId` sea exactamente `'accion_popular'` (con guión bajo, no espacio)
- Que el switch case en `candidato.dart` tenga el caso correcto

### 4. Si ves el candidato pero sin foto

Significa que la imagen no se está cargando. Verifica:
- Que hayas ejecutado `flutter clean` y `flutter pub get`
- Que el path sea correcto: `assets/images/candidatos/accion_popular_representante.png`

## Solución Rápida: Hot Restart

A veces Flutter no recarga los assets correctamente. Prueba:

1. **Stop** la app completamente
2. Ejecuta:
   ```cmd
   flutter clean
   flutter pub get
   ```
3. **Reinicia** la app (no hot reload, sino restart completo)

## Si Aún No Funciona

Prueba este código de prueba simple. Reemplaza temporalmente el contenido de `_buildCandidatosList`:

```dart
Widget _buildCandidatosList() {
  return Scaffold(
    appBar: AppBar(
      title: Text('Test Candidatos'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => setState(() => _selectedPartido = null),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Partido: ${_selectedPartido!.nombre}'),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/images/candidatos/accion_popular_representante.png',
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  children: [
                    Icon(Icons.error, size: 50, color: Colors.red),
                    Text('Error cargando imagen'),
                    Text(error.toString(), style: TextStyle(fontSize: 10)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
```

Esto te dirá exactamente si el problema es:
- La carga de la imagen
- La lógica de candidatos
- Otro problema

## Información del Sistema

- **Path de imagen**: `assets/images/candidatos/accion_popular_representante.png`
- **Partido ID**: `accion_popular`
- **Registrado en pubspec.yaml**: ✅ Sí
- **Archivo existe**: ✅ Sí (verificado)
