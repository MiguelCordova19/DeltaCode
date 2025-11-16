import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class PrivacidadSeguridadScreen extends StatefulWidget {
  const PrivacidadSeguridadScreen({super.key});

  @override
  State<PrivacidadSeguridadScreen> createState() =>
      _PrivacidadSeguridadScreenState();
}

class _PrivacidadSeguridadScreenState extends State<PrivacidadSeguridadScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  final AuthService _authService = AuthService();

  bool _compartirDatosAnonimos = true;
  bool _permitirAnalytics = true;
  bool _guardarHistorial = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Privacidad y Seguridad'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información importante
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFE53935),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tu privacidad es importante. Controla cómo se usan tus datos.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Privacidad de Datos
            _buildSectionTitle('Privacidad de Datos'),
            const SizedBox(height: 12),
            _buildPrivacyOption(
              icon: Icons.analytics_outlined,
              title: 'Compartir datos anónimos',
              subtitle: 'Ayuda a mejorar la app compartiendo datos de uso anónimos',
              value: _compartirDatosAnonimos,
              onChanged: (value) {
                setState(() => _compartirDatosAnonimos = value);
              },
            ),
            const SizedBox(height: 12),
            _buildPrivacyOption(
              icon: Icons.bar_chart,
              title: 'Permitir análisis de uso',
              subtitle: 'Permite analizar cómo usas la app para mejorarla',
              value: _permitirAnalytics,
              onChanged: (value) {
                setState(() => _permitirAnalytics = value);
              },
            ),
            const SizedBox(height: 12),
            _buildPrivacyOption(
              icon: Icons.history,
              title: 'Guardar historial de búsquedas',
              subtitle: 'Guarda tu historial para sugerencias personalizadas',
              value: _guardarHistorial,
              onChanged: (value) {
                setState(() => _guardarHistorial = value);
              },
            ),
            const SizedBox(height: 24),

            // Gestión de Datos
            _buildSectionTitle('Gestión de Datos'),
            const SizedBox(height: 12),
            _buildActionCard(
              icon: Icons.download_outlined,
              title: 'Descargar mis datos',
              subtitle: 'Obtén una copia de tu información personal',
              color: const Color(0xFFE53935),
              onTap: () => _descargarDatos(context),
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              icon: Icons.delete_outline,
              title: 'Eliminar historial',
              subtitle: 'Borra tu historial de búsquedas y navegación',
              color: const Color(0xFFFF6F00),
              onTap: () => _eliminarHistorial(context),
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              icon: Icons.delete_forever,
              title: 'Eliminar mi cuenta',
              subtitle: 'Elimina permanentemente todos tus datos',
              color: const Color(0xFFD32F2F),
              onTap: () => _eliminarCuenta(context),
            ),
            const SizedBox(height: 24),

            // Seguridad
            _buildSectionTitle('Seguridad'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.lock_outline,
              title: 'Datos encriptados',
              description: 'Tus datos personales están protegidos con encriptación',
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.verified_user_outlined,
              title: 'Autenticación segura',
              description: 'Usamos métodos seguros para verificar tu identidad',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.cloud_off_outlined,
              title: 'Almacenamiento local',
              description: 'Tus datos se guardan solo en tu dispositivo',
              color: Colors.purple,
            ),
            const SizedBox(height: 24),

            // Políticas
            _buildSectionTitle('Políticas y Términos'),
            const SizedBox(height: 12),
            _buildLinkCard(
              icon: Icons.description_outlined,
              title: 'Política de Privacidad',
              onTap: () => _mostrarPoliticaPrivacidad(context),
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              icon: Icons.gavel_outlined,
              title: 'Términos y Condiciones',
              onTap: () => _mostrarTerminos(context),
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              icon: Icons.cookie_outlined,
              title: 'Política de Cookies',
              onTap: () => _mostrarPoliticaCookies(context),
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
        color: Color(0xFFE53935),
      ),
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE53935),
            size: 24,
          ),
        ),
        activeColor: const Color(0xFFE53935),
        activeTrackColor: const Color(0xFFE53935).withOpacity(0.5),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE53935).withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFE53935), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFE53935).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  // Acciones
  Future<void> _descargarDatos(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download, color: Color(0xFFE53935)),
            SizedBox(width: 12),
            Text('Descargar Datos'),
          ],
        ),
        content: const Text(
          'Se generará un archivo con toda tu información personal. '
          'Este archivo incluirá:\n\n'
          '• Datos personales\n'
          '• Historial de búsquedas\n'
          '• Configuraciones\n'
          '• Preferencias\n\n'
          '¿Deseas continuar?',
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
                const SnackBar(
                  content: Text('Descarga iniciada. Revisa tus descargas.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarHistorial(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Color(0xFFFF6F00)),
            SizedBox(width: 12),
            Text('Eliminar Historial'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todo tu historial?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6F00),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Historial eliminado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _eliminarCuenta(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFFD32F2F)),
            SizedBox(width: 12),
            Text('Eliminar Cuenta'),
          ],
        ),
        content: const Text(
          '⚠️ ADVERTENCIA ⚠️\n\n'
          'Esta acción eliminará permanentemente:\n\n'
          '• Todos tus datos personales\n'
          '• Tu historial completo\n'
          '• Todas tus configuraciones\n'
          '• Tu cuenta de usuario\n\n'
          'Esta acción NO se puede deshacer.\n\n'
          '¿Estás completamente seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Eliminar Cuenta'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Eliminar todos los datos
      await _usuarioService.limpiarUsuario();
      await _authService.logout();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _mostrarPoliticaPrivacidad(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Última actualización: Noviembre 2024\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildPolicySection(
                '1. Información que Recopilamos',
                'Recopilamos información personal como DNI, nombre, correo electrónico y datos de ubicación para brindarte un mejor servicio electoral.',
              ),
              _buildPolicySection(
                '2. Uso de la Información',
                'Usamos tu información para personalizar tu experiencia, enviarte notificaciones relevantes y mejorar nuestros servicios.',
              ),
              _buildPolicySection(
                '3. Protección de Datos',
                'Implementamos medidas de seguridad para proteger tu información personal contra acceso no autorizado.',
              ),
              _buildPolicySection(
                '4. Compartir Información',
                'No compartimos tu información personal con terceros sin tu consentimiento explícito.',
              ),
              _buildPolicySection(
                '5. Tus Derechos',
                'Tienes derecho a acceder, corregir o eliminar tu información personal en cualquier momento.',
              ),
            ],
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

  void _mostrarTerminos(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Última actualización: Noviembre 2024\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildPolicySection(
                '1. Aceptación de Términos',
                'Al usar esta aplicación, aceptas estos términos y condiciones en su totalidad.',
              ),
              _buildPolicySection(
                '2. Uso Apropiado',
                'Te comprometes a usar la aplicación solo para fines informativos y educativos sobre el proceso electoral.',
              ),
              _buildPolicySection(
                '3. Contenido',
                'El contenido proporcionado es solo informativo. Verifica siempre con fuentes oficiales.',
              ),
              _buildPolicySection(
                '4. Responsabilidad',
                'No nos hacemos responsables por decisiones tomadas basándose únicamente en la información de la app.',
              ),
              _buildPolicySection(
                '5. Modificaciones',
                'Nos reservamos el derecho de modificar estos términos en cualquier momento.',
              ),
            ],
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

  void _mostrarPoliticaCookies(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Cookies'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Última actualización: Noviembre 2024\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildPolicySection(
                '1. ¿Qué son las Cookies?',
                'Las cookies son pequeños archivos de texto que se almacenan en tu dispositivo para mejorar tu experiencia.',
              ),
              _buildPolicySection(
                '2. Cookies que Usamos',
                'Usamos cookies esenciales para el funcionamiento de la app y cookies analíticas para mejorar nuestros servicios.',
              ),
              _buildPolicySection(
                '3. Control de Cookies',
                'Puedes controlar el uso de cookies desde la configuración de privacidad de la aplicación.',
              ),
              _buildPolicySection(
                '4. Cookies de Terceros',
                'Algunos servicios de terceros pueden usar cookies. Consulta sus políticas para más información.',
              ),
            ],
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

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
