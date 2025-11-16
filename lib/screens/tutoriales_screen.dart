import 'package:flutter/material.dart';
import '../services/gamificacion_service.dart';
import '../widgets/dialogo_felicitacion.dart';
import 'tutorial_miembro_mesa_screen.dart';
import 'video_beneficios_screen.dart';

class TutorialesScreen extends StatefulWidget {
  const TutorialesScreen({super.key});

  @override
  State<TutorialesScreen> createState() => _TutorialesScreenState();
}

class _TutorialesScreenState extends State<TutorialesScreen> {
  final GamificacionService _gamificacionService = GamificacionService();
  Set<String> _tutorialesCompletados = {};

  @override
  void initState() {
    super.initState();
    _cargarTutorialesCompletados();
  }

  Future<void> _cargarTutorialesCompletados() async {
    final tutoriales = await _gamificacionService.obtenerTutorialesCompletados();
    if (mounted) {
      setState(() {
        _tutorialesCompletados = tutoriales;
      });
    }
  }

  Future<void> _completarTutorial(String tutorialId, String tutorialNombre) async {
    // Verificar si ya fue completado
    if (_tutorialesCompletados.contains(tutorialId)) {
      // Ya completado, solo navegar
      return;
    }

    // Marcar como completado en memoria y persistencia
    setState(() {
      _tutorialesCompletados.add(tutorialId);
    });
    await _gamificacionService.marcarTutorialCompletado(tutorialId);

    // Verificar si es el primer tutorial completado
    final esPrimerTutorial = _tutorialesCompletados.length == 1;

    // Otorgar puntos
    await _gamificacionService.agregarPuntos(
      puntos: GamificacionService.PUNTOS_COMPLETAR_TUTORIAL,
      descripcion: 'Tutorial completado: $tutorialNombre',
      logroId: esPrimerTutorial ? 'tutorial_completado' : null,
      logroTitulo: esPrimerTutorial ? '✅ Aprendiz Electoral' : null,
      logroDescripcion: esPrimerTutorial ? 'Completa tu primer tutorial' : null,
      logroIcono: esPrimerTutorial ? '✅' : null,
    );

    // Mostrar felicitación
    if (mounted) {
      if (esPrimerTutorial) {
        // Mostrar diálogo de logro especial
        await _mostrarDialogoLogro(
          icono: '✅',
          titulo: '¡Logro desbloqueado!',
          descripcion: 'Aprendiz Electoral',
          puntos: GamificacionService.PUNTOS_COMPLETAR_TUTORIAL,
        );
      } else {
        // Mostrar diálogo normal
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DialogoFelicitacion(
            titulo: '¡Excelente!',
            mensaje: 'Has completado el tutorial:\n$tutorialNombre',
            puntosGanados: GamificacionService.PUNTOS_COMPLETAR_TUTORIAL,
            icono: '📚',
          ),
        );
      }
    }
  }
  
  Future<void> _mostrarDialogoLogro({
    required String icono,
    required String titulo,
    required String descripcion,
    required int puntos,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange[400]!,
                Colors.deepOrange[400]!,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono animado
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
                        color: Colors.white,
                        shape: BoxShape.circle,
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
                          icono,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                descripcion,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$puntos puntos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrange[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header con gradiente rojo
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
                      Color(0xFFE53935),
                      Color(0xFFEF5350),
                    ],
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Tutoriales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Contenido
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Sección: Uso de la Aplicación
                _buildSeccionTitulo('Uso de la Aplicación'),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.phone_android,
                  title: 'Cómo usar la app',
                  descripcion: 'Aprende a navegar y usar todas las funciones',
                  duracion: '5 min',
                  color: const Color(0xFFE53935),
                  onTap: () {
                    _mostrarTutorialApp(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.search,
                  title: 'Buscar información electoral',
                  descripcion: 'Encuentra precandidatos, planes y locales de votación',
                  duracion: '3 min',
                  color: const Color(0xFFD32F2F),
                  onTap: () {
                    _mostrarTutorialBusqueda(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Usar el Asistente Electoral',
                  descripcion: 'Pregunta lo que necesites sobre las elecciones',
                  duracion: '2 min',
                  color: const Color(0xFFEF5350),
                  onTap: () {
                    _mostrarTutorialAsistente(context);
                  },
                ),

                const SizedBox(height: 32),

                // Sección: Miembros de Mesa
                _buildSeccionTitulo('Para Miembros de Mesa'),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.how_to_vote,
                  title: 'Tutorial Paso a Paso',
                  descripcion: 'Guía completa para el día de las elecciones',
                  duracion: '15 min',
                  color: const Color(0xFFE53935),
                  destacado: true,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TutorialMiembroMesaScreen(),
                      ),
                    );
                    // Otorgar puntos al completar
                    await _completarTutorial('miembro_mesa', 'Miembro de Mesa');
                  },
                ),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.play_circle_filled,
                  title: 'Video: Beneficios',
                  descripcion: 'Conoce tus derechos y compensación económica',
                  duracion: '8 min',
                  color: const Color(0xFFD32F2F),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoBeneficiosScreen(),
                      ),
                    );
                    // Otorgar puntos al completar
                    await _completarTutorial('beneficios', 'Beneficios de Participar');
                  },
                ),

                const SizedBox(height: 32),

                // Sección: Proceso Electoral
                _buildSeccionTitulo('Proceso Electoral'),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.ballot,
                  title: 'Cómo votar correctamente',
                  descripcion: 'Paso a paso para emitir tu voto válido',
                  duracion: '4 min',
                  color: const Color(0xFFE53935),
                  onTap: () {
                    _mostrarTutorialVotar(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.location_on,
                  title: 'Encontrar tu local de votación',
                  descripcion: 'Ubica dónde te toca votar y cómo llegar',
                  duracion: '3 min',
                  color: const Color(0xFFD32F2F),
                  onTap: () {
                    _mostrarTutorialLocal(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildTutorialCard(
                  context: context,
                  icon: Icons.calendar_today,
                  title: 'Fechas importantes',
                  descripcion: 'Calendario electoral y plazos clave',
                  duracion: '2 min',
                  color: const Color(0xFFEF5350),
                  onTap: () {
                    _mostrarTutorialFechas(context);
                  },
                ),

                const SizedBox(height: 32),

                // Banner de ayuda
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE53935),
                        Color(0xFFEF5350),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '¿Necesitas más ayuda?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Usa el Asistente Electoral para hacer preguntas específicas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar al chat (índice 1 en la navegación)
                          Navigator.pop(context);
                          // Aquí podrías usar un callback o estado global para cambiar a la pestaña del chat
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Ir al Asistente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String descripcion,
    required String duracion,
    required Color color,
    required VoidCallback onTap,
    bool destacado = false,
  }) {
    return Card(
      elevation: destacado ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: destacado ? color : color.withOpacity(0.3),
          width: destacado ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duracion,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (destacado) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'DESTACADO',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos para mostrar tutoriales (puedes expandirlos después)
  void _mostrarTutorialApp(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Cómo usar la app',
      '1. Navega usando el menú inferior\n'
      '2. Explora precandidatos y planes de gobierno\n'
      '3. Usa el asistente para preguntas\n'
      '4. Consulta tu local de votación\n'
      '5. Revisa el calendario electoral',
    );
  }

  void _mostrarTutorialBusqueda(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Buscar información',
      '1. Usa la barra de búsqueda en cada sección\n'
      '2. Filtra por partido político\n'
      '3. Compara planes de gobierno\n'
      '4. Lee biografías de precandidatos\n'
      '5. Guarda tus favoritos',
    );
  }

  void _mostrarTutorialAsistente(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Asistente Electoral',
      '1. Toca el ícono de chat en el menú\n'
      '2. Escribe tu pregunta\n'
      '3. Recibe respuestas instantáneas\n'
      '4. Crea múltiples conversaciones\n'
      '5. Accede al historial sin internet',
    );
  }

  void _mostrarTutorialVotar(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Cómo votar',
      '1. Llega temprano a tu local\n'
      '2. Presenta tu DNI\n'
      '3. Recibe tu cédula de votación\n'
      '4. Marca con X o aspa tu preferencia\n'
      '5. Deposita en el ánfora\n'
      '6. Firma el padrón electoral',
    );
  }

  void _mostrarTutorialLocal(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Encontrar tu local',
      '1. Ve a "Mi Local" en el menú\n'
      '2. Ingresa tu DNI\n'
      '3. Consulta tu local asignado\n'
      '4. Revisa la dirección\n'
      '5. Usa el mapa para llegar',
    );
  }

  void _mostrarTutorialFechas(BuildContext context) {
    _mostrarDialogoTutorial(
      context,
      'Fechas importantes',
      '• Primera vuelta: 13 de abril de 2026\n'
      '• Segunda vuelta (si aplica): 7 de junio de 2026\n'
      '• Cierre de inscripciones: Consulta el calendario\n'
      '• Debates presidenciales: Por confirmar\n'
      '• Veda electoral: 2 días antes',
    );
  }

  void _mostrarDialogoTutorial(BuildContext context, String titulo, String contenido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFE53935)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(titulo),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            contenido,
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }
}
