import 'package:flutter/material.dart';
import '../services/gamificacion_service.dart';
import '../services/monedas_notifier.dart';
import '../models/puntos_usuario.dart';
import '../screens/recompensas_screen.dart';

class MonedasWidget extends StatefulWidget {
  const MonedasWidget({super.key});

  @override
  State<MonedasWidget> createState() => _MonedasWidgetState();
}

class _MonedasWidgetState extends State<MonedasWidget> {
  final GamificacionService _gamificacionService = GamificacionService();
  final MonedasNotifier _notifier = MonedasNotifier();
  int _balance = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarBalance();
    // Escuchar cambios en las monedas
    _notifier.addListener(_onMonedasChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onMonedasChanged);
    super.dispose();
  }

  void _onMonedasChanged() {
    _cargarBalance();
  }

  Future<void> _cargarBalance() async {
    final puntos = await _gamificacionService.obtenerPuntos();
    if (mounted) {
      setState(() {
        _balance = puntos.balance;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 120,
        height: 50,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFE53935),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecompensasScreen(),
          ),
        ).then((_) => _cargarBalance());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE53935),
              Color(0xFFD32F2F),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de moneda
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🪙',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Balance
            Text(
              _balance.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
