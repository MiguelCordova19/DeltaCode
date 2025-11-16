import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../models/usuario.dart';
import '../providers/idioma_provider.dart';
import '../utils/translations.dart';
import '../widgets/monedas_widget.dart';
import 'login_screen.dart';
import 'informacion_personal_screen.dart';
import 'notificaciones_config_screen.dart';
import 'configuracion_idioma_screen.dart';
import 'configuracion_audio_screen.dart';
import 'curiosidades_screen.dart';
import 'acerca_de_screen.dart';
import 'locales_votacion_screen.dart';
import 'privacidad_seguridad_screen.dart';
import 'ayuda_soporte_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
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

  Future<void> _handleLogout() async {
    final idioma = Provider.of<IdiomaProvider>(context, listen: false).locale.languageCode;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Translations.get('logout', idioma)),
        content: Text(
          idioma == 'qu' 
            ? '¿Chiqachu lluqsiyta munankichik?'
            : '¿Estás seguro que deseas cerrar sesión?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(idioma == 'qu' ? 'Mana' : 'Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            child: Text(Translations.get('logout', idioma)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final idioma = Provider.of<IdiomaProvider>(context).locale.languageCode;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          Translations.get('myProfile', idioma),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nombre
                      Text(
                        _usuario?.nombreCompleto ?? 'Usuario Electoral',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _usuario?.email ?? 'usuario@email.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_usuario?.dni != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'DNI: ${_usuario!.dni}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      
                      // Widget de monedas
                      const MonedasWidget(),
                      
                      const SizedBox(height: 32),

                      // Opciones de perfil
                      _buildProfileOption(
                        icon: Icons.person_outline,
                        title: Translations.get('personalInfo', idioma),
                        subtitle: Translations.get('personalInfoSubtitle', idioma),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const InformacionPersonalScreen(),
                            ),
                          );
                          _cargarDatos(); // Recargar datos al volver
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.notifications_outlined,
                        title: Translations.get('notifications', idioma),
                        subtitle: Translations.get('notificationsSubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificacionesConfigScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.language_outlined,
                        title: Translations.get('appLanguage', idioma),
                        subtitle: Translations.get('appLanguageSubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ConfiguracionIdiomaScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.volume_up_outlined,
                        title: Translations.get('audioConfig', idioma),
                        subtitle: Translations.get('audioConfigSubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ConfiguracionAudioScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.security_outlined,
                        title: Translations.get('privacySecurity', idioma),
                        subtitle: Translations.get('privacySecuritySubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrivacidadSeguridadScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        title: Translations.get('helpSupport', idioma),
                        subtitle: Translations.get('helpSupportSubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AyudaSoporteScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.info_outline,
                        title: Translations.get('about', idioma),
                        subtitle: Translations.get('aboutSubtitle', idioma),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AcercaDeScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileOption(
                        icon: Icons.logout,
                        title: Translations.get('logout', idioma),
                        subtitle: Translations.get('logoutSubtitle', idioma),
                        onTap: _handleLogout,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _mostrarProximamente(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text(
            'Esta función estará disponible en una próxima actualización.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
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
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? const Color(0xFFE53935) : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDestructive ? const Color(0xFFE53935).withOpacity(0.7) : Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: const Color(0xFFE53935).withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
