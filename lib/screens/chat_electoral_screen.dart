import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/mensaje_chat.dart';
import '../models/chat_conversation.dart';
import '../services/gemini_service.dart';
import '../services/chat_storage_service.dart';

class ChatElectoralScreen extends StatefulWidget {
  final String? conversacionId;

  const ChatElectoralScreen({
    super.key,
    this.conversacionId,
  });

  @override
  State<ChatElectoralScreen> createState() => _ChatElectoralScreenState();
}

class _ChatElectoralScreenState extends State<ChatElectoralScreen> {
  final GeminiService _geminiService = GeminiService();
  final ChatStorageService _storageService = ChatStorageService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  
  ChatConversation? _conversacionActual;
  List<MensajeChat> _mensajes = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _mensajeReproduciendo;
  bool _sinConexion = false;

  @override
  void initState() {
    super.initState();
    _configurarTts();
    _inicializarConversacion();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _inicializarConversacion() async {
    if (widget.conversacionId != null) {
      // Cargar conversación existente
      final conversaciones = await _storageService.cargarConversaciones();
      _conversacionActual = conversaciones.firstWhere(
        (c) => c.id == widget.conversacionId,
        orElse: () => _crearNuevaConversacion(),
      );
      setState(() {
        _mensajes = List.from(_conversacionActual!.mensajes);
      });
    } else {
      // Nueva conversación
      _conversacionActual = _crearNuevaConversacion();
      _agregarMensajeBienvenida();
    }
  }

  ChatConversation _crearNuevaConversacion() {
    return ChatConversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: 'Nueva conversación',
      fechaCreacion: DateTime.now(),
      ultimaActualizacion: DateTime.now(),
      mensajes: [],
    );
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
      await _flutterTts.stop();
      setState(() {
        _mensajeReproduciendo = null;
      });
    } else {
      await _flutterTts.stop();
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
  }

  Future<void> _guardarConversacion() async {
    if (_conversacionActual == null || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      // Actualizar título si es la primera vez que se guarda
      String titulo = _conversacionActual!.titulo;
      if (titulo == 'Nueva conversación' && _mensajes.length > 1) {
        // Usar el primer mensaje del usuario como título
        final primerMensajeUsuario = _mensajes.firstWhere(
          (m) => m.esUsuario && m.id != 'bienvenida',
          orElse: () => _mensajes.first,
        );
        titulo = ChatConversation.generarTituloAutomatico(primerMensajeUsuario.texto);
      }

      _conversacionActual = _conversacionActual!.copyWith(
        titulo: titulo,
        ultimaActualizacion: DateTime.now(),
        mensajes: _mensajes,
      );

      await _storageService.guardarConversacion(_conversacionActual!);
    } catch (e) {
      print('Error al guardar conversación: $e');
    } finally {
      setState(() => _isSaving = false);
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
      _sinConexion = false;
    });

    _messageController.clear();
    _scrollToBottom();

    // Guardar después de agregar mensaje del usuario
    await _guardarConversacion();

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

      // Guardar después de recibir respuesta
      await _guardarConversacion();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _sinConexion = true;
      });

      // Agregar mensaje de error
      final mensajeError = MensajeChat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: 'Lo siento, no tengo conexión a internet en este momento. '
            'Puedes revisar el historial de conversaciones anteriores mientras tanto.',
        esUsuario: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _mensajes.add(mensajeError);
      });

      _scrollToBottom();
      await _guardarConversacion();
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

  void _mostrarMenuOpciones() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Color(0xFFE53935)),
              title: const Text('Eliminar conversación'),
              onTap: () {
                Navigator.pop(context);
                _confirmarEliminarConversacion();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFFE53935)),
              title: const Text('Acerca del asistente'),
              onTap: () {
                Navigator.pop(context);
                _mostrarInfoAsistente();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminarConversacion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar conversación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta conversación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_conversacionActual != null) {
                await _storageService.eliminarConversacion(_conversacionActual!.id);
              }
              if (mounted) {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context, true); // Volver a lista
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _mostrarInfoAsistente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asistente Electoral'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tu asistente personal para las Elecciones 2026',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Características:'),
              SizedBox(height: 8),
              Text('• Conversaciones guardadas localmente'),
              Text('• Historial accesible sin internet'),
              Text('• Respuestas sobre el proceso electoral'),
              Text('• Información de candidatos y partidos'),
              Text('• Lectura de mensajes con voz'),
              SizedBox(height: 16),
              Text(
                'Nota: Se requiere conexión a internet para enviar nuevas preguntas.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_conversacionActual?.titulo ?? 'Asistente Electoral'),
            if (_sinConexion)
              const Text(
                'Sin conexión',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _mostrarMenuOpciones,
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
                      color: Color(0xFFE53935),
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
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
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
                        ? const Color(0xFFE53935)
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
                            ? const Color(0xFFE53935).withOpacity(0.1)
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
                                ? const Color(0xFFE53935)
                                : Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            estaReproduciendo ? 'Detener' : 'Escuchar',
                            style: TextStyle(
                              fontSize: 12,
                              color: estaReproduciendo
                                  ? const Color(0xFFE53935)
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
