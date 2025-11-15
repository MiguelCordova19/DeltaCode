import 'package:flutter/material.dart';
import '../models/miembro_mesa.dart';
import 'tutorial_por_cargo_screen.dart';

class MiembroMesaDetalleScreen extends StatelessWidget {
  final MiembroMesa miembro;

  const MiembroMesaDetalleScreen({
    super.key,
    required this.miembro,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Detalle Miembro de Mesa'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con información principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFE53935),
                    const Color(0xFFE53935).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconByCargo(miembro.cargo),
                      size: 48,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    miembro.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      miembro.cargoDescripcion,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información personal
                  _buildSection(
                    title: 'Información Personal',
                    icon: Icons.person,
                    children: [
                      _buildInfoRow('DNI', miembro.dni),
                      _buildInfoRow('Nombres', miembro.nombres),
                      _buildInfoRow('Apellidos', miembro.apellidos),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Información de la mesa
                  _buildSection(
                    title: 'Información de la Mesa',
                    icon: Icons.how_to_vote,
                    children: [
                      _buildInfoRow('Mesa N.º', miembro.numeroMesa.toString()),
                      _buildInfoRow('Cargo', miembro.cargoDescripcion),
                      _buildInfoRow('Local', miembro.localVotacion),
                      _buildInfoRow('Dirección', miembro.direccionLocal),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Ubicación
                  _buildSection(
                    title: 'Ubicación',
                    icon: Icons.location_on,
                    children: [
                      _buildInfoRow('Distrito', miembro.distrito),
                      _buildInfoRow('Provincia', miembro.provincia),
                      _buildInfoRow('Departamento', miembro.departamento),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Funciones del cargo
                  _buildSection(
                    title: 'Funciones de tu Cargo',
                    icon: Icons.assignment,
                    children: [
                      Text(
                        InfoMiembroMesa.funcionesPorCargo[
                            miembro.cargoDescripcion.split(' ').first] ??
                            'Sin información',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Compensación
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.green,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Compensación Económica',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                InfoMiembroMesa.compensacionEconomica,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Por cumplir tu cargo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón de tutorial específico para tu cargo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorialPorCargoScreen(cargo: miembro.cargo),
                          ),
                        );
                      },
                      icon: const Icon(Icons.school),
                      label: Text('Tutorial para ${miembro.cargoDescripcion}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getColorByCargo(miembro.cargo),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botones de acción
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navegar a información completa
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Ver Derechos y Obligaciones'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFE53935), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
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
}
