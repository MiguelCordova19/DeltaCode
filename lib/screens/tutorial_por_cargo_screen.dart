import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/miembro_mesa.dart';

class TutorialPorCargoScreen extends StatefulWidget {
  final CargoMesa cargo;

  const TutorialPorCargoScreen({
    super.key,
    required this.cargo,
  });

  @override
  State<TutorialPorCargoScreen> createState() => _TutorialPorCargoScreenState();
}

class _TutorialPorCargoScreenState extends State<TutorialPorCargoScreen> {
  late FlutterTts _flutterTts;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isReading = false;
  String? _readingSection;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage('es-ES');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isReading = false;
          _readingSection = null;
        });
      }
    });
  }

  Future<void> _leerSeccion(String seccion, List<String> items) async {
    if (_isReading && _readingSection == seccion) {
      await _flutterTts.stop();
      setState(() {
        _isReading = false;
        _readingSection = null;
      });
    } else {
      await _flutterTts.stop();
      final texto = '$seccion. ${items.join('. ')}';
      
      setState(() {
        _isReading = true;
        _readingSection = seccion;
      });
      
      await _flutterTts.speak(texto);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutorialData = _getTutorialData(widget.cargo);
    final sections = _buildSections(tutorialData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _getColorByCargo(widget.cargo),
        foregroundColor: Colors.white,
        title: Text('Tutorial: ${_getCargoNombre(widget.cargo)}'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(tutorialData),
          _buildPageIndicator(sections.length),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _isReading = false;
                  _readingSection = null;
                });
                _flutterTts.stop();
              },
              itemCount: sections.length,
              itemBuilder: (context, index) => sections[index],
            ),
          ),
          _buildNavigation(sections.length),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> tutorialData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getColorByCargo(widget.cargo),
            _getColorByCargo(widget.cargo).withOpacity(0.7),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconByCargo(widget.cargo),
              size: 32,
              color: _getColorByCargo(widget.cargo),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCargoNombre(widget.cargo),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tutorialData['descripcion']!,
                  style: const TextStyle(
                    fontSize: 13,
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

  Widget _buildPageIndicator(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? _getColorByCargo(widget.cargo)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSections(Map<String, dynamic> tutorialData) {
    return [
      _buildCardSection(
        'Responsabilidades',
        Icons.assignment_turned_in,
        tutorialData['responsabilidades'] as List<String>,
        _getColorByCargo(widget.cargo),
      ),
      _buildCardSection(
        'Instalación (7:00-8:00 AM)',
        Icons.schedule,
        tutorialData['instalacion'] as List<String>,
        Colors.blue,
      ),
      _buildCardSection(
        'Sufragio (8:00 AM-4:00 PM)',
        Icons.how_to_vote,
        tutorialData['sufragio'] as List<String>,
        Colors.green,
      ),
      _buildCardSection(
        'Escrutinio (4:00 PM+)',
        Icons.bar_chart,
        tutorialData['escrutinio'] as List<String>,
        Colors.orange,
      ),
      _buildConsejosCard(
        tutorialData['consejos'] as List<String>,
        tutorialData['prohibiciones'] as List<String>,
      ),
    ];
  }

  Widget _buildCardSection(String title, IconData icon, List<String> items, Color color) {
    final sectionKey = title;
    final isReading = _isReading && _readingSection == sectionKey;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isReading ? Icons.stop_circle : Icons.volume_up,
                      color: color,
                      size: 28,
                    ),
                    onPressed: () => _leerSeccion(sectionKey, items),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...items.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsejosCard(List<String> consejos, List<String> prohibiciones) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.2),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lightbulb, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Consejos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isReading && _readingSection == 'Consejos'
                              ? Icons.stop_circle
                              : Icons.volume_up,
                          color: Colors.amber,
                          size: 28,
                        ),
                        onPressed: () => _leerSeccion('Consejos', consejos),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...consejos.map((consejo) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 20)),
                            Expanded(
                              child: Text(
                                consejo,
                                style: const TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.warning, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Qué NO Hacer',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isReading && _readingSection == 'Prohibiciones'
                              ? Icons.stop_circle
                              : Icons.volume_up,
                          color: Colors.red,
                          size: 28,
                        ),
                        onPressed: () => _leerSeccion('Prohibiciones', prohibiciones),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...prohibiciones.map((prohibicion) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('❌ ', style: TextStyle(fontSize: 20)),
                            Expanded(
                              child: Text(
                                prohibicion,
                                style: const TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Anterior'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: _getColorByCargo(widget.cargo)),
                    foregroundColor: _getColorByCargo(widget.cargo),
                  ),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _currentPage < totalPages - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : () => Navigator.pop(context),
                icon: Icon(_currentPage < totalPages - 1 ? Icons.arrow_forward : Icons.check),
                label: Text(_currentPage < totalPages - 1 ? 'Siguiente' : 'Finalizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorByCargo(widget.cargo),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getTutorialData(CargoMesa cargo) {
    switch (cargo) {
      case CargoMesa.presidente:
        return {
          'descripcion': 'Líder de la mesa electoral',
          'responsabilidades': [
            'Dirigir y coordinar todas las actividades de la mesa',
            'Representar a la mesa ante las autoridades electorales',
            'Tomar decisiones finales en caso de dudas',
            'Firmar todos los documentos oficiales',
            'Garantizar el orden y la transparencia',
          ],
          'instalacion': [
            'Llega primero (7:00 AM) para recibir los materiales',
            'Verifica que todos los materiales estén completos',
            'Coordina con el secretario y tercer miembro',
            'Muestra el ánfora vacía a todos los presentes',
            'Dirige el sellado del ánfora',
            'Firma el Acta de Instalación primero',
          ],
          'sufragio': [
            'Supervisa que el proceso se realice correctamente',
            'Verifica la identidad de electores en casos dudosos',
            'Resuelve cualquier incidente o duda',
            'Mantiene el orden en la mesa',
            'Coordina con personeros y observadores',
            'Autoriza el voto de electores en situaciones especiales',
          ],
          'escrutinio': [
            'Anuncia el cierre de la votación a las 4:00 PM',
            'Dirige la apertura del ánfora',
            'Lee en voz alta cada voto',
            'Muestra cada cédula a todos los presentes',
            'Resuelve dudas sobre votos válidos, nulos o blancos',
            'Verifica que los totales sean correctos',
            'Firma el Acta de Escrutinio primero',
            'Entrega los documentos a la ODPE',
          ],
          'consejos': [
            'Mantén la calma en todo momento, eres el líder',
            'Sé firme pero amable con todos',
            'Consulta al coordinador de ONPE si tienes dudas',
            'Trabaja en equipo con secretario y tercer miembro',
            'Toma decisiones rápidas pero justas',
          ],
          'prohibiciones': [
            'No abandones la mesa en ningún momento',
            'No delegues tus responsabilidades principales',
            'No tomes decisiones sin consultar casos complejos',
            'No permitas irregularidades',
            'No muestres preferencia por ningún candidato',
          ],
        };
      case CargoMesa.secretario:
        return {
          'descripcion': 'Apoyo administrativo del presidente',
          'responsabilidades': [
            'Apoyar al presidente en tareas administrativas',
            'Verificar la lista de electores',
            'Llenar y completar documentos',
            'Registrar la asistencia de electores',
            'Mantener el orden de los documentos',
          ],
          'instalacion': [
            'Ayuda a recibir y organizar los materiales',
            'Verifica que la lista de electores esté completa',
            'Organiza los útiles de escritorio',
            'Prepara las actas para firmar',
            'Anota los números de los precintos',
            'Firma el Acta de Instalación después del presidente',
          ],
          'sufragio': [
            'Busca el nombre del elector en la lista',
            'Marca la asistencia de cada elector',
            'Entrega la cédula de sufragio',
            'Solicita la firma o huella del elector',
            'Mantiene ordenada la lista de electores',
            'Lleva el conteo de electores que han votado',
          ],
          'escrutinio': [
            'Ayuda a sacar las cédulas del ánfora',
            'Registra cada voto en el acta',
            'Cuenta y agrupa las cédulas por candidato',
            'Verifica que los números coincidan',
            'Llena el Acta de Escrutinio con letra clara',
            'Suma los totales de cada candidato',
            'Firma el acta después del presidente',
          ],
          'consejos': [
            'Ten letra clara y legible para llenar actas',
            'Sé organizado con los documentos',
            'Mantén la lista de electores ordenada',
            'Verifica dos veces antes de escribir',
            'Apoya al presidente en todo momento',
          ],
          'prohibiciones': [
            'No te alejes de la mesa sin avisar',
            'No llenes actas con errores o borrones',
            'No pierdas documentos importantes',
            'No dejes que otros toquen los documentos oficiales',
            'No te distraigas durante el conteo',
          ],
        };
      case CargoMesa.tercerMiembro:
        return {
          'descripcion': 'Apoyo general en todas las tareas',
          'responsabilidades': [
            'Apoyar al presidente y secretario',
            'Reemplazar al secretario si es necesario',
            'Ayudar en todas las tareas de la mesa',
            'Mantener el orden de los materiales',
            'Ser testigo de todo el proceso',
          ],
          'instalacion': [
            'Ayuda a transportar los materiales a la mesa',
            'Organiza el espacio de votación',
            'Prepara la cámara secreta',
            'Verifica que el ánfora esté en buen estado',
            'Ayuda a colocar los precintos de seguridad',
            'Firma el Acta de Instalación al final',
          ],
          'sufragio': [
            'Indica a los electores dónde está la cámara secreta',
            'Mantiene el orden en la cola de votantes',
            'Ayuda a electores con dificultades',
            'Vigila que nadie interfiera con el proceso',
            'Apoya al secretario cuando hay mucha gente',
            'Mantiene limpia y ordenada el área de votación',
          ],
          'escrutinio': [
            'Ayuda a abrir el ánfora',
            'Desdobla las cédulas para que el presidente las lea',
            'Agrupa las cédulas por tipo de voto',
            'Cuenta las cédulas de cada grupo',
            'Verifica que los conteos sean correctos',
            'Ayuda a empacar los materiales al final',
            'Firma el acta al final',
          ],
          'consejos': [
            'Mantente atento a todo lo que pasa',
            'Ofrece ayuda proactivamente',
            'Sé flexible y colaborador',
            'Aprende observando al presidente y secretario',
            'Mantén una actitud positiva todo el día',
          ],
          'prohibiciones': [
            'No te quedes sin hacer nada',
            'No interfieras con las tareas del presidente o secretario',
            'No te ausentes sin avisar',
            'No distraigas a los otros miembros',
            'No tomes decisiones sin consultar',
          ],
        };
      case CargoMesa.suplente:
        return {
          'descripcion': 'Reemplazo en caso de ausencia',
          'responsabilidades': [
            'Estar disponible por si algún titular no llega',
            'Conocer las funciones de todos los cargos',
            'Reemplazar al miembro ausente',
          ],
          'instalacion': [
            'Llega temprano por si te necesitan',
            'Observa cómo se instala la mesa',
            'Prepárate para asumir cualquier cargo',
          ],
          'sufragio': [
            'Si reemplazas a alguien, asume sus funciones',
            'Sigue las instrucciones del presidente',
          ],
          'escrutinio': [
            'Participa activamente en el conteo',
            'Firma el acta si estás reemplazando',
          ],
          'consejos': [
            'Llega temprano aunque seas suplente',
            'Observa y aprende todo el proceso',
          ],
          'prohibiciones': [
            'No te vayas si no te necesitan sin avisar',
            'No asumas que no participarás',
          ],
        };
    }
  }

  String _getCargoNombre(CargoMesa cargo) {
    switch (cargo) {
      case CargoMesa.presidente:
        return 'Presidente de Mesa';
      case CargoMesa.secretario:
        return 'Secretario';
      case CargoMesa.tercerMiembro:
        return 'Tercer Miembro';
      case CargoMesa.suplente:
        return 'Suplente';
    }
  }

  Color _getColorByCargo(CargoMesa cargo) {
    switch (cargo) {
      case CargoMesa.presidente:
        return Colors.purple;
      case CargoMesa.secretario:
        return Colors.blue;
      case CargoMesa.tercerMiembro:
        return Colors.green;
      case CargoMesa.suplente:
        return Colors.orange;
    }
  }

  IconData _getIconByCargo(CargoMesa cargo) {
    switch (cargo) {
      case CargoMesa.presidente:
        return Icons.star;
      case CargoMesa.secretario:
        return Icons.edit_note;
      case CargoMesa.tercerMiembro:
        return Icons.people;
      case CargoMesa.suplente:
        return Icons.person_add;
    }
  }
}
