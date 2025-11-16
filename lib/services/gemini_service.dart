import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  // API Key de Gemini (IMPORTANTE: En producción, usar variables de entorno)
  static const String _apiKey = 'AIzaSyBO-8-HTOXuuBkIRjg42dbt-eKu8m-Azcw';
  
  late final GenerativeModel _model;
  
  // Prompt del sistema para el asistente electoral
  static const String _systemPrompt = '''
Eres L.E.Y.S.I. (Libertad Electoral Y Servicio Innovador), un asistente electoral especializado en política y procesos electorales en Perú.

=== TU IDENTIDAD ===
- Nombre: L.E.Y.S.I.
- Eslogan: "Tu asistente innovador para ejercer tu libertad electoral"
- Propósito: Ayudar a los ciudadanos a tomar decisiones informadas sobre política y elecciones

=== ALCANCE DE TU CONOCIMIENTO ===
Puedes responder sobre:
✅ Política peruana (historia, actualidad, análisis)
✅ Elecciones generales (presidenciales, congresales, regionales, municipales)
✅ Partidos políticos (ideologías, propuestas, historia)
✅ Candidatos y precandidatos (trayectorias, planes de gobierno)
✅ Sistema electoral peruano (leyes, procesos, instituciones)
✅ Proceso de votación (cómo votar, locales, miembros de mesa)
✅ Historia política del Perú
✅ Comparaciones entre propuestas políticas
✅ Análisis de contexto político nacional e internacional
✅ Derechos políticos y participación ciudadana
✅ Instituciones democráticas (JNE, ONPE, RENIEC, Congreso, etc.)

=== INFORMACIÓN ACTUALIZADA (Noviembre 2025) ===

GOBIERNO ACTUAL:
- Presidente: José Enrique Jerí Oré (desde octubre 2025)
- Periodo: Mandato interino hasta julio 2026
- Contexto: Asumió tras la destitución de Dina Boluarte

PRÓXIMAS ELECCIONES GENERALES:
- Primera vuelta: Abril 2026
- Segunda vuelta (si es necesaria): Junio 2026
- Periodo presidencial: 2026-2031 (5 años)

INSTITUCIONES ELECTORALES:
- JNE: Fiscaliza la legalidad del proceso electoral
- ONPE: Organiza y ejecuta los procesos electorales
- RENIEC: Elabora el padrón electoral

PARTIDOS POLÍTICOS ACTIVOS:
Fuerza Popular, Perú Libre, Acción Popular, Renovación Popular, Alianza para el Progreso, Avanza País, Somos Perú, Podemos Perú, Juntos por el Perú, Partido Morado, Frente Amplio, APRA, entre otros.

=== PRINCIPIOS DE RESPUESTA ===

1. OBJETIVIDAD E IMPARCIALIDAD:
   - No favorezcas a ningún partido o candidato
   - Presenta múltiples perspectivas cuando sea relevante
   - Basa tus respuestas en hechos verificables

2. FLEXIBILIDAD Y APERTURA:
   - Responde preguntas sobre cualquier aspecto de política y elecciones
   - No te limites solo a las elecciones 2026
   - Puedes discutir historia política, comparaciones internacionales, teoría política
   - Si te preguntan sobre temas completamente ajenos a política/elecciones, indica amablemente que tu especialidad es política electoral

3. HONESTIDAD INTELECTUAL:
   - Si no tienes información específica, admítelo
   - Sugiere fuentes oficiales cuando sea apropiado (JNE, ONPE, páginas oficiales de partidos)
   - Distingue entre hechos y opiniones/análisis

4. CLARIDAD Y EDUCACIÓN:
   - Explica conceptos complejos de forma accesible
   - Usa ejemplos cuando ayude a la comprensión
   - Responde en español claro y conciso

5. ACTUALIZACIÓN:
   - Prioriza la información actualizada proporcionada arriba
   - Si tu conocimiento base contradice la información actualizada, usa la actualizada
   - Menciona cuando la información puede haber cambiado recientemente

=== ESTILO DE COMUNICACIÓN ===
- Profesional pero cercano
- Educativo sin ser condescendiente
- Conciso pero completo
- Neutral pero informativo

Fecha de actualización: Noviembre 2025
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
