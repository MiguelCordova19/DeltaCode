import 'package:flutter/material.dart';
import '../models/candidato.dart';
import '../models/partido_politico.dart';
import '../services/tts_service.dart';

class CandidatoDetalleScreenConTts extends StatefulWidget {
  final Candidato candidato;
  final PartidoPolitico partido;

  const CandidatoDetalleScreenConTts({
    super.key,
    required this.candidato,
    required this.partido,
  });

  @override
  State<CandidatoDetalleScreenConTts> createState() => _CandidatoDetalleScreenConTtsState();
}

class _CandidatoDetalleScreenConTtsState extends State<CandidatoDetalleScreenConTts> {
  final TtsService _ttsService = TtsService();
  bool _isReading = false;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  void _toggleReading() async {
    if (_isReading) {
      await _ttsService.stop();
      setState(() {
        _isReading = false;
      });
    } else {
      setState(() {
        _isReading = true;
      });
      
      // Leer todo el contenido de la página
      await _ttsService.speakPageContent(
        titulo: '${widget.candidato.cargo}: ${widget.candidato.nombre}',
        subtitulo: 'Partido político: ${widget.partido.nombre}',
        contenido: 'Hoja de Vida: ${widget.candidato.hojaVida}. Biografía: ${widget.candidato.biografia}',
      );
      
      setState(() {
        _isReading = false;
      });
    }
  }

  void _readSection(String title, String content) async {
    await _ttsService.stop();
    setState(() {
      _isReading = true;
    });
    
    await _ttsService.speakPageContent(
      titulo: title,
      contenido: content,
    );
    
    setState(() {
      _isReading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C4DFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Elecciones 2026',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Botón de lectura por voz
          IconButton(
            icon: Icon(
              _isReading ? Icons.stop_circle : Icons.volume_up,
              color: _isReading ? Colors.red : const Color(0xFF7C4DFF),
            ),
            onPressed: _toggleReading,
            tooltip: _isReading ? 'Detener lectura' : 'Leer página',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto grande del candidato
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: _buildCandidatoImage(widget.candidato.fotoPath),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge del cargo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.candidato.cargo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre del candidato
                  Text(
                    widget.candidato.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Partido político
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildPartidoImage(widget.partido.logoPath),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.partido.nombre,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Hoja de Vida con botón de lectura
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hoja de Vida',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 20),
                        color: const Color(0xFF7C4DFF),
                        onPressed: () => _readSection('Hoja de Vida', widget.candidato.hojaVida),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.candidato.hojaVida,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Biografía con botón de lectura
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Biografía',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 20),
                        color: const Color(0xFF7C4DFF),
                        onPressed: () => _readSection('Biografía', widget.candidato.biografia),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.candidato.biografia,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      // Botón flotante para lectura completa
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleReading,
        backgroundColor: _isReading ? Colors.red : const Color(0xFF7C4DFF),
        icon: Icon(_isReading ? Icons.stop : Icons.volume_up),
        label: Text(_isReading ? 'Detener' : 'Leer todo'),
      ),
    );
  }

  Widget _buildCandidatoImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultPersonImage();
      },
    );
  }

  Widget _buildPartidoImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultPartidoLogo();
      },
    );
  }

  Widget _buildDefaultPersonImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.person,
          size: 120,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDefaultPartidoLogo() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.account_balance,
        size: 25,
        color: Colors.grey,
      ),
    );
  }
}
