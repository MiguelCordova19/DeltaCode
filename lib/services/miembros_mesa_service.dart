import '../models/miembro_mesa.dart';

class MiembrosMesaService {
  // Datos de ejemplo de miembros de mesa en Chimbote
  static final List<MiembroMesa> _miembrosEjemplo = [
    MiembroMesa(
      id: 'mm_001',
      nombres: 'Juan Carlos',
      apellidos: 'Rodríguez Pérez',
      dni: '45678901',
      numeroMesa: 58,
      cargo: CargoMesa.presidente,
      localVotacion: 'I.E. San Pedro',
      direccionLocal: 'Av. José Pardo 850',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_002',
      nombres: 'María Elena',
      apellidos: 'Torres Vega',
      dni: '46789012',
      numeroMesa: 58,
      cargo: CargoMesa.secretario,
      localVotacion: 'I.E. San Pedro',
      direccionLocal: 'Av. José Pardo 850',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_003',
      nombres: 'Pedro Luis',
      apellidos: 'Sánchez Flores',
      dni: '47890123',
      numeroMesa: 58,
      cargo: CargoMesa.tercerMiembro,
      localVotacion: 'I.E. San Pedro',
      direccionLocal: 'Av. José Pardo 850',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_004',
      nombres: 'Ana Patricia',
      apellidos: 'Gómez Ríos',
      dni: '48901234',
      numeroMesa: 59,
      cargo: CargoMesa.presidente,
      localVotacion: 'I.E. San Pedro',
      direccionLocal: 'Av. José Pardo 850',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_005',
      nombres: 'Roberto Carlos',
      apellidos: 'Mendoza Silva',
      dni: '49012345',
      numeroMesa: 125,
      cargo: CargoMesa.presidente,
      localVotacion: 'Colegio Politécnico de Chimbote',
      direccionLocal: 'Av. Pacífico 508',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_006',
      nombres: 'Carmen Rosa',
      apellidos: 'Díaz Morales',
      dni: '50123456',
      numeroMesa: 125,
      cargo: CargoMesa.secretario,
      localVotacion: 'Colegio Politécnico de Chimbote',
      direccionLocal: 'Av. Pacífico 508',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_007',
      nombres: 'Luis Fernando',
      apellidos: 'Castro Ramírez',
      dni: '51234567',
      numeroMesa: 125,
      cargo: CargoMesa.tercerMiembro,
      localVotacion: 'Colegio Politécnico de Chimbote',
      direccionLocal: 'Av. Pacífico 508',
      distrito: 'Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_008',
      nombres: 'Sandra Milagros',
      apellidos: 'Vargas León',
      dni: '52345678',
      numeroMesa: 210,
      cargo: CargoMesa.presidente,
      localVotacion: 'Universidad César Vallejo',
      direccionLocal: 'Av. Guardia Civil 1840',
      distrito: 'Nuevo Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_009',
      nombres: 'Jorge Alberto',
      apellidos: 'Paredes Huamán',
      dni: '53456789',
      numeroMesa: 210,
      cargo: CargoMesa.secretario,
      localVotacion: 'Universidad César Vallejo',
      direccionLocal: 'Av. Guardia Civil 1840',
      distrito: 'Nuevo Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
    MiembroMesa(
      id: 'mm_010',
      nombres: 'Rosa María',
      apellidos: 'Campos Ortiz',
      dni: '54567890',
      numeroMesa: 210,
      cargo: CargoMesa.tercerMiembro,
      localVotacion: 'Universidad César Vallejo',
      direccionLocal: 'Av. Guardia Civil 1840',
      distrito: 'Nuevo Chimbote',
      provincia: 'Santa',
      departamento: 'Áncash',
    ),
  ];

  // Obtener todos los miembros de mesa
  Future<List<MiembroMesa>> obtenerMiembros() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _miembrosEjemplo;
  }

  // Buscar miembro por DNI
  Future<MiembroMesa?> buscarPorDni(String dni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _miembrosEjemplo.firstWhere((m) => m.dni == dni);
    } catch (e) {
      return null;
    }
  }

  // Obtener miembros por mesa
  Future<List<MiembroMesa>> obtenerPorMesa(int numeroMesa) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _miembrosEjemplo.where((m) => m.numeroMesa == numeroMesa).toList();
  }

  // Obtener miembros por local de votación
  Future<List<MiembroMesa>> obtenerPorLocal(String localVotacion) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _miembrosEjemplo
        .where((m) => m.localVotacion.toLowerCase().contains(localVotacion.toLowerCase()))
        .toList();
  }

  // Obtener miembros por distrito
  Future<List<MiembroMesa>> obtenerPorDistrito(String distrito) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _miembrosEjemplo
        .where((m) => m.distrito.toLowerCase() == distrito.toLowerCase())
        .toList();
  }

  // Verificar si un DNI es miembro de mesa
  Future<bool> esMiembroMesa(String dni) async {
    final miembro = await buscarPorDni(dni);
    return miembro != null;
  }
}
