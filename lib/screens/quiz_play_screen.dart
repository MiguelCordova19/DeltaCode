import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _preguntaActual = 0;
  int _respuestasCorrectas = 0;
  int _respuestasIncorrectas = 0;
  int? _respuestaSeleccionada;
  bool _mostrandoResultado = false;
  final QuizService _quizService = QuizService();

  void _responder(int opcion) {
    if (_mostrandoResultado) return;

    setState(() {
      _respuestaSeleccionada = opcion;
      _mostrandoResultado = true;

      if (opcion == widget.quiz.preguntas[_preguntaActual].respuestaCorrecta) {
        _respuestasCorrectas++;
      } else {
        _respuestasIncorrectas++;
      }
    });
  }

  void _siguientePregunta() {
    if (_preguntaActual < widget.quiz.preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
        _respuestaSeleccionada = null;
        _mostrandoResultado = false;
      });
    } else {
      _finalizarQuiz();
    }
  }

  void _finalizarQuiz() {
    final resultado = _quizService.calcularResultado(
      quizId: widget.quiz.id,
      respuestasCorrectas: _respuestasCorrectas,
      respuestasIncorrectas: _respuestasIncorrectas,
    );

    // Mostrar diálogo de resultados
    showDialog(
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
                Colors.indigo[400]!,
                Colors.blue[400]!,
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
                      child: const Center(
                        child: Text(
                          '🎯',
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Quiz Completado!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${resultado.respuestasCorrectas}/${resultado.respuestasCorrectas + resultado.respuestasIncorrectas} respuestas correctas',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${resultado.puntosObtenidos} puntos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Monedas ganadas
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Text(
                      '+${resultado.monedasGanadas} monedas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(resultado);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo[700],
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
    final pregunta = widget.quiz.preguntas[_preguntaActual];
    final esCorrecta = _respuestaSeleccionada == pregunta.respuestaCorrecta;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: Text('${_preguntaActual + 1}/${widget.quiz.preguntas.length}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '✅ $_respuestasCorrectas  ❌ $_respuestasIncorrectas',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progreso
          LinearProgressIndicator(
            value: (_preguntaActual + 1) / widget.quiz.preguntas.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
            minHeight: 6,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pregunta
                  Text(
                    pregunta.pregunta,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Opciones
                  ...List.generate(pregunta.opciones.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildOpcion(index, pregunta, esCorrecta),
                    );
                  }),

                  // Explicación
                  if (_mostrandoResultado) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: esCorrecta ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: esCorrecta ? Colors.green[200]! : Colors.red[200]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                esCorrecta ? Icons.check_circle : Icons.cancel,
                                color: esCorrecta ? Colors.green[700] : Colors.red[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                esCorrecta ? '¡Correcto!' : 'Incorrecto',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: esCorrecta ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            pregunta.explicacion,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Botón siguiente
          if (_mostrandoResultado)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _siguientePregunta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _preguntaActual < widget.quiz.preguntas.length - 1
                        ? 'Siguiente Pregunta'
                        : 'Ver Resultados',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOpcion(int index, Pregunta pregunta, bool esCorrecta) {
    final seleccionada = _respuestaSeleccionada == index;
    final correcta = index == pregunta.respuestaCorrecta;
    
    Color? backgroundColor;
    Color? borderColor;
    
    if (_mostrandoResultado) {
      if (correcta) {
        backgroundColor = Colors.green[50];
        borderColor = Colors.green[400];
      } else if (seleccionada) {
        backgroundColor = Colors.red[50];
        borderColor = Colors.red[400];
      }
    } else if (seleccionada) {
      backgroundColor = const Color(0xFFE53935).withOpacity(0.1);
      borderColor = const Color(0xFFE53935);
    }

    return InkWell(
      onTap: () => _responder(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor ?? Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pregunta.opciones[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (_mostrandoResultado && correcta)
              const Icon(Icons.check_circle, color: Colors.green),
            if (_mostrandoResultado && seleccionada && !correcta)
              const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
