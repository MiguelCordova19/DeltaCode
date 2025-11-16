import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/presidente.dart';
import '../services/gamificacion_service.dart';

class CuriosidadesScreen extends StatefulWidget {
  const CuriosidadesScreen({super.key});

  @override
  State<CuriosidadesScreen> createState() => _CuriosidadesScreenState();
}

class _CuriosidadesScreenState extends State<CuriosidadesScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _handController;
  late ScrollController _scrollController;
  Presidente? _selectedPresidente;
  Color? _selectedColor;
  
  final GamificacionService _gamificacionService = GamificacionService();
  Set<int> _visitedYears = {};
  int _totalCoins = 0;
  bool _showTutorial = true;
  bool _showCoinsAnimation = false;
  
  final List<Presidente> _presidentes = [
    Presidente(
      nombre: 'Valentín Paniagua',
      partido: 'Acción Popular',
      periodo: '2000-2001',
      anioInicio: 2000,
      anioFin: 2001,
      duracion: '~8 meses',
      mandatoCompleto: '22 de noviembre de 2000 – 28 de julio de 2001',
      motivoSalida: 'Gobierno transitorio tras la renuncia de Alberto Fujimori; entrega del poder al presidente electo Alejandro Toledo.',
    ),
    Presidente(
      nombre: 'Alejandro Toledo',
      partido: 'Perú Posible',
      periodo: '2001-2006',
      anioInicio: 2001,
      anioFin: 2006,
      duracion: '5 años',
      mandatoCompleto: '28 de julio de 2001 – 28 de julio de 2006',
      motivoSalida: 'Fin de su mandato constitucional, terminado el periodo presidencial.',
    ),
    Presidente(
      nombre: 'Alan García Pérez',
      partido: 'Partido Aprista Peruano (APRA)',
      periodo: '2006-2011',
      anioInicio: 2006,
      anioFin: 2011,
      duracion: '5 años',
      mandatoCompleto: '28 de julio de 2006 – 28 de julio de 2011',
      motivoSalida: 'Fin de su segundo mandato constitucional.',
    ),
    Presidente(
      nombre: 'Ollanta Humala Tasso',
      partido: 'Partido Nacionalista Peruano',
      periodo: '2011-2016',
      anioInicio: 2011,
      anioFin: 2016,
      duracion: '5 años',
      mandatoCompleto: '28 de julio de 2011 – 28 de julio de 2016',
      motivoSalida: 'Terminó su mandato según la Constitución.',
    ),
    Presidente(
      nombre: 'Pedro Pablo Kuczynski (PPK)',
      partido: 'Peruanos Por el Kambio',
      periodo: '2016-2018',
      anioInicio: 2016,
      anioFin: 2018,
      duracion: '~1 año y 8 meses',
      mandatoCompleto: '28 de julio de 2016 – 23 de marzo de 2018',
      motivoSalida: 'Renunció en medio de presión política y escándalos (relacionados con Odebrecht).',
    ),
    Presidente(
      nombre: 'Martín Vizcarra',
      partido: 'Peruanos Por el Kambio',
      periodo: '2018-2020',
      anioInicio: 2018,
      anioFin: 2020,
      duracion: '~2 años y 7 meses',
      mandatoCompleto: '23 de marzo de 2018 – 9 de noviembre de 2020',
      motivoSalida: 'Vacancia por parte del Congreso aprobada por "incapacidad moral permanente".',
    ),
    Presidente(
      nombre: 'Manuel Merino',
      partido: 'Acción Popular',
      periodo: '2020',
      anioInicio: 2020,
      anioFin: 2020,
      duracion: '5 días',
      mandatoCompleto: '10 de noviembre de 2020 – 15 de noviembre de 2020',
      motivoSalida: 'Renunció tras fuertes protestas sociales.',
    ),
    Presidente(
      nombre: 'Francisco Sagasti',
      partido: 'Partido Morado',
      periodo: '2020-2021',
      anioInicio: 2020,
      anioFin: 2021,
      duracion: '~8 meses',
      mandatoCompleto: '17 de noviembre de 2020 – 28 de julio de 2021',
      motivoSalida: 'Culminación de su periodo de transición hasta las nuevas elecciones.',
    ),
    Presidente(
      nombre: 'Pedro Castillo Terrones',
      partido: 'Perú Libre',
      periodo: '2021-2022',
      anioInicio: 2021,
      anioFin: 2022,
      duracion: '~1 año y 4 meses',
      mandatoCompleto: '28 de julio de 2021 – 7 de diciembre de 2022',
      motivoSalida: 'Destituido por el Congreso con 101 votos a favor de la vacancia por "incapacidad moral permanente" luego de un intento fallido de autogolpe.',
    ),
    Presidente(
      nombre: 'Dina Boluarte Zegarra',
      partido: 'Perú Libre (renunció al partido)',
      periodo: '2022-2025',
      anioInicio: 2022,
      anioFin: 2025,
      duracion: '~2 años y 10 meses',
      mandatoCompleto: '7 de diciembre de 2022 – 10 de octubre de 2025',
      motivoSalida: 'Destitución por el Congreso ("incapacidad moral permanente") en una moción expresa.',
    ),
    Presidente(
      nombre: 'José Enrique Jerí Oré',
      partido: 'Somos Perú',
      periodo: '2025-',
      anioInicio: 2025,
      duracion: 'Mandato interino',
      mandatoCompleto: 'Desde 10 de octubre de 2025',
      motivoSalida: 'Asumió tras la destitución de Dina Boluarte por "incapacidad moral permanente" según el Congreso. Mandato hasta las próximas elecciones.',
      esActual: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _handController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _scrollController = ScrollController();
    _controller.forward();
    
    // Cargar historias vistas
    _cargarHistoriasVistas();
    
    // Mostrar tutorial inmediatamente al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _showTutorial && _visitedYears.isEmpty) {
        _showTutorialDialog();
      }
    });
  }

  Future<void> _cargarHistoriasVistas() async {
    final historias = await _gamificacionService.obtenerHistoriasVistas();
    if (mounted) {
      setState(() {
        _visitedYears = historias;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _handController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '👋',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Toca los círculos de los años para descubrir la historia de cada presidente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🪙',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '+10 monedas\npor cada historia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _showTutorial = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '¡Entendido!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForYear(int year) {
    final colors = [
      const Color(0xFFE53935), // Rojo
      const Color(0xFFFF6F00), // Naranja
      const Color(0xFFFFA726), // Naranja claro
      const Color(0xFF66BB6A), // Verde
      const Color(0xFF26C6DA), // Cyan
      const Color(0xFF5C6BC0), // Azul
      const Color(0xFFAB47BC), // Púrpura
      const Color(0xFFEC407A), // Rosa
    ];
    return colors[year % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFE53935),
            actions: [
              // Contador de monedas
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text(
                      '🪙',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_totalCoins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      '🏛️',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Presidentes del Perú',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2000 - 2025',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_visitedYears.length}/${_presidentes.length} historias descubiertas',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Timeline
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final presidente = _presidentes[index];
                  final isLeft = index % 2 == 0;
                  final color = _getColorForYear(presidente.anioInicio);
                  
                  return _buildTimelineItem(
                    presidente: presidente,
                    isLeft: isLeft,
                    color: color,
                    index: index,
                  );
                },
                childCount: _presidentes.length,
              ),
            ),
          ),
        ],
      ),
          
          // Animación flotante de monedas ganadas
          if (_showCoinsAnimation)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -50 * value),
                      child: Opacity(
                        opacity: 1 - value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber[400]!,
                                Colors.orange[400]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '🪙',
                                style: TextStyle(fontSize: 32),
                              ),
                              SizedBox(width: 12),
                              Text(
                                '+10 monedas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required Presidente presidente,
    required bool isLeft,
    required Color color,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: clampedValue,
          child: child,
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            // Línea vertical central
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 2,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.3),
                      color,
                    ],
                  ),
                ),
              ),
            ),

            // Círculo del año en el centro (clickeable)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 35,
              top: 25,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => _showPresidenteDetail(presidente, color, isLeft),
                    child: _buildYearCircle(presidente.anioInicio, color, presidente.esActual),
                  ),
                  // Manita animada con texto si no ha sido visitado y el tutorial está activo
                  if (_showTutorial && !_visitedYears.contains(presidente.anioInicio))
                    Positioned(
                      left: 80,
                      top: 15,
                      child: AnimatedBuilder(
                        animation: _handController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              -8 + (_handController.value * 8),
                              math.sin(_handController.value * math.pi * 2) * 3,
                            ),
                            child: Row(
                              children: [
                                Transform.rotate(
                                  angle: -0.3 + (math.sin(_handController.value * math.pi * 2) * 0.2),
                                  child: const Text(
                                    '👈',
                                    style: TextStyle(fontSize: 36),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Toca aquí',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearCircle(int year, Color color, bool esActual) {
    final bool isVisited = _visitedYears.contains(year);
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * math.pi * 2,
            child: child,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isVisited ? color.withOpacity(0.6) : color,
              border: esActual ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    year.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isVisited)
                    const Text(
                      '✓',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Badge "NUEVO" si no ha sido visitado
          if (!isVisited)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '¡NUEVO!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPresidenteDetail(Presidente presidente, Color color, bool isLeft) async {
    // Verificar si es la primera vez que ve esta historia
    final bool isFirstTime = !_visitedYears.contains(presidente.anioInicio);
    
    if (isFirstTime) {
      setState(() {
        _selectedPresidente = presidente;
        _selectedColor = color;
        _visitedYears.add(presidente.anioInicio);
        _totalCoins += 10;
      });
      
      // Guardar en persistencia
      await _gamificacionService.marcarHistoriaVista(presidente.anioInicio);
    } else {
      setState(() {
        _selectedPresidente = presidente;
        _selectedColor = color;
      });
    }

    // Mostrar el modal y esperar a que se cierre
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Animación de escala que crece desde el centro
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      // Header con círculo del año
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Círculo del año animado
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        presidente.anioInicio.toString(),
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              presidente.periodo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Contenido
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Nombre
                            Text(
                              presidente.nombre,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // Partido
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                presidente.partido,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Información adicional
                            if (presidente.mandatoCompleto != null)
                              _buildInfoRow(
                                Icons.event,
                                'Mandato',
                                presidente.mandatoCompleto!,
                                color,
                              ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.access_time,
                              'Duración',
                              presidente.duracion,
                              color,
                            ),
                            
                            // Motivo de salida
                            if (presidente.motivoSalida != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: color.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: color,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Motivo de salida',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      presidente.motivoSalida!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Badge "ACTUAL"
                            if (presidente.esActual) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'PRESIDENTE ACTUAL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Botón cerrar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Regresar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    
    // Mostrar animación de monedas después de cerrar el modal (solo si es primera vez)
    if (isFirstTime && mounted) {
      // Guardar solo las monedas (sin logro individual)
      await _gamificacionService.agregarPuntos(
        puntos: 10,
        descripcion: 'Descubriste la historia de ${presidente.nombre}',
      );
      
      // Verificar si completó todas las historias
      if (_visitedYears.length == _presidentes.length) {
        await _gamificacionService.agregarPuntos(
          puntos: 100,
          descripcion: '¡Completaste todas las historias presidenciales!',
          logroId: 'descubriendo_historia_completo',
          logroTitulo: '🎓 Descubriendo la Historia',
          logroDescripcion: 'Has descubierto todas las historias presidenciales del Perú (2000-2025)',
          logroIcono: '🎓',
        );
        
        // Mostrar diálogo especial de logro completado
        if (mounted) {
          _mostrarLogroEspecial();
        }
      }
      
      setState(() {
        _showCoinsAnimation = true;
      });
      
      // Ocultar animación de monedas después de 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showCoinsAnimation = false;
          });
        }
      });
    }
  }
  
  void _mostrarLogroEspecial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE53935),
                Color(0xFFD32F2F),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Felicitaciones!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🎓',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Descubriendo la Historia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Has descubierto todas las historias presidenciales',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🪙',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+100 monedas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '¡Genial!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
