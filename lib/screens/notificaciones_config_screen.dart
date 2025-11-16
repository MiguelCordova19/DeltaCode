import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class NotificacionesConfigScreen extends StatefulWidget {
  const NotificacionesConfigScreen({super.key});

  @override
  State<NotificacionesConfigScreen> createState() =>
      _NotificacionesConfigScreenState();
}

class _NotificacionesConfigScreenState
    extends State<NotificacionesConfigScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuario = await _usuarioService.obtenerUsuario();
    if (usuario != null && mounted) {
      setState(() {
        _usuario = usuario;
        _isLoading = false;
      });
    }
  }

  Future<void> _actualizarConfiguracion(String campo, bool valor) async {
    await _usuarioService.actualizarCampo(campo, valor);
    setState(() {
      switch (campo) {
        case 'notificacionesActivas':
          _usuario!.notificacionesActivas = valor;
          break;
        case 'notificacionesEmail':
          _usuario!.notificacionesEmail = valor;
          break;
        case 'notificacionesPush':
          _usuario!.notificacionesPush = valor;
          break;
        case 'recordatoriosElectorales':
          _usuario!.recordatoriosElectorales = valor;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Notificaciones'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Configura cómo deseas recibir información sobre el proceso electoral',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notificaciones generales
                  _buildSectionTitle('Notificaciones Generales'),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    title: 'Activar Notificaciones',
                    subtitle: 'Recibe todas las notificaciones de la app',
                    icon: Icons.notifications_active,
                    value: _usuario!.notificacionesActivas,
                    onChanged: (value) =>
                        _actualizarConfiguracion('notificacionesActivas', value),
                  ),
                  const SizedBox(height: 24),

                  // Canales de notificación
                  _buildSectionTitle('Canales de Notificación'),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    title: 'Notificaciones Push',
                    subtitle: 'Recibe alertas en tu dispositivo',
                    icon: Icons.phone_android,
                    value: _usuario!.notificacionesPush,
                    onChanged: _usuario!.notificacionesActivas
                        ? (value) => _actualizarConfiguracion(
                            'notificacionesPush', value)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    title: 'Notificaciones por Email',
                    subtitle: 'Recibe información en tu correo',
                    icon: Icons.email,
                    value: _usuario!.notificacionesEmail,
                    onChanged: _usuario!.notificacionesActivas
                        ? (value) => _actualizarConfiguracion(
                            'notificacionesEmail', value)
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Recordatorios
                  _buildSectionTitle('Recordatorios'),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    title: 'Recordatorios Electorales',
                    subtitle:
                        'Recibe recordatorios sobre fechas importantes',
                    icon: Icons.calendar_today,
                    value: _usuario!.recordatoriosElectorales,
                    onChanged: _usuario!.notificacionesActivas
                        ? (value) => _actualizarConfiguracion(
                            'recordatoriosElectorales', value)
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: Colors.grey[700], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Tipos de notificaciones',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoItem('📅 Fechas límite de inscripción'),
                        _buildInfoItem('🗳️ Recordatorios de elecciones'),
                        _buildInfoItem('📢 Noticias electorales importantes'),
                        _buildInfoItem('👥 Información sobre miembros de mesa'),
                        _buildInfoItem('📍 Cambios en locales de votación'),
                      ],
                    ),
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    final isDisabled = onChanged == null;

    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDisabled ? Colors.grey[300]! : Colors.grey[300]!,
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDisabled ? Colors.grey[500] : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDisabled ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        secondary: Icon(
          icon,
          color: isDisabled ? Colors.grey[400] : const Color(0xFF7C4DFF),
        ),
        activeColor: const Color(0xFF7C4DFF),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
