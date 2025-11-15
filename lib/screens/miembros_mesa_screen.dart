import 'package:flutter/material.dart';
import '../models/miembro_mesa.dart';
import '../services/miembros_mesa_service.dart';
import 'miembro_mesa_detalle_screen.dart';
import 'info_miembros_mesa_screen.dart';

class MiembrosMesaScreen extends StatefulWidget {
  const MiembrosMesaScreen({super.key});

  @override
  State<MiembrosMesaScreen> createState() => _MiembrosMesaScreenState();
}

class _MiembrosMesaScreenState extends State<MiembrosMesaScreen> with SingleTickerProviderStateMixin {
  final MiembrosMesaService _service = MiembrosMesaService();
  final TextEditingController _dniController = TextEditingController();
  
  late TabController _tabController;
  List<MiembroMesa> _miembros = [];
  List<MiembroMesa> _miembrosFiltrados = [];
  bool _isLoading = true;
  String _filtroDistrito = 'Todos';
  MiembroMesa? _miembroBuscado;
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarMiembros();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  Future<void> _cargarMiembros() async {
    setState(() => _isLoading = true);
    try {
      final miembros = await _service.obtenerMiembros();
      setState(() {
        _miembros = miembros;
        _miembrosFiltrados = miembros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarPorDistrito(String distrito) {
    setState(() {
      _filtroDistrito = distrito;
      if (distrito == 'Todos') {
        _miembrosFiltrados = _miembros;
      } else {
        _miembrosFiltrados = _miembros
            .where((m) => m.distrito == distrito)
            .toList();
      }
    });
  }

  Future<void> _buscarPorDni() async {
    final dni = _dniController.text.trim();
    if (dni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un DNI')),
      );
      return;
    }

    if (dni.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El DNI debe tener 8 dígitos')),
      );
      return;
    }

    setState(() => _buscando = true);

    try {
      final miembro = await _service.buscarPorDni(dni);
      setState(() {
        _miembroBuscado = miembro;
        _buscando = false;
      });

      if (miembro != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MiembroMesaDetalleScreen(miembro: miembro),
          ),
        );
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('No encontrado'),
              content: Text('El DNI $dni no está registrado como miembro de mesa.'),
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
    } catch (e) {
      setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final distritos = ['Todos', 'Chimbote', 'Nuevo Chimbote'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        title: const Text('Miembros de Mesa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfoMiembrosMesaScreen(),
                ),
              );
            },
            tooltip: 'Información general',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Buscar por DNI'),
            Tab(text: 'Ver Todos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBusquedaTab(),
          _buildListaTab(distritos),
        ],
      ),
    );
  }

  Widget _buildBusquedaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: Color(0xFF7C4DFF),
          ),
          const SizedBox(height: 16),
          const Text(
            '¿Eres miembro de mesa?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tu DNI para verificar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _dniController,
            keyboardType: TextInputType.number,
            maxLength: 8,
            decoration: InputDecoration(
              labelText: 'Número de DNI',
              hintText: '12345678',
              prefixIcon: const Icon(Icons.badge, color: Color(0xFF7C4DFF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _buscando ? null : _buscarPorDni,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buscando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Buscar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  'Si eres miembro de mesa, aquí encontrarás:\n'
                  '• Tu mesa asignada\n'
                  '• Local de votación\n'
                  '• Tu cargo (Presidente, Secretario, etc.)\n'
                  '• Información sobre compensación',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaTab(List<String> distritos) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 20),
              const SizedBox(width: 8),
              const Text('Filtrar por distrito:'),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: distritos.map((distrito) {
                      final isSelected = _filtroDistrito == distrito;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(distrito),
                          selected: isSelected,
                          onSelected: (selected) => _filtrarPorDistrito(distrito),
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF7C4DFF).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF7C4DFF) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _miembrosFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No hay miembros de mesa',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _miembrosFiltrados.length,
                      itemBuilder: (context, index) {
                        final miembro = _miembrosFiltrados[index];
                        return _MiembroCard(
                          miembro: miembro,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MiembroMesaDetalleScreen(miembro: miembro),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _MiembroCard extends StatelessWidget {
  final MiembroMesa miembro;
  final VoidCallback onTap;

  const _MiembroCard({
    required this.miembro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getColorByCargo(miembro.cargo).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconByCargo(miembro.cargo),
                  color: _getColorByCargo(miembro.cargo),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      miembro.nombreCompleto,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DNI: ${miembro.dni}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getColorByCargo(miembro.cargo).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            miembro.cargoDescripcion,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getColorByCargo(miembro.cargo),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mesa ${miembro.numeroMesa}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF7C4DFF),
              ),
            ],
          ),
        ),
      ),
    );
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
