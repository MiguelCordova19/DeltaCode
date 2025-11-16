import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/puntos_usuario.dart';

class GamificacionService {
  static const String _keyPuntos = 'puntos_usuario';
  
  // Puntos por acción
  static const int PUNTOS_LEER_PLAN = 100;
  static const int PUNTOS_COMPLETAR_TUTORIAL = 50;
  static const int PUNTOS_VER_CANDIDATO = 25;
  static const int PUNTOS_LEER_NOTICIA = 15;
  static const int PUNTOS_CHECK_IN_DIARIO = 10;
  static const int PUNTOS_COMPARTIR = 20;
  static const int PUNTOS_PRIMER_LOGIN = 50;
  static const int PUNTOS_REFERIDO_REGISTRO = 100; // Puntos por registrar a alguien
  static const int PUNTOS_REFERIDO_ACTIVIDAD = 50; // Puntos cuando tu referido canjea

  Future<PuntosUsuario> obtenerPuntos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? puntosJson = prefs.getString(_keyPuntos);
    
    if (puntosJson != null) {
      return PuntosUsuario.fromJson(json.decode(puntosJson));
    }
    
    return PuntosUsuario.inicial();
  }

  Future<void> guardarPuntos(PuntosUsuario puntos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPuntos, json.encode(puntos.toJson()));
  }

  Future<PuntosUsuario> agregarPuntos({
    required int puntos,
    required String descripcion,
    String? logroId,
    String? logroTitulo,
    String? logroDescripcion,
    String? logroIcono,
  }) async {
    final puntosActuales = await obtenerPuntos();
    
    final nuevaTransaccion = Transaccion(
      tipo: 'ganado',
      puntos: puntos,
      descripcion: descripcion,
      fecha: DateTime.now(),
    );

    final historialActualizado = [nuevaTransaccion, ...puntosActuales.historial];
    
    List<Logro> logrosActualizados = puntosActuales.logros;
    
    // Si hay un logro asociado, agregarlo
    if (logroId != null && logroTitulo != null) {
      final nuevoLogro = Logro(
        id: logroId,
        titulo: logroTitulo,
        descripcion: logroDescripcion ?? '',
        puntos: puntos,
        icono: logroIcono ?? '🏆',
        fechaObtenido: DateTime.now(),
        completado: true,
      );
      
      // Verificar que no exista ya
      if (!logrosActualizados.any((l) => l.id == logroId)) {
        logrosActualizados = [nuevoLogro, ...logrosActualizados];
      }
    }

    final puntosNuevos = puntosActuales.copyWith(
      balance: puntosActuales.balance + puntos,
      historial: historialActualizado,
      logros: logrosActualizados,
    );

    await guardarPuntos(puntosNuevos);
    return puntosNuevos;
  }

  Future<PuntosUsuario> canjearPuntos({
    required int puntos,
    required String descripcion,
  }) async {
    final puntosActuales = await obtenerPuntos();
    
    if (puntosActuales.balance < puntos) {
      throw Exception('No tienes suficientes puntos');
    }

    final nuevaTransaccion = Transaccion(
      tipo: 'canjeado',
      puntos: puntos,
      descripcion: descripcion,
      fecha: DateTime.now(),
    );

    final puntosNuevos = puntosActuales.copyWith(
      balance: puntosActuales.balance - puntos,
      historial: [nuevaTransaccion, ...puntosActuales.historial],
    );

    await guardarPuntos(puntosNuevos);
    return puntosNuevos;
  }

  Future<CuponCanjeado> canjearCupon(Cupon cupon) async {
    final puntosActuales = await obtenerPuntos();
    
    if (puntosActuales.balance < cupon.puntosRequeridos) {
      throw Exception('No tienes suficientes puntos');
    }

    // Generar código de barras único
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final codigoBarras = '${cupon.id.toUpperCase().replaceAll('_', '').substring(0, 4)}$timestamp';

    // Crear cupón canjeado
    final cuponCanjeado = CuponCanjeado(
      id: 'canje_$timestamp',
      cuponId: cupon.id,
      titulo: cupon.titulo,
      descripcion: cupon.descripcion,
      imagen: cupon.imagen,
      categoria: cupon.categoria,
      codigoBarras: codigoBarras,
      fechaCanje: DateTime.now(),
      fechaExpiracion: DateTime.now().add(const Duration(days: 30)),
      usado: false,
    );

    // Registrar transacción
    final nuevaTransaccion = Transaccion(
      tipo: 'canjeado',
      puntos: cupon.puntosRequeridos,
      descripcion: 'Canjeado: ${cupon.titulo}',
      fecha: DateTime.now(),
    );

    // Actualizar puntos
    final puntosNuevos = puntosActuales.copyWith(
      balance: puntosActuales.balance - cupon.puntosRequeridos,
      historial: [nuevaTransaccion, ...puntosActuales.historial],
      cuponesCanjeados: [cuponCanjeado, ...puntosActuales.cuponesCanjeados],
    );

    await guardarPuntos(puntosNuevos);
    
    // Notificar al referidor (si existe)
    await notificarActividadReferido();
    
    return cuponCanjeado;
  }

  Future<void> marcarCuponComoUsado(String cuponCanjeadoId) async {
    final puntosActuales = await obtenerPuntos();
    
    final cuponesActualizados = puntosActuales.cuponesCanjeados.map((c) {
      if (c.id == cuponCanjeadoId) {
        return c.copyWith(usado: true);
      }
      return c;
    }).toList();

    final puntosNuevos = puntosActuales.copyWith(
      cuponesCanjeados: cuponesActualizados,
    );

    await guardarPuntos(puntosNuevos);
  }

  Future<bool> verificarCheckInDiario() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ultimoCheckIn = prefs.getString('ultimo_check_in');
    
    if (ultimoCheckIn == null) return false;
    
    final DateTime ultimaFecha = DateTime.parse(ultimoCheckIn);
    final DateTime hoy = DateTime.now();
    
    return ultimaFecha.year == hoy.year &&
           ultimaFecha.month == hoy.month &&
           ultimaFecha.day == hoy.day;
  }

  Future<void> registrarCheckInDiario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimo_check_in', DateTime.now().toIso8601String());
  }

  // Función para limpiar logros duplicados (útil para depuración)
  Future<void> limpiarLogrosDuplicados() async {
    final puntosActuales = await obtenerPuntos();
    
    // Crear un mapa para eliminar duplicados por ID
    final Map<String, Logro> logrosUnicos = {};
    for (var logro in puntosActuales.logros) {
      logrosUnicos[logro.id] = logro;
    }
    
    // Convertir de vuelta a lista
    final logrosLimpios = logrosUnicos.values.toList();
    
    final puntosLimpios = puntosActuales.copyWith(
      logros: logrosLimpios,
    );
    
    await guardarPuntos(puntosLimpios);
  }
  
  // Función para resetear completamente los datos (solo para pruebas)
  Future<void> resetearDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPuntos);
    await prefs.remove('ultimo_check_in');
    await prefs.remove('tutoriales_completados');
    await prefs.remove('historias_vistas');
  }

  // Guardar y obtener tutoriales completados
  Future<Set<String>> obtenerTutorialesCompletados() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tutoriales = prefs.getStringList('tutoriales_completados');
    return tutoriales?.toSet() ?? {};
  }

  Future<void> marcarTutorialCompletado(String tutorialId) async {
    final prefs = await SharedPreferences.getInstance();
    final tutoriales = await obtenerTutorialesCompletados();
    tutoriales.add(tutorialId);
    await prefs.setStringList('tutoriales_completados', tutoriales.toList());
  }

  // Guardar y obtener historias vistas
  Future<Set<int>> obtenerHistoriasVistas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historias = prefs.getStringList('historias_vistas');
    return historias?.map((e) => int.parse(e)).toSet() ?? {};
  }

  Future<void> marcarHistoriaVista(int anio) async {
    final prefs = await SharedPreferences.getInstance();
    final historias = await obtenerHistoriasVistas();
    historias.add(anio);
    await prefs.setStringList('historias_vistas', historias.map((e) => e.toString()).toList());
  }

  // Sistema de referidos
  Future<bool> aplicarCodigoReferido(String codigoReferido) async {
    final puntosActuales = await obtenerPuntos();
    
    // Verificar que no haya usado un código antes
    if (puntosActuales.codigoReferidoPor != null) {
      throw Exception('Ya has usado un código de referido');
    }
    
    // Verificar que no use su propio código
    if (puntosActuales.codigoReferido == codigoReferido) {
      throw Exception('No puedes usar tu propio código');
    }
    
    // Simular validación del código (en producción, esto sería una llamada al servidor)
    // Por ahora, aceptamos cualquier código que empiece con "DECIDE"
    if (!codigoReferido.startsWith('DECIDE')) {
      throw Exception('Código de referido inválido');
    }
    
    // Actualizar usuario actual con el código usado
    final puntosNuevos = puntosActuales.copyWith(
      codigoReferidoPor: codigoReferido,
      balance: puntosActuales.balance + 50, // Bonus por usar código
    );
    
    // Registrar transacción
    final nuevaTransaccion = Transaccion(
      tipo: 'ganado',
      puntos: 50,
      descripcion: 'Bonus por usar código de referido',
      fecha: DateTime.now(),
    );
    
    final puntosConHistorial = puntosNuevos.copyWith(
      historial: [nuevaTransaccion, ...puntosActuales.historial],
    );
    
    await guardarPuntos(puntosConHistorial);
    
    // En producción, aquí se notificaría al servidor para dar puntos al referidor
    // Por ahora, lo simulamos localmente si el código coincide
    await _procesarReferidoLocal(codigoReferido);
    
    return true;
  }

  Future<void> _procesarReferidoLocal(String codigoReferido) async {
    // Esta función simula dar puntos al referidor
    // En producción, esto se haría en el servidor
    final puntosActuales = await obtenerPuntos();
    
    if (puntosActuales.codigoReferido == codigoReferido) {
      // Es el mismo usuario, agregar referido
      final nuevoReferido = Referido(
        id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
        codigoReferido: 'Usuario Referido',
        fechaRegistro: DateTime.now(),
        puntosGanados: PUNTOS_REFERIDO_REGISTRO,
        activo: true,
      );
      
      final referidosActualizados = [nuevoReferido, ...puntosActuales.referidos];
      
      final nuevaTransaccion = Transaccion(
        tipo: 'ganado',
        puntos: PUNTOS_REFERIDO_REGISTRO,
        descripcion: '¡Nuevo referido registrado!',
        fecha: DateTime.now(),
      );
      
      final puntosNuevos = puntosActuales.copyWith(
        balance: puntosActuales.balance + PUNTOS_REFERIDO_REGISTRO,
        referidos: referidosActualizados,
        historial: [nuevaTransaccion, ...puntosActuales.historial],
      );
      
      await guardarPuntos(puntosNuevos);
    }
  }

  Future<void> notificarActividadReferido() async {
    // Esta función se llama cuando un referido canjea un cupón
    final puntosActuales = await obtenerPuntos();
    
    if (puntosActuales.codigoReferidoPor != null) {
      // Simular dar puntos al referidor
      // En producción, esto se haría en el servidor
      await _darPuntosAReferidor(puntosActuales.codigoReferidoPor!);
    }
  }

  Future<void> _darPuntosAReferidor(String codigoReferidor) async {
    final puntosActuales = await obtenerPuntos();
    
    if (puntosActuales.codigoReferido == codigoReferidor) {
      // Es el mismo usuario, dar puntos por actividad
      final nuevaTransaccion = Transaccion(
        tipo: 'ganado',
        puntos: PUNTOS_REFERIDO_ACTIVIDAD,
        descripcion: '¡Tu referido canjeó un cupón!',
        fecha: DateTime.now(),
      );
      
      final puntosNuevos = puntosActuales.copyWith(
        balance: puntosActuales.balance + PUNTOS_REFERIDO_ACTIVIDAD,
        historial: [nuevaTransaccion, ...puntosActuales.historial],
      );
      
      await guardarPuntos(puntosNuevos);
    }
  }

  int calcularTotalPuntosReferidos(List<Referido> referidos) {
    return referidos.fold(0, (sum, ref) => sum + ref.puntosGanados);
  }

  List<Cupon> obtenerCuponesDisponibles() {
    return [
      Cupon(
        id: 'cupon_cineplanet',
        titulo: 'Entrada 2x1 Cineplanet',
        descripcion: 'Válido de lunes a jueves en todas las sedes',
        puntosRequeridos: 800,
        imagen: '🎬',
        categoria: 'Entretenimiento',
      ),
      Cupon(
        id: 'cupon_plazavea',
        titulo: 'S/ 20 de descuento en Plaza Vea',
        descripcion: 'Compra mínima de S/ 100',
        puntosRequeridos: 600,
        imagen: '🛒',
        categoria: 'Supermercados',
      ),
      Cupon(
        id: 'cupon_inkafarma',
        titulo: '15% OFF en Inkafarma',
        descripcion: 'Válido en productos seleccionados',
        puntosRequeridos: 500,
        imagen: '💊',
        categoria: 'Salud',
      ),
      Cupon(
        id: 'cupon_tottus',
        titulo: 'S/ 15 de descuento en Tottus',
        descripcion: 'Compra mínima de S/ 80',
        puntosRequeridos: 550,
        imagen: '🛍️',
        categoria: 'Supermercados',
      ),
      Cupon(
        id: 'cupon_granja_villa',
        titulo: '20% OFF en La Granja Villa',
        descripcion: 'Válido en todas las sedes',
        puntosRequeridos: 700,
        imagen: '🍗',
        categoria: 'Restaurantes',
      ),
    ];
  }
}
