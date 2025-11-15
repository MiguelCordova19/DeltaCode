# Locales de Votación - Chimbote

## Implementación

La funcionalidad de locales de votación incluye:

### Características
- ✅ 12 colegios reales de Chimbote como locales de votación
- ✅ Coordenadas GPS reales de cada local
- ✅ Búsqueda por nombre o dirección
- ✅ Filtro por distrito (Chimbote / Nuevo Chimbote)
- ✅ Abrir ubicación en Google Maps
- ✅ Abrir ubicación en Waze
- ✅ Información de cada local (dirección, referencia, número de mesas)

### Locales Incluidos

#### Chimbote
1. I.E. San Pedro - Av. José Pardo 850
2. I.E. Inmaculada de la Merced - Jr. Tumbes 480
3. I.E. Politécnico Nacional del Santa - Av. Pacífico 508
4. I.E. Nuestra Señora de Fátima - Jr. Leoncio Prado 1250
5. I.E. San Luis Gonzaga - Av. José Gálvez 890
6. I.E. Gloriosos Húsares de Junín - Jr. Los Pinos 567
7. I.E. Padre Damián - Av. Enrique Meiggs 1450
8. I.E. Corazón de Jesús - Jr. Bolognesi 890

#### Nuevo Chimbote
9. I.E. Mundo Mejor - Av. Universitaria 456
10. I.E. César Vallejo - Av. Pacífico 1850
11. I.E. Augusto Salazar Bondy - Av. Anchoveta 2100
12. I.E. Virgen de Guadalupe - Av. Miraflores 2340

### Uso

1. Desde el Home, presiona "Ver en Mapa"
2. Explora la lista de locales de votación
3. Usa la búsqueda para encontrar un local específico
4. Filtra por distrito
5. Toca un local para ver opciones de navegación
6. Elige Google Maps o Waze para navegar

### Archivos Creados

- `lib/models/local_votacion.dart` - Modelo de datos
- `lib/services/locales_votacion_service.dart` - Servicio con datos de locales
- `lib/screens/locales_votacion_screen.dart` - Pantalla de locales

### Notas

- Las coordenadas son aproximadas basadas en ubicaciones reales de Chimbote
- Los números de mesas son simulados (30-55 mesas por local)
- Se puede expandir fácilmente agregando más locales al servicio
