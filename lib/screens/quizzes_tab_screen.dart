import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../data/quizzes_data.dart';
import '../services/quiz_service.dart';
import '../services/gamificacion_service.dart';
import 'quiz_play_screen.dart';

class QuizzesTabScreen extends StatefulWidget {
  final Set<int> visitedYears;
  final List<dynamic> presidentes;

  const QuizzesTabScreen({
    super.key,
    required this.visitedYears,
    required this.presidentes,
  });

  @override
  State<QuizzesTabScreen> createState() => _QuizzesTabScreenState();
}

class _QuizzesTabScreenState extends State<QuizzesTabScreen> {
  final QuizService _quizService = QuizService();
  final GamificacionService _gamificacionService = GamificacionService();
  Map<String, ResultadoQuiz?> _resultados = {};
  Map<String, Duration?> _cooldowns = {};

  @override
  void initState() {
    super.initState();
    _cargarResultados();
  }

  Future<void> _cargarResultados() async {
    final quizzes = QuizzesData.obtenerQuizzes();
    final Map<String, ResultadoQuiz?> resultados = {};
    final Map<String, Duration?> cooldowns = {};

    for (var quiz in quizzes) {
      resultados[quiz.id] = await _quizService.obtenerResultado(quiz.id);
      cooldowns[quiz.id] = await _quizService.tiempoRestanteCooldown(quiz.id);
    }

    if (mounted) {
      setState(() {
        _resultados = resultados;
        _cooldowns = cooldowns;
      });
    }
  }

  bool _quizDesbloqueado(Quiz quiz) {
    // Buscar el índice del presidente relacionado
    final index = widget.presidentes.indexWhere(
      (p) => p.nombre == quiz.presidenteRelacionado,
    );
    
    if (index == -1) return false;
    return widget.visitedYears.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = QuizzesData.obtenerQuizzes();

    return Container(
      color: const Color(0xFFF5F5F5),
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE53935).withOpacity(0.1),
                    const Color(0xFFD32F2F).withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE53935).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.quiz,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quizzes Electorales',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pon a prueba tus conocimientos y gana monedas',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Información del sistema
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Cómo funciona',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('✅ Respuesta correcta: +10 puntos'),
                    _buildInfoRow('❌ Respuesta incorrecta: -5 puntos'),
                    _buildInfoRow('🪙 Cada 10 puntos = 1 moneda'),
                    _buildInfoRow('⏰ Espera 1 hora para reintentar'),
                  ],
                ),
              ),
            ),
          ),

          // Lista de quizzes
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final quiz = quizzes[index];
                  final desbloqueado = _quizDesbloqueado(quiz);
                  final resultado = _resultados[quiz.id];
                  final cooldown = _cooldowns[quiz.id];
                  final disponible = cooldown == null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildQuizCard(
                      quiz: quiz,
                      desbloqueado: desbloqueado,
                      resultado: resultado,
                      disponible: disponible,
                      cooldown: cooldown,
                    ),
                  );
                },
                childCount: quizzes.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildQuizCard({
    required Quiz quiz,
    required bool desbloqueado,
    required ResultadoQuiz? resultado,
    required bool disponible,
    Duration? cooldown,
  }) {
    final completado = resultado != null;
    
    return Container(
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
          onTap: desbloqueado && disponible
              ? () => _iniciarQuiz(quiz)
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Ícono de estado
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getStatusColor(desbloqueado, completado, disponible).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getStatusIcon(desbloqueado, completado, disponible),
                        color: _getStatusColor(desbloqueado, completado, disponible),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Información
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.titulo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: desbloqueado ? Colors.black87 : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quiz.descripcion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Estado y estadísticas
                if (!desbloqueado)
                  _buildStatusChip(
                    '🔒 Bloqueado',
                    'Descubre la historia primero',
                    Colors.grey,
                  )
                else if (!disponible && cooldown != null)
                  _buildStatusChip(
                    '⏰ En espera',
                    'Disponible en ${_formatDuration(cooldown)}',
                    Colors.orange,
                  )
                else if (completado)
                  _buildCompletedInfo(resultado!)
                else
                  _buildStatusChip(
                    '✨ Disponible',
                    '${quiz.preguntas.length} preguntas',
                    const Color(0xFFE53935),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedInfo(ResultadoQuiz resultado) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Completado',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                '${resultado.respuestasCorrectas}/${resultado.respuestasCorrectas + resultado.respuestasIncorrectas} correctas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '+${resultado.monedasGanadas}',
                  style: const TextStyle(
                    fontSize: 14,
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

  Color _getStatusColor(bool desbloqueado, bool completado, bool disponible) {
    if (!desbloqueado) return Colors.grey;
    if (completado) return Colors.green;
    if (!disponible) return Colors.orange;
    return const Color(0xFFE53935);
  }

  IconData _getStatusIcon(bool desbloqueado, bool completado, bool disponible) {
    if (!desbloqueado) return Icons.lock;
    if (completado) return Icons.check_circle;
    if (!disponible) return Icons.schedule;
    return Icons.play_circle_outline;
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) return 'menos de 1 min';
    if (duration.inMinutes < 60) return '${duration.inMinutes} min';
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (minutes == 0) return '$hours h';
    return '$hours h $minutes min';
  }

  Future<void> _iniciarQuiz(Quiz quiz) async {
    final resultado = await Navigator.push<ResultadoQuiz>(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPlayScreen(quiz: quiz),
      ),
    );

    if (resultado != null) {
      // Guardar resultado
      await _quizService.guardarResultado(resultado);
      
      // Agregar monedas al sistema de gamificación
      if (resultado.monedasGanadas > 0) {
        await _gamificacionService.agregarPuntos(
          puntos: resultado.monedasGanadas,
          descripcion: 'Completaste el quiz: ${quiz.titulo}',
        );
      }
      
      // Recargar resultados
      await _cargarResultados();
    }
  }
}
