import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../services/notification_service.dart';
import '../models/usuario.dart';
import 'plan_gobierno_screen.dart';
import 'miembros_mesa_screen.dart';
import 'candidatos_screen.dart';
import 'login_screen.dart';
import 'noticias_screen.dart';
import 'locales_votacion_screen.dart';
import 'informacion_electoral_screen.dart';
import 'tutoriales_screen.dart';
import 'como_votar_screen.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuario = await _usuarioService.obtenerUsuario();
    if (usuario != null && mounted) {
      setState(() {
        _usuario = usuario;
        _isLoading = false;
      });
      
      // Mostrar diálogo de bienvenida con local de votación
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogoBienvenida();
      });
    }
  }

  Future<void> _mostrarDialogoBienvenida() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              // Sombra principal (más oscura y cercana)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: -5,
              ),
              // Sombra secundaria (más suave y lejana)
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 60,
                offset: const Offset(0, 30),
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón cerrar con efecto 3D
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (mounted) Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Título con efecto 3D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '¡Bienvenido, ${_usuario?.nombreCompleto?.split(' ')[0] ?? 'Ciudadano'}!',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // Ícono 3D con sombras múltiples
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE53935),
                      Color(0xFFD32F2F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    // Sombra principal del ícono
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: -5,
                    ),
                    // Sombra de profundidad
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: -8,
                    ),
                    // Highlight superior
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 0,
                      offset: const Offset(0, -2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.how_to_vote_rounded,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Tu Local de Votación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Card de información con efecto 3D elevado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      // Sombra principal
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                      // Sombra de profundidad
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Ícono de ubicación con efecto 3D
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                                color: const Color(0xFFE53935).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: -3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'I.E. San Pedro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D2D2D),
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Av. Pardo 123, Chimbote',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Badge de mesa con efecto 3D
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.table_chart_rounded,
                                color: Colors.grey[700],
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mesa: 001234',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w700,
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

              const SizedBox(height: 16),

              // Mensaje informativo con efecto sutil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_rounded,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Consulta más detalles en "Mi Local"',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botones con efecto 3D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Botón Cerrar con efecto 3D sutil
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              if (mounted) Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE53935).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                'Cerrar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFE53935),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Botón Ver Detalles con efecto 3D pronunciado
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            // Sombra principal del botón
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                              spreadRadius: -4,
                            ),
                            // Sombra de profundidad
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LocalesVotacionScreen(),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFE53935),
                                    Color(0xFFD32F2F),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: const Text(
                                  'Ver Detalles',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFE53935), // Rojo
                  ),
                ),
              )
            : CustomScrollView(
                slivers: [
                  // App Bar con gradiente rojo
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: const Color(0xFFE53935),
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE53935), // Rojo principal
                              Color(0xFFEF5350), // Rojo más claro
                            ],
                          ),
                        ),
                      ),
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                      title: const Text(
                        'Descubre',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                        onPressed: () async {
                          // Mostrar notificación de prueba
                          await NotificationService().mostrarNotificacionNoticias();
                          
                          // Mostrar confirmación en la app
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text('Notificación enviada. Revisa tu bandeja de notificaciones.'),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFFE53935),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  // Contenido en grid
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildListDelegate([
                        _buildDiscoveryCard(
                          icon: Icons.description_outlined,
                          title: 'Planes de\nGobierno',
                          subtitle: '43 Partidos',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const PlanGobiernoScreen(),
                        ),

                        _buildDiscoveryCard(
                          icon: Icons.how_to_vote_outlined,
                          title: 'Miembros\nde Mesa',
                          subtitle: 'Información importante',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const MiembrosMesaScreen(),
                        ),
                        _buildDiscoveryCard(
                          icon: Icons.location_on_outlined,
                          title: 'Mi Local',
                          subtitle: 'Encuentra tu local',
                          color: const Color(0xFFD32F2F), // Rojo destacado
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          isHighlighted: true,
                          destination: const LocalesVotacionScreen(),
                        ),
                        _buildDiscoveryCard(
                          icon: Icons.school_outlined,
                          title: 'Tutoriales',
                          subtitle: 'Aprende a usar la app',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const TutorialesScreen(),
                        ),
                        _buildDiscoveryCard(
                          icon: Icons.newspaper_outlined,
                          title: 'Noticias',
                          subtitle: 'Últimas actualizaciones',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const NoticiasScreen(),
                        ),
                        _buildDiscoveryCard(
                          icon: Icons.how_to_vote,
                          title: 'Cómo Votar',
                          subtitle: 'Tutoriales en video',
                          color: const Color(0xFFD32F2F), // Rojo destacado
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          isHighlighted: true,
                          destination: const ComoVotarScreen(),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDiscoveryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required Widget destination,
    Color textColor = Colors.black87,
    bool isHighlighted = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            // Pequeña pausa para mostrar el efecto ripple
            await Future.delayed(const Duration(milliseconds: 150));
            
            // Navegar con transición personalizada
            if (mounted) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return destination;
                  },
                  transitionDuration: const Duration(milliseconds: 600),
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Animación de fade
                    var fadeAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                    ));
                    
                    // Animación de slide desde abajo
                    var slideAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.15),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ));
                    
                    // Animación de escala
                    var scaleAnimation = Tween<double>(
                      begin: 0.92,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ));
                    
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xFFD32F2F).withOpacity(0.4), // Ripple rojo fuerte
          highlightColor: const Color(0xFFD32F2F).withOpacity(0.3),
          splashFactory: InkRipple.splashFactory, // Efecto circular
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHighlighted 
                    ? const Color(0xFFD32F2F).withOpacity(0.8)
                    : const Color(0xFFD32F2F).withOpacity(0.3), // Borde rojo
                width: isHighlighted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHighlighted
                      ? const Color(0xFFD32F2F).withOpacity(0.5)
                      : const Color(0xFFD32F2F).withOpacity(0.15),
                  blurRadius: isHighlighted ? 20 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono con animación
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFFD32F2F).withOpacity(0.1), // Fondo rojo muy tenue
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD32F2F).withOpacity(0.4), // Borde rojo
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 32,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Título
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtítulo
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
