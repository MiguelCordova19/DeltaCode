import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AyudaSoporteScreen extends StatefulWidget {
  const AyudaSoporteScreen({super.key});

  @override
  State<AyudaSoporteScreen> createState() => _AyudaSoporteScreenState();
}

class _AyudaSoporteScreenState extends State<AyudaSoporteScreen> {
  int? _expandedFaqIndex;

  final List<Map<String, String>> _faqs = [
    {
      'pregunta': '¿Cómo puedo saber dónde me toca votar?',
      'respuesta':
          'Puedes consultar tu local de votación en la sección "Mi Local de Votación" desde tu perfil, o visitando la página oficial de la ONPE con tu DNI.',
    },
    {
      'pregunta': '¿Qué documentos necesito para votar?',
      'respuesta':
          'Solo necesitas tu DNI original y vigente. No se aceptan copias ni documentos vencidos.',
    },
    {
      'pregunta': '¿Qué pasa si no voto?',
      'respuesta':
          'Si no votas y no tienes una justificación válida, deberás pagar una multa. El monto varía según tu distrito (aproximadamente S/ 92.00).',
    },
    {
      'pregunta': '¿Cómo marco correctamente mi voto?',
      'respuesta':
          'Marca con una X o aspa (✗) dentro del recuadro de tu candidato preferido. Solo marca UNA opción por cédula. No hagas marcas adicionales.',
    },
    {
      'pregunta': '¿Qué es un voto en blanco?',
      'respuesta':
          'Es cuando no marcas ninguna opción en la cédula. Es un voto válido que se cuenta en las estadísticas.',
    },
    {
      'pregunta': '¿Qué es un voto nulo?',
      'respuesta':
          'Es cuando marcas más de una opción, escribes en la cédula o la dañas. Este voto no se cuenta.',
    },
    {
      'pregunta': '¿Puedo votar si estoy en el extranjero?',
      'respuesta':
          'Sí, si te registraste a tiempo. Debes inscribirte en el consulado peruano de tu país antes de la fecha límite.',
    },
    {
      'pregunta': '¿Qué hago si me toca ser miembro de mesa?',
      'respuesta':
          'Es obligatorio asistir. Recibirás capacitación gratuita y una remuneración. Si no puedes asistir, debes presentar una excusa válida.',
    },
    {
      'pregunta': '¿Cómo puedo justificar mi inasistencia?',
      'respuesta':
          'Puedes justificar tu inasistencia por enfermedad, viaje, o vivir lejos del local. Debes presentar documentos que lo sustenten.',
    },
    {
      'pregunta': '¿Dónde puedo ver los planes de gobierno?',
      'respuesta':
          'En esta app, ve a la sección "Planes de Gobierno" desde el menú principal. También puedes consultarlos en la página del JNE.',
    },
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _enviarEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Soporte - Elecciones 2026',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _llamarTelefono(String telefono) async {
    final uri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Ayuda y Soporte'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7C4DFF),
                    const Color(0xFF7C4DFF).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Necesitas ayuda?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Estamos aquí para ayudarte',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Acciones rápidas
            _buildSectionTitle('Acciones Rápidas'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.phone,
                    label: 'Llamar',
                    color: Colors.green,
                    onTap: () => _mostrarOpcionesLlamada(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.email,
                    label: 'Email',
                    color: Colors.blue,
                    onTap: () => _enviarEmail('soporte@elecciones2026.pe'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.chat,
                    label: 'Chat',
                    color: Colors.purple,
                    onTap: () => _mostrarProximamente(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Preguntas Frecuentes
            _buildSectionTitle('Preguntas Frecuentes'),
            const SizedBox(height: 12),
            ..._faqs.asMap().entries.map((entry) {
              return _buildFaqItem(
                entry.key,
                entry.value['pregunta']!,
                entry.value['respuesta']!,
              );
            }).toList(),
            const SizedBox(height: 24),

            // Tutoriales
            _buildSectionTitle('Tutoriales'),
            const SizedBox(height: 12),
            _buildTutorialCard(
              icon: Icons.how_to_vote,
              title: 'Cómo votar correctamente',
              description: 'Aprende el proceso paso a paso',
              color: const Color(0xFF7C4DFF),
              onTap: () => _mostrarTutorial(context, 'votar'),
            ),
            const SizedBox(height: 12),
            _buildTutorialCard(
              icon: Icons.location_on,
              title: 'Encontrar mi local de votación',
              description: 'Ubica tu local asignado',
              color: Colors.blue,
              onTap: () => _mostrarTutorial(context, 'local'),
            ),
            const SizedBox(height: 12),
            _buildTutorialCard(
              icon: Icons.people,
              title: 'Ser miembro de mesa',
              description: 'Conoce tus responsabilidades',
              color: Colors.orange,
              onTap: () => _mostrarTutorial(context, 'miembro'),
            ),
            const SizedBox(height: 24),

            // Contacto con Organismos
            _buildSectionTitle('Contacto con Organismos Electorales'),
            const SizedBox(height: 12),
            _buildContactCard(
              logo: '⚖️',
              nombre: 'JNE - Jurado Nacional de Elecciones',
              telefono: '311-1700',
              web: 'https://www.jne.gob.pe',
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              logo: '🗳️',
              nombre: 'ONPE - Oficina Nacional de Procesos Electorales',
              telefono: '311-4700',
              web: 'https://www.onpe.gob.pe',
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              logo: '🆔',
              nombre: 'RENIEC - Registro Nacional de Identificación',
              telefono: '315-2700',
              web: 'https://www.reniec.gob.pe',
            ),
            const SizedBox(height: 24),

            // Reportar problema
            _buildSectionTitle('Reportar un Problema'),
            const SizedBox(height: 12),
            _buildReportCard(
              icon: Icons.bug_report,
              title: 'Reportar un error',
              description: 'Ayúdanos a mejorar la app',
              onTap: () => _mostrarFormularioReporte(context, 'error'),
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              icon: Icons.feedback,
              title: 'Enviar sugerencia',
              description: 'Comparte tus ideas',
              onTap: () => _mostrarFormularioReporte(context, 'sugerencia'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF7C4DFF),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(int index, String pregunta, String respuesta) {
    final isExpanded = _expandedFaqIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? const Color(0xFF7C4DFF) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedFaqIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF7C4DFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pregunta,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                respuesta,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_outline, color: color, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String logo,
    required String nombre,
    required String telefono,
    required String web,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(logo, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _llamarTelefono(telefono),
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(telefono),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchURL(web),
                  icon: const Icon(Icons.language, size: 18),
                  label: const Text('Web'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7C4DFF),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF7C4DFF), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesLlamada(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Llamar a:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('JNE'),
              subtitle: const Text('311-1700'),
              onTap: () {
                Navigator.pop(context);
                _llamarTelefono('3111700');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('ONPE'),
              subtitle: const Text('311-4700'),
              onTap: () {
                Navigator.pop(context);
                _llamarTelefono('3114700');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('RENIEC'),
              subtitle: const Text('315-2700'),
              onTap: () {
                Navigator.pop(context);
                _llamarTelefono('3152700');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarTutorial(BuildContext context, String tipo) {
    String titulo = '';
    String contenido = '';

    switch (tipo) {
      case 'votar':
        titulo = 'Cómo votar correctamente';
        contenido = '''
1. Llega temprano a tu local de votación
2. Presenta tu DNI original al miembro de mesa
3. Recibe tus cédulas de sufragio
4. Dirígete a la cámara secreta
5. Marca con una X tu preferencia
6. Dobla la cédula
7. Deposítala en el ánfora
8. Recibe tu constancia de sufragio

¡Recuerda! Solo marca UNA opción por cédula.
        ''';
        break;
      case 'local':
        titulo = 'Encontrar mi local de votación';
        contenido = '''
Puedes consultar tu local de votación de 3 formas:

1. En esta app:
   - Ve a tu Perfil
   - Selecciona "Mi Local de Votación"

2. En la web de ONPE:
   - Visita www.onpe.gob.pe
   - Ingresa tu DNI

3. Por teléfono:
   - Llama al 311-4700
   - Proporciona tu DNI
        ''';
        break;
      case 'miembro':
        titulo = 'Ser miembro de mesa';
        contenido = '''
Como miembro de mesa debes:

1. Asistir a la capacitación obligatoria
2. Llegar 1 hora antes de la apertura
3. Verificar identidad de electores
4. Entregar cédulas de sufragio
5. Realizar el conteo de votos
6. Firmar las actas electorales

Recibirás:
• Capacitación gratuita
• Refrigerio
• Pago de S/ 120.00 aprox.
• Certificado de participación
        ''';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: Text(
            contenido,
            style: const TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioReporte(BuildContext context, String tipo) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tipo == 'error' ? 'Reportar Error' : 'Enviar Sugerencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tipo == 'error'
                  ? 'Describe el error que encontraste:'
                  : 'Comparte tu sugerencia:',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: tipo == 'error'
                    ? 'Ej: La app se cierra al...'
                    : 'Ej: Sería útil si...',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tipo == 'error'
                        ? 'Reporte enviado. ¡Gracias por tu ayuda!'
                        : 'Sugerencia enviada. ¡Gracias!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _mostrarProximamente(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text(
          'El chat en vivo estará disponible pronto.\n\n'
          'Por ahora puedes contactarnos por teléfono o email.',
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
}
