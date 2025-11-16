import 'package:flutter/material.dart';
import 'dart:math';
import '../services/gamificacion_service.dart';
import '../models/puntos_usuario.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'referidos_screen.dart';

class RecompensasScreen extends StatefulWidget {
  const RecompensasScreen({super.key});

  @override
  State<RecompensasScreen> createState() => _RecompensasScreenState();
}

class _RecompensasScreenState extends State<RecompensasScreen>
    with SingleTickerProviderStateMixin {
  final GamificacionService _gamificacionService = GamificacionService();
  PuntosUsuario? _puntosUsuario;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _puntosUsuario = puntos;
        _isLoading = false;
      });
    }
  }

  Future<void> _canjearCupon(Cupon cupon) async {
    if (_puntosUsuario!.balance < cupon.puntosRequeridos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes suficientes puntos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Canjear Cupón'),
        content: Text(
          '¿Deseas canjear ${cupon.puntosRequeridos} puntos por:\n\n${cupon.titulo}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Canjear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final cuponCanjeado = await _gamificacionService.canjearCupon(cupon);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Cupón canjeado exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarDatos();
          
          // Cambiar a la pestaña "Mis Cupones"
          _tabController.animateTo(1);
          
          // Mostrar el cupón canjeado
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _mostrarCuponCanjeado(cuponCanjeado);
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Recompensas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Referidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReferidosScreen(),
                ),
              ).then((_) => _cargarDatos());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header con balance
                _buildHeader(),
                
                // Banner de referidos
                _buildBannerReferidos(),
                
                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFFE53935),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFE53935),
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Cupones'),
                      Tab(text: 'Mis Cupones'),
                      Tab(text: 'Logros'),
                      Tab(text: 'Historial'),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCuponesTab(),
                      _buildMisCuponesTab(),
                      _buildLogrosTab(),
                      _buildHistorialTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBannerReferidos() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.purple[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReferidosScreen(),
              ),
            ).then((_) => _cargarDatos());
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Invita amigos!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gana 100 🪙 por cada referido',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE53935),
            Color(0xFFD32F2F),
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🪙',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_puntosUsuario!.balance}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'puntos disponibles',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuponesTab() {
    final cupones = _gamificacionService.obtenerCuponesDisponibles();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cupones.length,
      itemBuilder: (context, index) {
        final cupon = cupones[index];
        final puedeCanjear = _puntosUsuario!.balance >= cupon.puntosRequeridos;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: puedeCanjear ? () => _canjearCupon(cupon) : null,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icono
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: puedeCanjear
                            ? const Color(0xFFE53935).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Opacity(
                          opacity: puedeCanjear ? 1.0 : 0.5,
                          child: Text(
                            cupon.imagen,
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cupon.titulo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: puedeCanjear
                                  ? const Color(0xFF2D2D2D)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cupon.descripcion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '🪙',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${cupon.puntosRequeridos}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: puedeCanjear
                                      ? const Color(0xFFE53935)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botón
                    Icon(
                      puedeCanjear ? Icons.arrow_forward_ios : Icons.lock,
                      color: puedeCanjear ? const Color(0xFFE53935) : Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogrosTab() {
    // Lista de todos los logros disponibles
    final logrosDisponibles = [
      {
        'id': 'descubriendo_historia_completo',
        'icono': '🎓',
        'titulo': 'Descubriendo la Historia',
        'descripcion': 'Descubre todas las historias presidenciales del Perú (2000-2025)',
        'puntos': 100,
        'requisito': 'Visita las 11 historias en la sección "Presidentes del Perú"',
      },
      {
        'id': 'primer_plan_leido',
        'icono': '📖',
        'titulo': 'Primer Plan Leído',
        'descripcion': 'Lee tu primer plan de gobierno completo',
        'puntos': 100,
        'requisito': 'Lee un plan de gobierno en la sección "Planes de Gobierno"',
      },
      {
        'id': 'explorador_politico',
        'icono': '🔍',
        'titulo': 'Explorador Político',
        'descripcion': 'Conoce a tu primer candidato',
        'puntos': 25,
        'requisito': 'Visita el perfil de un candidato en "Precandidatos"',
      },
      {
        'id': 'ciudadano_informado',
        'icono': '📰',
        'titulo': 'Ciudadano Informado',
        'descripcion': 'Lee tu primera noticia electoral',
        'puntos': 15,
        'requisito': 'Lee una noticia en la sección "Noticias"',
      },
      {
        'id': 'tutorial_completado',
        'icono': '✅',
        'titulo': 'Aprendiz Electoral',
        'descripcion': 'Completa tu primer tutorial',
        'puntos': 50,
        'requisito': 'Completa un tutorial en la sección "Tutoriales"',
      },
    ];

    // Verificar qué logros están desbloqueados
    final logrosDesbloqueados = _puntosUsuario!.logros.map((l) => l.id).toSet();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Estadísticas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${logrosDesbloqueados.length}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Desbloqueados',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                ),
                Column(
                  children: [
                    Text(
                      '${logrosDisponibles.length - logrosDesbloqueados.length}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Por desbloquear',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Grid de logros hexagonales
          Wrap(
            spacing: 16,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: logrosDisponibles.map((logro) {
              final estaDesbloqueado = logrosDesbloqueados.contains(logro['id']);
              return _buildHexagonalBadge(
                icono: logro['icono'] as String,
                titulo: logro['titulo'] as String,
                descripcion: logro['descripcion'] as String,
                requisito: logro['requisito'] as String,
                puntos: logro['puntos'] as int,
                completado: estaDesbloqueado,
              );
            }).toList(),
          ),
          
          // Mensaje motivacional
          if (logrosDesbloqueados.length < logrosDisponibles.length) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Color(0xFFE53935), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '¡Sigue explorando para desbloquear más logros!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHexagonalBadge({
    required String icono,
    required String titulo,
    required String descripcion,
    required String requisito,
    required int puntos,
    required bool completado,
  }) {
    return GestureDetector(
      onTap: () => _mostrarDetalleLogro(icono, titulo, descripcion, requisito, puntos, completado),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Hexágono
              CustomPaint(
                size: const Size(90, 90),
                painter: HexagonPainter(
                  color: completado
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE53935),
                            Color(0xFFD32F2F),
                          ],
                        )
                      : LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                        ),
                  shadowColor: completado
                      ? const Color(0xFFE53935).withOpacity(0.4)
                      : Colors.transparent,
                ),
              ),
              // Ícono
              Opacity(
                opacity: completado ? 1.0 : 0.5,
                child: Text(
                  completado ? icono : '🔒',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Puntos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: completado ? Colors.amber : Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🪙',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  '+$puntos',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalleLogro(String icono, String titulo, String descripcion, String requisito, int puntos, bool completado) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: HexagonPainter(
                      color: completado
                          ? const LinearGradient(
                              colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                            )
                          : LinearGradient(
                              colors: [Colors.grey[300]!, Colors.grey[400]!],
                            ),
                      shadowColor: completado
                          ? const Color(0xFFE53935).withOpacity(0.4)
                          : Colors.transparent,
                    ),
                  ),
                  Opacity(
                    opacity: completado ? 1.0 : 0.5,
                    child: Text(
                      completado ? icono : '🔒',
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                descripcion,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Recompensa
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: completado ? Colors.amber : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🪙',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+$puntos monedas',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Requisito (solo si no está completado)
              if (!completado) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE53935).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFFE53935), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Cómo desbloquear:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        requisito,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: completado ? const Color(0xFFE53935) : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialTab() {
    if (_puntosUsuario!.historial.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📋',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin historial',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _puntosUsuario!.historial.length,
      itemBuilder: (context, index) {
        final transaccion = _puntosUsuario!.historial[index];
        final esGanado = transaccion.tipo == 'ganado';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              // Icono
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: esGanado
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  esGanado ? Icons.add : Icons.remove,
                  color: esGanado ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaccion.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatearFecha(transaccion.fecha),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Puntos
              Text(
                '${esGanado ? '+' : '-'}${transaccion.puntos}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: esGanado ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMisCuponesTab() {
    final cuponesCanjeados = _puntosUsuario!.cuponesCanjeados;
    
    if (cuponesCanjeados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎫',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes cupones canjeados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Canjea puntos por cupones\nen la pestaña "Cupones"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cuponesCanjeados.length,
      itemBuilder: (context, index) {
        final cupon = cuponesCanjeados[index];
        final estaVencido = cupon.fechaExpiracion.isBefore(DateTime.now());
        final diasRestantes = cupon.fechaExpiracion.difference(DateTime.now()).inDays;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: cupon.usado || estaVencido
                ? LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[400]!],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE53935),
                      Color(0xFFD32F2F),
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (!cupon.usado && !estaVencido)
                  ? () => _mostrarCuponCanjeado(cupon)
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icono
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          cupon.imagen,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cupon.titulo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cupon.descripcion,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (cupon.usado)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '✓ USADO',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else if (estaVencido)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '⚠ VENCIDO',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: diasRestantes <= 7
                                    ? Colors.orange.withOpacity(0.3)
                                    : Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                diasRestantes <= 7
                                    ? '⏰ Vence en $diasRestantes días'
                                    : '✓ Válido',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Icono
                    if (!cupon.usado && !estaVencido)
                      const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 28,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarCuponCanjeado(CuponCanjeado cupon) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE53935),
                        Color(0xFFD32F2F),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        cupon.imagen,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cupon.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cupon.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Código de barras
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Presenta este código en caja',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: cupon.codigoBarras,
                              width: 250,
                              height: 80,
                              drawText: false,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cupon.codigoBarras,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Información adicional
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Canjeado:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatearFecha(cupon.fechaCanje),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Válido hasta:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${cupon.fechaExpiracion.day}/${cupon.fechaExpiracion.month}/${cupon.fechaExpiracion.year}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE53935),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botones
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);
    
    if (diferencia.inDays == 0) {
      return 'Hoy';
    } else if (diferencia.inDays == 1) {
      return 'Ayer';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }
}

// Custom Painter para hexágonos
class HexagonPainter extends CustomPainter {
  final Gradient color;
  final Color shadowColor;

  HexagonPainter({required this.color, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = color.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = _createHexagonPath(size);

    // Dibujar sombra
    canvas.drawPath(path, shadowPaint);
    // Dibujar hexágono
    canvas.drawPath(path, paint);
  }

  Path _createHexagonPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * 3.14159 / 180;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

