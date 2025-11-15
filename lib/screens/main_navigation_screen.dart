import 'package:flutter/material.dart';
import 'home_screen_content.dart';
import 'chat_list_screen.dart';
import 'calendario_electoral_screen.dart';
import 'perfil_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const ChatListScreen(),
    const CalendarioElectoralScreen(),
    const PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    // Controladores para los iconos del menú
    _controllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    
    // Controlador para transición de página
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeInOut,
      ),
    );
    
    _controllers[0].forward();
    _pageTransitionController.forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      // Animar salida de página actual
      _pageTransitionController.reverse().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        // Animar entrada de nueva página
        _pageTransitionController.forward();
      });
      
      // Animar iconos
      _controllers[_selectedIndex].reverse();
      _controllers[index].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2C), // Negro
              Color(0xFF1A1A1A), // Negro más oscuro
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.chat_bubble_outline, 1),
                _buildNavItem(Icons.calendar_month_outlined, 2),
                _buildNavItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(15),
        splashColor: const Color(0xFFE53935).withOpacity(0.2), // Efecto splash rojo
        highlightColor: const Color(0xFFE53935).withOpacity(0.1),
        child: Container(
          width: 60,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Indicador superior con animación
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 40 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE53935), // Rojo
                        Color(0xFFEF5350), // Rojo claro
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
              
              // Fondo circular animado cuando está seleccionado
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isSelected ? 50 : 0,
                height: isSelected ? 50 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE53935).withOpacity(0.15), // Rojo muy tenue
                ),
              ),
              
              // Efecto de brillo detrás del icono
              if (isSelected)
                AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE53935).withOpacity(0.25), // Rojo
                            const Color(0xFFE53935).withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    );
                  },
                ),
              
              // Icono con animación
              AnimatedBuilder(
                animation: _scaleAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimations[index].value,
                    child: Icon(
                      icon,
                      color: isSelected 
                          ? const Color(0xFFE53935) // Rojo cuando seleccionado
                          : Colors.grey[400], // Gris claro cuando no seleccionado
                      size: 28,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
