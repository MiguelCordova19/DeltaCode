import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/idioma_service.dart';
import '../providers/idioma_provider.dart';

class ConfiguracionIdiomaScreen extends StatefulWidget {
  const ConfiguracionIdiomaScreen({super.key});

  @override
  State<ConfiguracionIdiomaScreen> createState() => _ConfiguracionIdiomaScreenState();
}

class _ConfiguracionIdiomaScreenState extends State<ConfiguracionIdiomaScreen> {
  final IdiomaService _idiomaService = IdiomaService();
  String _idiomaActual = IdiomaService.ESPANOL;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarIdioma();
  }

  Future<void> _cargarIdioma() async {
    final idioma = await _idiomaService.obtenerIdiomaActual();
    setState(() {
      _idiomaActual = idioma;
      _isLoading = false;
    });
  }

  Future<void> _cambiarIdioma(String nuevoIdioma) async {
    // Cambiar en el provider (actualiza toda la app)
    final idiomaProvider = Provider.of<IdiomaProvider>(context, listen: false);
    await idiomaProvider.cambiarIdioma(nuevoIdioma);
    
    // También guardar en el servicio
    await _idiomaService.cambiarIdioma(nuevoIdioma);
    
    setState(() {
      _idiomaActual = nuevoIdioma;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFFE53935),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nuevoIdioma == IdiomaService.QUECHUA
                      ? 'Simi Tikrasqa'
                      : 'Idioma Cambiado',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            nuevoIdioma == IdiomaService.QUECHUA
                ? 'Kunan Quechuapi rimankichik! Tukuy app kunan Quechuapi kachkan.\n\n(¡Ahora hablas Quechua! Toda la app está ahora en Quechua.)'
                : '¡Ahora hablas Español! Toda la app está ahora en Español.',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                nuevoIdioma == IdiomaService.QUECHUA ? 'Allinmi' : 'Entendido',
                style: const TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Idioma de la Aplicación'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE53935).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Elige el idioma de la aplicación',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Título
                  Row(
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
                      const Text(
                        'Idiomas Disponibles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Español
                  _buildIdiomaCard(
                    titulo: 'Español',
                    subtitulo: 'Spanish',
                    descripcion: 'Idioma principal de la aplicación',
                    icono: '🇵🇪',
                    codigo: IdiomaService.ESPANOL,
                    seleccionado: _idiomaActual == IdiomaService.ESPANOL,
                  ),

                  const SizedBox(height: 16),

                  // Quechua
                  _buildIdiomaCard(
                    titulo: 'Quechua',
                    subtitulo: 'Runasimi',
                    descripcion: 'Lengua originaria del Perú',
                    icono: '🏔️',
                    codigo: IdiomaService.QUECHUA,
                    seleccionado: _idiomaActual == IdiomaService.QUECHUA,
                  ),

                  const SizedBox(height: 32),

                  // Nota informativa
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'El cambio de idioma afectará todos los textos de la aplicación. Es posible que necesites reiniciar la app para ver todos los cambios.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nota sobre audio en Quechua
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE53935).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.volume_up,
                          color: Color(0xFFE53935),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nota sobre audio: Actualmente, la lectura de voz (TTS) solo está disponible en español. Los textos en Quechua se mostrarán correctamente, pero el audio será en español.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildIdiomaCard({
    required String titulo,
    required String subtitulo,
    required String descripcion,
    required String icono,
    required String codigo,
    required bool seleccionado,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: seleccionado
            ? [
                BoxShadow(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                  spreadRadius: -6,
                ),
              ]
            : [
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
          onTap: () => _cambiarIdioma(codigo),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: seleccionado 
                  ? const Color(0xFFE53935).withOpacity(0.1) 
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: seleccionado 
                    ? const Color(0xFFE53935) 
                    : Colors.grey.withOpacity(0.3),
                width: seleccionado ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Ícono con efecto 3D
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: seleccionado
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE53935),
                              Color(0xFFD32F2F),
                            ],
                          )
                        : null,
                    color: seleccionado ? null : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: seleccionado
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                              spreadRadius: -3,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      icono,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: seleccionado 
                              ? const Color(0xFFE53935) 
                              : const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        descripcion,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Checkmark
                if (seleccionado)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
