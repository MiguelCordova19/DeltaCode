import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  // API Key de Gemini (IMPORTANTE: En producción, usar variables de entorno)
  static const String _apiKey = 'AIzaSyBO-8-HTOXuuBkIRjg42dbt-eKu8m-Azcw';
  
  late final GenerativeModel _model;
  
  // Prompt del sistema para limitar las respuestas a temas electorales
  static const String _systemPrompt = '''
Eres un asistente electoral especializado en las Elecciones Presidenciales de Perú 2026. 

=== INFORMACIÓN ACTUALIZADA SOBRE ELECCIONES 2026 ===

GOBIERNO ACTUAL (Actualizado a Noviembre 2024):
- Presidente actual: José Jeri (desde noviembre 2024)
- Periodo: 2024-2026
- Nota: Asumió recientemente la presidencia

FECHAS IMPORTANTES ELECCIONES 2026:
- Primera vuelta: Abril 2026
- Segunda vuelta (si es necesaria): Junio 2026
- Inscripción de candidatos: Enero-Febrero 2026
- Debates presidenciales: Marzo 2026

INSTITUCIONES ELECTORALES:
- JNE (Jurado Nacional de Elecciones): Organismo encargado de fiscalizar la legalidad del proceso electoral
- ONPE (Oficina Nacional de Procesos Electorales): Organiza y ejecuta los procesos electorales
- RENIEC (Registro Nacional de Identificación y Estado Civil): Elabora el padrón electoral

PARTIDOS POLÍTICOS PRINCIPALES EN PERÚ:
- Fuerza Popular (líder: Keiko Fujimori)
- Perú Libre (izquierda)
- Acción Popular (centro-derecha, fundado por Fernando Belaúnde Terry)
- Renovación Popular (líder: Rafael López Aliaga)
- Alianza para el Progreso (líder: César Acuña)
- Avanza País
- Somos Perú
- Podemos Perú
- Juntos por el Perú
- Partido Morado
- Frente Amplio
- APRA (Partido Aprista Peruano)
- Ahora Nación

PROCESO DE VOTACIÓN:
1. Verificar tu local de votación en la web de ONPE
2. Llevar DNI vigente el día de las elecciones
3. Votar es obligatorio para mayores de 18 años
4. El voto es secreto y personal
5. Se vota para Presidente, Vicepresidentes y Congresistas

MIEMBROS DE MESA:
- Son ciudadanos sorteados por ONPE
- Tienen derecho a permiso laboral remunerado
- Reciben una compensación económica
- Deben estar presentes desde la apertura hasta el cierre de la mesa

SISTEMA ELECTORAL PERUANO:
- Sistema presidencial con dos vueltas
- Si ningún candidato obtiene más del 50% en primera vuelta, hay segunda vuelta
- Se eligen 130 congresistas
- Periodo presidencial: 5 años (2026-2031)

CONTEXTO POLÍTICO RECIENTE:
- José Jeri es el actual presidente de Perú (desde noviembre 2025)
- Asumió recientemente la presidencia
- Las próximas elecciones presidenciales serán en 2026
- El periodo presidencial actual termina en julio 2026
- Presidentes recientes: Pedro Castillo (2021-2022), Dina Boluarte (2022-2025), José Jeri (2025-presente)

===

IMPORTANTE: 
- Solo responde preguntas relacionadas con elecciones, política electoral peruana y temas relacionados.
- Si te preguntan sobre otros temas, responde: "Lo siento, solo puedo ayudarte con información sobre las Elecciones 2026 y temas electorales en Perú."
- Sé objetivo, imparcial y no favorezcas a ningún partido político.
- USA SIEMPRE la información actualizada proporcionada arriba, especialmente sobre el gobierno actual.
- Si tu conocimiento base contradice la información actualizada arriba, PRIORIZA la información actualizada.
- El presidente actual de Perú es José Jeri (desde noviembre 2025).
- NO menciones a Dina Boluarte o Pedro Castillo como presidentes actuales, ellos ya no están en el cargo.
- Si no tienes información específica sobre un candidato o propuesta, admítelo y sugiere consultar fuentes oficiales.
- Responde en español de forma clara, concisa y educativa.
- Fecha de actualización de esta información: Noviembre 2025.
''';

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  // Enviar mensaje y obtener respuesta
  Future<String> enviarMensaje(String mensaje) async {
    try {
      // Agregar el system prompt al inicio del mensaje
      final mensajeConContexto = '$_systemPrompt\n\nUsuario: $mensaje';
      final content = [Content.text(mensajeConContexto)];
      final response = await _model.generateContent(content);
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'Lo siento, no pude generar una respuesta. Por favor, intenta reformular tu pregunta.';
      }
    } catch (e) {
      // Log del error completo para debugging
      print('Error completo en Gemini: $e');
      print('Tipo de error: ${e.runtimeType}');
      
      final errorStr = e.toString();
      
      if (errorStr.contains('API_KEY_INVALID') || errorStr.contains('invalid')) {
        return 'Error: La API key parece ser inválida. Verifica que esté correcta.';
      } else if (errorStr.contains('quota') || errorStr.contains('limit')) {
        return 'Error: Límite de solicitudes excedido. Intenta más tarde.';
      } else if (errorStr.contains('network') || errorStr.contains('connection')) {
        return 'Error de conexión. Verifica tu internet.';
      }
      
      return 'Error: $errorStr';
    }
  }

  // Enviar mensaje con contexto de conversación
  Future<String> enviarMensajeConContexto(
    String mensaje,
    List<Map<String, String>> historial,
  ) async {
    try {
      // Construir el prompt con el system prompt y el historial
      final StringBuffer promptCompleto = StringBuffer();
      promptCompleto.writeln(_systemPrompt);
      promptCompleto.writeln('\n--- Conversación ---\n');
      
      // Agregar historial (solo los últimos 10 mensajes para no exceder límites)
      final historialReciente = historial.length > 10 
          ? historial.sublist(historial.length - 10) 
          : historial;
      
      for (var msg in historialReciente) {
        if (msg['role'] == 'user') {
          promptCompleto.writeln('Usuario: ${msg['content']}');
        } else {
          promptCompleto.writeln('Asistente: ${msg['content']}');
        }
      }
      
      // Agregar el mensaje actual
      promptCompleto.writeln('\nUsuario: $mensaje');
      promptCompleto.writeln('\nAsistente:');
      
      final content = [Content.text(promptCompleto.toString())];
      final response = await _model.generateContent(content);
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'Lo siento, no pude generar una respuesta. Por favor, intenta reformular tu pregunta.';
      }
    } catch (e) {
      // Log del error para debugging
      print('Error en Gemini: $e');
      
      if (e.toString().contains('API_KEY_INVALID') || 
          e.toString().contains('API key not valid')) {
        return 'Error: La API key no es válida. Por favor, verifica tu API key de Gemini.';
      } else if (e.toString().contains('quota')) {
        return 'Error: Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.';
      } else if (e.toString().contains('network') || 
                 e.toString().contains('connection')) {
        return 'Error de conexión. Por favor, verifica tu conexión a internet.';
      }
      
      return 'Lo siento, ocurrió un error: ${e.toString()}';
    }
  }

  // Verificar si la API key está configurada
  bool isApiKeyConfigured() {
    // La API key ya está configurada correctamente
    return true;
  }
  
  // Listar modelos disponibles
  Future<List<String>> listarModelosDisponibles() async {
    try {
      final url = 'https://generativelanguage.googleapis.com/v1/models?key=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final modelos = <String>[];
        
        if (data['models'] != null) {
          for (var model in data['models']) {
            final nombre = model['name'] as String;
            final metodos = model['supportedGenerationMethods'] as List?;
            
            // Solo mostrar modelos que soporten generateContent
            if (metodos != null && metodos.contains('generateContent')) {
              modelos.add(nombre.replaceAll('models/', ''));
            }
          }
        }
        
        return modelos;
      } else {
        print('Error al listar modelos: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error al listar modelos: $e');
      return [];
    }
  }
  
  // Verificar conexión a internet
  Future<void> verificarConexion() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode != 200) {
        throw Exception('Sin conexión');
      }
    } catch (e) {
      throw Exception('Sin conexión a internet');
    }
  }
}
