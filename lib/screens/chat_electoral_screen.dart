import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/mensaje_chat.dart';
import '../services/gemini_service.dart';

class ChatElectoralScreen extends StatefulWidget {
  const ChatElectoralScreen({super.key});

  @override
  State<ChatElectoralScreen> createState() => _ChatElectoralScreenState();
}

class _ChatElectoralScreenState extends State<ChatElectoralScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<MensajeChat> _mensajes = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;
  String? _mensajeReproduciendo;

  @override
  void initState() {
    super.initState();
    _configurarTts();
    _agregarMensajeBienvenida();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }
  
  Future<void> _configurarTts() async {
    await _flutterTts.setLanguage('es-ES');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _mensajeReproduciendo = null;
      });
    });
  }
  
  Future<void> _reproducirMensaje(String mensajeId, String texto) async {
    if (_mensajeReproduciendo == mensajeId) {
      // Si ya está reproduciendo este mensaje, detenerlo
      await _flutterTts.stop();
      setState(() {
        _mensajeReproduciendo = null;
      });
    } else {
      // Detener cualquier reproducción anterior
      await _flutterTts.stop();
      
      // Reproducir el nuevo mensaje
      setState(() {
        _mensajeReproduciendo = mensajeId;
      });
      
      await _flutterTts.speak(texto);
    }
  }

  void _agregarMensajeBienvenida() {
    final mensaje = MensajeChat(
      id: 'bienvenida',
      texto: '¡Hola! 👋 Soy tu asistente electoral para las Elecciones 2026.\n\n'
          'Puedo ayudarte con información sobre:\n'
          '• Partidos políticos y candidatos\n'
          '• Planes de gobierno\n'
          '• Proceso electoral\n'
          '• Locales de votación\n'
          '• Cómo votar correctamente\n\n'
          '¿En qué puedo ayudarte hoy?',
      esUsuario: false,
      timestamp: DateTime.now(),
    );
    setState(() {
      _mensajes.add(mensaje);
    });
    
    // Verificar modelos disponibles
    _verificarModelosDisponibles();
  }
  
  Future<void> _verificarModelosDisponibles() async {
    try {
      final modelos = await _geminiService.listarModelosDisponibles();
      print('=== MODELOS DISPONIBLES ===');
      for (var modelo in modelos) {
        print('- $modelo');
      }
      print('===========================');
      
      if (modelos.isEmpty) {
        print('No se encontraron modelos disponibles');
      }
    } catch (e) {
      print('Error al verificar modelos: $e');
    }
  }

  Future<void> _enviarMensaje() async {
    final texto = _messageController.text.trim();
    if (texto.isEmpty) return;

    // Agregar mensaje del usuario
    final mensajeUsuario = MensajeChat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      texto: texto,
      esUsuario: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _mensajes.add(mensajeUsuario);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Construir historial para contexto
      final historial = <Map<String, String>>[];
      for (var msg in _mensajes.where((m) => m.id != 'bienvenida')) {
        historial.add({
          'role': msg.esUsuario ? 'user' : 'model',
          'content': msg.texto,
        });
      }

      // Obtener respuesta de Gemini
      final respuesta = await _geminiService.enviarMensajeConContexto(
        texto,
        historial,
      );

      // Agregar respuesta del asistente
      final mensajeAsistente = MensajeChat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: respuesta,
        esUsuario: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _mensajes.add(mensajeAsistente);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _mostrarDialogoApiKey() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar API Key'),
        content: const Text(
          'Para usar el asistente electoral, necesitas configurar tu API Key de Google Gemini.\n\n'
          '1. Ve a https://makersuite.google.com/app/apikey\n'
          '2. Crea una API key gratuita\n'
          '3. Copia la key en el archivo lib/services/gemini_service.dart\n\n'
          'Gemini Flash es completamente gratuito.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _limpiarChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar conversación'),
        content: const Text('¿Estás seguro de que deseas limpiar toda la conversación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mensajes.clear();
                _agregarMensajeBienvenida();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asistente Electoral'),
            Text(
              'Elecciones 2026',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _limpiarChat,
            tooltip: 'Limpiar conversación',
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = _mensajes[index];
                return _MensajeBubble(
                  mensaje: mensaje,
                  estaReproduciendo: _mensajeReproduciendo == mensaje.id,
                  onReproducir: mensaje.esUsuario 
                      ? null 
                      : () => _reproducirMensaje(mensaje.id, mensaje.texto),
                );
              },
            ),
          ),

          // Indicador de carga
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Escribiendo...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          // Campo de entrada
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Pregunta sobre las elecciones...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _enviarMensaje(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C4DFF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _isLoading ? null : _enviarMensaje,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeBubble extends StatelessWidget {
  final MensajeChat mensaje;
  final bool estaReproduciendo;
  final VoidCallback? onReproducir;

  const _MensajeBubble({
    required this.mensaje,
    this.estaReproduciendo = false,
    this.onReproducir,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            mensaje.esUsuario ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mensaje.esUsuario) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7C4DFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: mensaje.esUsuario 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: mensaje.esUsuario
                        ? const Color(0xFF7C4DFF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    mensaje.texto,
                    style: TextStyle(
                      color: mensaje.esUsuario ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                // Botón de reproducir solo para mensajes del asistente
                if (!mensaje.esUsuario && onReproducir != null) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: onReproducir,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estaReproduciendo 
                            ? const Color(0xFF7C4DFF).withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            estaReproduciendo ? Icons.stop : Icons.volume_up,
                            size: 16,
                            color: estaReproduciendo 
                                ? const Color(0xFF7C4DFF)
                                : Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            estaReproduciendo ? 'Detener' : 'Escuchar',
                            style: TextStyle(
                              fontSize: 12,
                              color: estaReproduciendo 
                                  ? const Color(0xFF7C4DFF)
                                  : Colors.grey[700],
                              fontWeight: estaReproduciendo 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (mensaje.esUsuario) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.black54,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
