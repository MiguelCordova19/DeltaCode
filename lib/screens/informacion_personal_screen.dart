import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class InformacionPersonalScreen extends StatefulWidget {
  const InformacionPersonalScreen({super.key});

  @override
  State<InformacionPersonalScreen> createState() =>
      _InformacionPersonalScreenState();
}

class _InformacionPersonalScreenState extends State<InformacionPersonalScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;
  late TextEditingController _distritoController;
  late TextEditingController _provinciaController;
  late TextEditingController _departamentoController;

  Usuario? _usuario;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _telefonoController = TextEditingController();
    _direccionController = TextEditingController();
    _distritoController = TextEditingController();
    _provinciaController = TextEditingController();
    _departamentoController = TextEditingController();
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _distritoController.dispose();
    _provinciaController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final usuario = await _usuarioService.obtenerUsuario();
    if (usuario != null && mounted) {
      setState(() {
        _usuario = usuario;
        _nombresController.text = usuario.nombres;
        _apellidosController.text = usuario.apellidos;
        _emailController.text = usuario.email ?? '';
        _telefonoController.text = usuario.telefono ?? '';
        _direccionController.text = usuario.direccion ?? '';
        _distritoController.text = usuario.distrito ?? '';
        _provinciaController.text = usuario.provincia ?? '';
        _departamentoController.text = usuario.departamento ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Solo actualizar email y teléfono
    _usuario!.email = _emailController.text.trim();
    _usuario!.telefono = _telefonoController.text.trim();

    final success = await _usuarioService.guardarUsuario(_usuario!);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Información actualizada correctamente'
                : 'Error al guardar los cambios',
          ),
          backgroundColor: success ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
        ),
      );

      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Información Personal'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DNI (no editable)
                    _buildInfoCard(
                      icon: Icons.badge,
                      title: 'DNI',
                      value: _usuario!.dni,
                      isEditable: false,
                    ),
                    const SizedBox(height: 16),

                    // Datos Personales (no editables)
                    _buildSectionTitle('Datos Personales'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.person,
                      title: 'Nombres',
                      value: _usuario!.nombres,
                      isEditable: false,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.person,
                      title: 'Apellidos',
                      value: _usuario!.apellidos,
                      isEditable: false,
                    ),
                    const SizedBox(height: 24),

                    // Datos de Contacto (editables)
                    _buildSectionTitle('Datos de Contacto'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !value.contains('@')) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _telefonoController,
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),

                    // Dirección (no editable)
                    _buildSectionTitle('Dirección'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.home,
                      title: 'Dirección',
                      value: _usuario!.direccion ?? 'No registrada',
                      isEditable: false,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.location_city,
                      title: 'Distrito',
                      value: _usuario!.distrito ?? 'No registrado',
                      isEditable: false,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Provincia',
                      value: _usuario!.provincia ?? 'No registrada',
                      isEditable: false,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.map,
                      title: 'Departamento',
                      value: _usuario!.departamento ?? 'No registrado',
                      isEditable: false,
                    ),
                    const SizedBox(height: 32),

                    // Nota informativa
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Solo puedes editar tu correo y teléfono. Los demás datos están protegidos.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botón guardar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _guardarCambios,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Guardar Cambios',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isEditable = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFE53935), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
          if (!isEditable)
            Icon(
              Icons.lock_outline,
              size: 20,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE53935)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
