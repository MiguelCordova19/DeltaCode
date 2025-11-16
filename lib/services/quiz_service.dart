import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz.dart';

class QuizService {
  static const String _keyResultados = 'quiz_resultados';
  static const int PUNTOS_RESPUESTA_CORRECTA = 10;
  static const int PUNTOS_RESPUESTA_INCORRECTA = -5;
  static const int PUNTOS_POR_MONEDA = 10;
  static const Duration COOLDOWN_DURATION = Duration(hours: 1);

  // Guardar resultado de quiz
  Future<void> guardarResultado(ResultadoQuiz resultado) async {
    final prefs = await SharedPreferences.getInstance();
    final resultadosJson = prefs.getString(_keyResultados) ?? '[]';
    final List<dynamic> resultados = json.decode(resultadosJson);
    
    // Buscar si ya existe un resultado para este quiz
    final index = resultados.indexWhere((r) => r['quizId'] == resultado.quizId);
    
    if (index != -1) {
      // Actualizar resultado existente
      resultados[index] = resultado.toJson();
    } else {
      // Agregar nuevo resultado
      resultados.add(resultado.toJson());
    }
    
    await prefs.setString(_keyResultados, json.encode(resultados));
  }

  // Obtener resultado de un quiz específico
  Future<ResultadoQuiz?> obtenerResultado(String quizId) async {
    final prefs = await SharedPreferences.getInstance();
    final resultadosJson = prefs.getString(_keyResultados) ?? '[]';
    final List<dynamic> resultados = json.decode(resultadosJson);
    
    final resultado = resultados.firstWhere(
      (r) => r['quizId'] == quizId,
      orElse: () => null,
    );
    
    if (resultado != null) {
      return ResultadoQuiz.fromJson(resultado);
    }
    return null;
  }

  // Verificar si el quiz está disponible (cooldown)
  Future<bool> quizDisponible(String quizId) async {
    final resultado = await obtenerResultado(quizId);
    
    if (resultado == null) {
      return true; // Primera vez, disponible
    }
    
    if (resultado.proximoIntentoDisponible == null) {
      return true;
    }
    
    return DateTime.now().isAfter(resultado.proximoIntentoDisponible!);
  }

  // Obtener tiempo restante para próximo intento
  Future<Duration?> tiempoRestanteCooldown(String quizId) async {
    final resultado = await obtenerResultado(quizId);
    
    if (resultado?.proximoIntentoDisponible == null) {
      return null;
    }
    
    final ahora = DateTime.now();
    if (ahora.isAfter(resultado!.proximoIntentoDisponible!)) {
      return null;
    }
    
    return resultado.proximoIntentoDisponible!.difference(ahora);
  }

  // Calcular puntos y monedas
  ResultadoQuiz calcularResultado({
    required String quizId,
    required int respuestasCorrectas,
    required int respuestasIncorrectas,
  }) {
    final puntos = (respuestasCorrectas * PUNTOS_RESPUESTA_CORRECTA) +
        (respuestasIncorrectas * PUNTOS_RESPUESTA_INCORRECTA);
    
    final puntosFinales = puntos < 0 ? 0 : puntos;
    final monedas = (puntosFinales / PUNTOS_POR_MONEDA).floor();
    
    final ahora = DateTime.now();
    final proximoIntento = ahora.add(COOLDOWN_DURATION);
    
    return ResultadoQuiz(
      quizId: quizId,
      puntosObtenidos: puntosFinales,
      monedasGanadas: monedas,
      respuestasCorrectas: respuestasCorrectas,
      respuestasIncorrectas: respuestasIncorrectas,
      fechaCompletado: ahora,
      proximoIntentoDisponible: proximoIntento,
    );
  }

  // Obtener todos los resultados
  Future<List<ResultadoQuiz>> obtenerTodosLosResultados() async {
    final prefs = await SharedPreferences.getInstance();
    final resultadosJson = prefs.getString(_keyResultados) ?? '[]';
    final List<dynamic> resultados = json.decode(resultadosJson);
    
    return resultados.map((r) => ResultadoQuiz.fromJson(r)).toList();
  }

  // Obtener estadísticas generales
  Future<Map<String, dynamic>> obtenerEstadisticas() async {
    final resultados = await obtenerTodosLosResultados();
    
    if (resultados.isEmpty) {
      return {
        'quizzesCompletados': 0,
        'totalMonedas': 0,
        'totalPuntos': 0,
        'promedioAciertos': 0.0,
      };
    }
    
    final totalMonedas = resultados.fold<int>(
      0,
      (sum, r) => sum + r.monedasGanadas,
    );
    
    final totalPuntos = resultados.fold<int>(
      0,
      (sum, r) => sum + r.puntosObtenidos,
    );
    
    final totalCorrectas = resultados.fold<int>(
      0,
      (sum, r) => sum + r.respuestasCorrectas,
    );
    
    final totalPreguntas = resultados.fold<int>(
      0,
      (sum, r) => sum + r.respuestasCorrectas + r.respuestasIncorrectas,
    );
    
    final promedioAciertos = totalPreguntas > 0
        ? (totalCorrectas / totalPreguntas) * 100
        : 0.0;
    
    return {
      'quizzesCompletados': resultados.length,
      'totalMonedas': totalMonedas,
      'totalPuntos': totalPuntos,
      'promedioAciertos': promedioAciertos,
    };
  }
}
