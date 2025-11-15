import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../models/usuario.dart';
import 'plan_gobierno_screen.dart';
import 'miembros_mesa_screen.dart';
import 'candidatos_screen.dart';
import 'login_screen.dart';
import 'noticias_screen.dart';
import 'locales_votacion_screen.dart';
import 'informacion_electoral_screen.dart';
import 'calendario_electoral_screen.dart';

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
    }
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
                        onPressed: () {},
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
                          icon: Icons.people_outline,
                          title: 'Candidatos',
                          subtitle: 'Conoce sus propuestas',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const CandidatosScreen(),
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
                          icon: Icons.calendar_month_outlined,
                          title: 'Calendario\nElectoral',
                          subtitle: 'Fechas importantes',
                          color: Colors.white, // Blanco
                          iconColor: const Color(0xFFD32F2F), // Rojo
                          textColor: Colors.black87,
                          destination: const CalendarioElectoralScreen(),
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
