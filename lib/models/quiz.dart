class Quiz {
  final String id;
  final String titulo;
  final String descripcion;
  final String presidenteRelacionado;
  final List<Pregunta> preguntas;
  final bool requiereHistoriaVista;

  Quiz({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.presidenteRelacionado,
    required this.preguntas,
    this.requiereHistoriaVista = true,
  });
}

class Pregunta {
  final String pregunta;
  final List<String> opciones;
  final int respuestaCorrecta; // Índice de la respuesta correcta (0-3)
  final String explicacion;

  Pregunta({
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
    required this.explicacion,
  });
}

class ResultadoQuiz {
  final String quizId;
  final int puntosObtenidos;
  final int monedasGanadas;
  final int respuestasCorrectas;
  final int respuestasIncorrectas;
  final DateTime fechaCompletado;
  final DateTime? proximoIntentoDisponible;

  ResultadoQuiz({
    required this.quizId,
    required this.puntosObtenidos,
    required this.monedasGanadas,
    required this.respuestasCorrectas,
    required this.respuestasIncorrectas,
    required this.fechaCompletado,
    this.proximoIntentoDisponible,
  });

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'puntosObtenidos': puntosObtenidos,
        'monedasGanadas': monedasGanadas,
        'respuestasCorrectas': respuestasCorrectas,
        'respuestasIncorrectas': respuestasIncorrectas,
        'fechaCompletado': fechaCompletado.toIso8601String(),
        'proximoIntentoDisponible': proximoIntentoDisponible?.toIso8601String(),
      };

  factory ResultadoQuiz.fromJson(Map<String, dynamic> json) => ResultadoQuiz(
        quizId: json['quizId'],
        puntosObtenidos: json['puntosObtenidos'],
        monedasGanadas: json['monedasGanadas'],
        respuestasCorrectas: json['respuestasCorrectas'],
        respuestasIncorrectas: json['respuestasIncorrectas'],
        fechaCompletado: DateTime.parse(json['fechaCompletado']),
        proximoIntentoDisponible: json['proximoIntentoDisponible'] != null
            ? DateTime.parse(json['proximoIntentoDisponible'])
            : null,
      );
}
